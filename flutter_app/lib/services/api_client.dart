// lib/services/api_client.dart
// Singleton Dio HTTP client với JWT auth interceptor + auto token refresh.

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/api_models.dart';

class ApiClient {
  ApiClient._();
  static final ApiClient instance = ApiClient._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  late final Dio _dio = _buildDio();

  Dio get dio => _dio;

  // Callback để thông báo cho app khi session hết hạn (về màn login)
  void Function()? onSessionExpired;

  Dio _buildDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBase,
        connectTimeout: AppConfig.connectTimeout,
        receiveTimeout: AppConfig.receiveTimeout,
        sendTimeout: AppConfig.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    dio.interceptors.add(_AuthInterceptor(client: this));
    return dio;
  }

  // ── Token management ────────────────────────────────────────────────────────

  Future<String?> getAccessToken() =>
      _storage.read(key: AppConfig.kAccessToken);

  Future<String?> getRefreshToken() =>
      _storage.read(key: AppConfig.kRefreshToken);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: AppConfig.kAccessToken, value: accessToken);
    await _storage.write(key: AppConfig.kRefreshToken, value: refreshToken);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  // ── Convenience HTTP methods ─────────────────────────────────────────────────

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? params}) =>
      _dio.get<T>(path, queryParameters: params);

  Future<Response<T>> post<T>(String path, {dynamic data}) =>
      _dio.post<T>(path, data: data);

  Future<Response<T>> patch<T>(String path, {dynamic data}) =>
      _dio.patch<T>(path, data: data);

  Future<Response<T>> delete<T>(String path) => _dio.delete<T>(path);

  /// Chuyển DioException → ApiError
  static ApiError handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.unknown) {
      return ApiError.network();
    }
    if (e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return ApiError.timeout();
    }
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      return ApiError.fromJson(data, statusCode: e.response?.statusCode);
    }
    return ApiError(
      code: 'HTTP_${e.response?.statusCode ?? 0}',
      message: e.message ?? 'Có lỗi xảy ra',
      statusCode: e.response?.statusCode,
    );
  }
}

// ── Auth Interceptor ─────────────────────────────────────────────────────────

class _AuthInterceptor extends Interceptor {
  final ApiClient client;
  bool _isRefreshing = false;
  final List<RequestOptions> _pendingRequests = [];

  _AuthInterceptor({required this.client});

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await client.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // Tránh vòng lặp: nếu chính request refresh bị 401 → session expired
    if (err.requestOptions.path.contains(AppConfig.epRefresh)) {
      await client.clearTokens();
      client.onSessionExpired?.call();
      return handler.next(err);
    }

    if (_isRefreshing) {
      // Queue request này lại, đợi refresh xong
      _pendingRequests.add(err.requestOptions);
      return;
    }

    _isRefreshing = true;
    try {
      final refreshToken = await client.getRefreshToken();
      if (refreshToken == null) {
        await client.clearTokens();
        client.onSessionExpired?.call();
        return handler.next(err);
      }

      final refreshResp = await Dio().post(
        '${AppConfig.apiBase}${AppConfig.epRefresh}',
        data: {'refreshToken': refreshToken},
      );
      final newAccessToken = refreshResp.data['accessToken'] as String;
      await client._storage.write(
        key: AppConfig.kAccessToken,
        value: newAccessToken,
      );

      // Retry request gốc với token mới
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      final retryResp = await client.dio.fetch(err.requestOptions);

      // Retry các request đang pending
      for (final req in _pendingRequests) {
        req.headers['Authorization'] = 'Bearer $newAccessToken';
        client.dio.fetch(req).ignore();
      }
      _pendingRequests.clear();

      return handler.resolve(retryResp);
    } catch (_) {
      await client.clearTokens();
      client.onSessionExpired?.call();
      _pendingRequests.clear();
      return handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }
}
