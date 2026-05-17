// lib/services/update_request_service.dart
// Service gửi yêu cầu cập nhật thông tin linh mục.

import '../core/app_config.dart';
import 'api_client.dart';

abstract class UpdateRequestService {
  Future<void> submitRequest(String category, String content);
}

class RemoteUpdateRequestService implements UpdateRequestService {
  final ApiClient _client;
  RemoteUpdateRequestService(this._client);

  @override
  Future<void> submitRequest(String category, String content) async {
    try {
      await _client.post(
        AppConfig.epUpdateRequests,
        data: {'category': category, 'content': content},
      );
    } on Exception catch (e) {
      final apiErr = ApiClient.handleDioError(e as dynamic);
      if (apiErr.isNetworkError) {
        // Mock thành công khi server chưa có
        return;
      }
      throw apiErr;
    }
  }
}
