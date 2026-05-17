// lib/services/mass_request_service.dart
// Service gửi và lấy danh sách yêu cầu dâng lễ.

import '../core/app_config.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class MassRequestService {
  Future<MassRequest> submitRequest(MassRequestPayload payload);
  Future<List<MassRequest>> getRequests({String? status});
  Future<void> approveRequest(String requestId);
  Future<void> rejectRequest(String requestId, {String? reason});
}

class RemoteMassRequestService implements MassRequestService {
  final ApiClient _client;
  RemoteMassRequestService(this._client);

  @override
  Future<MassRequest> submitRequest(MassRequestPayload payload) async {
    try {
      final resp = await _client.post(
        AppConfig.epMassRequests,
        data: payload.toJson(),
      );
      return MassRequest.fromJson(resp.data as Map<String, dynamic>);
    } on Exception catch (e) {
      final apiErr = ApiClient.handleDioError(e as dynamic);
      if (apiErr.isNetworkError) {
        // Mock: trả về record giả thành công khi server chưa có
        return MassRequest(
          id: 'MR-PENDING-${DateTime.now().millisecondsSinceEpoch}',
          massType: payload.massType,
          scheduledAt: payload.scheduledAt,
          location: payload.location,
          intention: payload.intention,
          status: 'pending',
          createdAt: DateTime.now().toIso8601String(),
        );
      }
      throw apiErr;
    }
  }

  @override
  Future<List<MassRequest>> getRequests({String? status}) async {
    try {
      final resp = await _client.get(
        AppConfig.epMassRequests,
        params: {if (status != null) 'status': status},
      );
      final data = resp.data['data'] as List<dynamic>;
      return data
          .map((e) => MassRequest.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception {
      return []; // offline → empty list
    }
  }

  @override
  Future<void> approveRequest(String requestId) async {
    try {
      await _client.patch('${AppConfig.epMassRequests}/$requestId/approve');
    } on Exception catch (e) {
      throw ApiClient.handleDioError(e as dynamic);
    }
  }

  @override
  Future<void> rejectRequest(String requestId, {String? reason}) async {
    try {
      await _client.patch(
        '${AppConfig.epMassRequests}/$requestId/reject',
        data: {if (reason != null) 'reason': reason},
      );
    } on Exception catch (e) {
      throw ApiClient.handleDioError(e as dynamic);
    }
  }
}
