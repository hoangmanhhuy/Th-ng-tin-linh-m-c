// lib/services/priest_service.dart
// Service tra cứu linh mục.
// → Thử gọi API trước, nếu lỗi mạng → fallback về PriestDatabase local (14 records).

import '../core/app_config.dart';
import '../models/models.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class PriestService {
  Future<List<UserProfile>> search({String query, String diocese});
  Future<UserProfile?> getById(String id);
  List<String> get allDioceses;
}

class RemotePriestService implements PriestService {
  final ApiClient _client;
  RemotePriestService(this._client);

  @override
  Future<UserProfile?> getById(String rawId) async {
    // Chuẩn hoá ID: bỏ prefix "PRIEST:" nếu có
    final id = rawId.startsWith('PRIEST:')
        ? rawId.substring(7).trim()
        : rawId.trim();

    // Thử parse JSON (NFC tag có thể chứa JSON trực tiếp)
    if (id.startsWith('{')) {
      try {
        final profile = PriestDatabase.lookup(id);
        if (profile != null) return profile;
      } catch (_) {}
    }

    // Thử API trước
    try {
      final resp = await _client.get('${AppConfig.epPriests}/$id');
      return UserProfile.fromJson(resp.data as Map<String, dynamic>);
    } on ApiError catch (e) {
      if (e.isNetworkError) {
        // Offline → fallback local
        return PriestDatabase.lookup(id);
      }
      if (e.statusCode == 404) return null;
      rethrow;
    } on Exception {
      // Bất kỳ lỗi mạng khác → fallback local
      return PriestDatabase.lookup(id);
    }
  }

  @override
  Future<List<UserProfile>> search({
    String query = '',
    String diocese = '',
  }) async {
    try {
      final params = <String, dynamic>{
        if (query.isNotEmpty) 'q': query,
        if (diocese.isNotEmpty &&
            diocese != 'Chọn Giáo phận' &&
            diocese != 'Choose Diocese')
          'diocese': diocese,
        'limit': 50,
      };
      final resp = await _client.get(AppConfig.epPriests, params: params);
      final result = PriestSearchResult.fromJson(
        resp.data as Map<String, dynamic>,
      );
      return result.data;
    } on Exception {
      // Offline → fallback local search
      return PriestDatabase.search(query: query, diocese: diocese);
    }
  }

  @override
  List<String> get allDioceses => PriestDatabase.allDioceses;
}
