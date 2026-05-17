// lib/services/auth_service.dart
// Service xác thực — gọi API thật, không có mock fallback.
// Nếu server chưa có → throw ApiError.network() → UI hiện thông báo lỗi.

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/app_config.dart';
import '../models/models.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class AuthService {
  Future<AuthResult> login(String email, String password);
  Future<void> logout();
  Future<void> changePassword(String currentPassword, String newPassword);
  Future<UserProfile?> getStoredUser();
  Future<UserProfile?> fetchProfile();
  Future<bool> hasValidToken();
}

class RemoteAuthService implements AuthService {
  final ApiClient _client;
  final FlutterSecureStorage _storage;

  RemoteAuthService(this._client)
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(encryptedSharedPreferences: true),
        );

  @override
  Future<AuthResult> login(String email, String password) async {
    try {
      final resp = await _client.post(
        AppConfig.epLogin,
        data: {'email': email.trim(), 'password': password},
      );
      final raw = resp.data as Map<String, dynamic>;
      final result = AuthResult.fromJson(raw);

      // Lưu tokens
      await _client.saveTokens(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
      );
      // Lưu priest id (cId) để dùng cho các API khác
      await _storage.write(
        key: AppConfig.kPriestId,
        value: result.priest.id,
      );

      // Thử fetch full profile sau login để có thêm thông tin chi tiết
      UserProfile fullProfile = result.priest;
      try {
        final fetched = await fetchProfile();
        if (fetched != null) {
          fullProfile = fetched;
        }
      } catch (_) {
        // Không nghiêm trọng — dùng userInfo từ login là đủ
      }

      // Cache profile đầy đủ vào secure storage
      await _storage.write(
        key: AppConfig.kPriestProfile,
        value: jsonEncode(fullProfile.toJson()),
      );

      return AuthResult(
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        expiresIn: result.expiresIn,
        priest: fullProfile,
      );
    } on Exception catch (e) {
      if (e is AuthServiceException) rethrow;
      throw ApiClient.handleDioError(e as dynamic);
    }
  }

  /// Fetch full priest profile từ server (sau khi đã có token)
  @override
  Future<UserProfile?> fetchProfile() async {
    try {
      final resp = await _client.get(AppConfig.epPriestProfile);
      final raw = resp.data;
      Map<String, dynamic>? data;
      if (raw is Map<String, dynamic>) {
        // Real API: { status, statusCode, payload: {...} }
        data = raw['payload'] as Map<String, dynamic>? ??
            raw['data'] as Map<String, dynamic>? ??
            raw;
      }
      if (data != null) {
        return UserProfile.fromPriestDetail(data);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> logout() async {
    try {
      // Gọi API logout nếu có endpoint (optional)
      // await _client.post(AppConfig.epLogout);
    } catch (_) {
      // Kể cả khi server lỗi vẫn xoá token local
    } finally {
      await _client.clearTokens();
    }
  }

  @override
  Future<void> changePassword(
    String currentPassword,
    String newPassword,
  ) async {
    try {
      await _client.post(
        AppConfig.epChangePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
    } on Exception catch (e) {
      throw ApiClient.handleDioError(e as dynamic);
    }
  }

  @override
  Future<UserProfile?> getStoredUser() async {
    final cached = await _storage.read(key: AppConfig.kPriestProfile);
    if (cached != null) {
      try {
        return UserProfile.fromJson(
          jsonDecode(cached) as Map<String, dynamic>,
        );
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<bool> hasValidToken() => _client.hasValidToken();
}

class AuthServiceException implements Exception {
  final String message;
  const AuthServiceException(this.message);
  @override
  String toString() => message;
}
