// lib/services/history_service.dart
// Service lấy lịch sử yêu cầu dâng lễ của linh mục đang đăng nhập.

import '../core/app_config.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class HistoryService {
  Future<List<HistoryRecord>> getHistory({String type, int page, int pageSize});
}

class RemoteHistoryService implements HistoryService {
  final ApiClient _client;
  RemoteHistoryService(this._client);

  @override
  Future<List<HistoryRecord>> getHistory({
    String type = 'all',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final resp = await _client.get(
        AppConfig.epMassRequesterHistory,
        params: {'Page': page, 'PageSize': pageSize},
      );
      // Real API: { status, statusCode, payload: { results: [...], pageCount: N } }
      final raw = resp.data;
      List<dynamic> data;
      if (raw is Map<String, dynamic>) {
        final payload = raw['payload'];
        if (payload is Map<String, dynamic> && payload['results'] is List) {
          data = payload['results'] as List<dynamic>;
        } else if (payload is List) {
          data = payload;
        } else if (raw['data'] is List) {
          data = raw['data'] as List<dynamic>;
        } else {
          data = [];
        }
      } else if (raw is List) {
        data = raw;
      } else {
        data = [];
      }
      return data
          .map((e) => HistoryRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception {
      // Offline / server chưa có → trả mock data chuẩn format
      return _mockHistory;
    }
  }

  // Mock data khớp format real API — sẽ bị xoá khi backend sẵn sàng
  // id dùng String UUID
  static const List<HistoryRecord> _mockHistory = [
    HistoryRecord(
      id: 'mock-hist-001',
      type: 'mass',
      title: 'Lễ Tạ ơn',
      status: 'completed',
      date: '20/10/2023',
      refId: 'mock-hist-001',
    ),
    HistoryRecord(
      id: 'mock-hist-002',
      type: 'mass',
      title: 'Lễ Cầu Bình An',
      status: 'processing',
      date: '18/10/2023',
      refId: 'mock-hist-002',
    ),
    HistoryRecord(
      id: 'mock-hist-003',
      type: 'mass',
      title: 'Lễ An Táng',
      status: 'rejected',
      date: '15/10/2023',
      refId: 'mock-hist-003',
    ),
    HistoryRecord(
      id: 'mock-hist-004',
      type: 'mass',
      title: 'Lễ Cầu Hồn',
      status: 'completed',
      date: '10/10/2023',
      refId: 'mock-hist-004',
    ),
  ];
}
