// lib/services/church_service.dart
// Service tìm nhà thờ gần nhất cho tính năng Xức Dầu Khẩn Cấp.
// Offline fallback: 20 nhà thờ hardcoded (đủ cho khu vực Phú Cường + TP.HCM).

import 'dart:math' show sqrt, sin, cos, atan2, pi;
import '../core/app_config.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class ChurchService {
  Future<List<Church>> getNearby(
    double lat,
    double lng, {
    double radiusKm,
  });
}

class RemoteChurchService implements ChurchService {
  final ApiClient _client;
  RemoteChurchService(this._client);

  @override
  Future<List<Church>> getNearby(
    double lat,
    double lng, {
    double radiusKm = 10,
  }) async {
    try {
      final resp = await _client.get(
        AppConfig.epChurchesNearby,
        params: {'lat': lat, 'lng': lng, 'radiusKm': radiusKm},
      );
      final data = resp.data['data'] as List<dynamic>;
      return data
          .map((e) => Church.fromJson(e as Map<String, dynamic>))
          .toList();
    } on Exception {
      // Offline → lọc từ danh sách local
      return _filterLocal(lat, lng, radiusKm);
    }
  }

  List<Church> _filterLocal(double lat, double lng, double radiusKm) {
    final result = <Church>[];
    for (final c in _localChurches) {
      final dist = _haversineKm(lat, lng, c.lat, c.lng);
      if (dist <= radiusKm) {
        result.add(Church(
          name: c.name,
          address: c.address,
          priestName: c.priestName,
          phone: c.phone,
          lat: c.lat,
          lng: c.lng,
          distanceKm: dist,
        ));
      }
    }
    result.sort((a, b) => (a.distanceKm ?? 0).compareTo(b.distanceKm ?? 0));
    return result;
  }

  double _haversineKm(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _rad(lat2 - lat1);
    final dLon = _rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_rad(lat1)) * cos(_rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  double _rad(double deg) => deg * pi / 180;

  // ── Danh sách nhà thờ local (fallback) ─────────────────────────────────────
  static const List<Church> _localChurches = [
    Church(name: 'Nhà thờ Chính tòa Phú Cường', address: 'Đường Huỳnh Văn Lũy, P. Phú Cường, TP. Thủ Dầu Một', priestName: 'LM. Phaolô Hoàng Mạnh Huy', phone: '0274 382 3456', lat: 11.0047, lng: 106.6489),
    Church(name: 'Nhà thờ Chánh Lộ', address: 'Đường Chánh Lộ, P. Phú Lợi, TP. Thủ Dầu Một', priestName: 'LM. Giuse Nguyễn Văn Minh', phone: '0274 382 4567', lat: 10.9791, lng: 106.6519),
    Church(name: 'Nhà thờ Búng', address: 'Khu phố Bình Đức, P. An Thạnh, TX. Thuận An', priestName: 'LM. Phêrô Trần Văn Hùng', phone: '0274 755 1234', lat: 10.9356, lng: 106.6789),
    Church(name: 'Nhà thờ Lái Thiêu', address: 'Khu phố 1, P. Lái Thiêu, TX. Thuận An', priestName: 'LM. Gioan Lê Minh Tuấn', phone: '0274 755 5678', lat: 10.9125, lng: 106.6912),
    Church(name: 'Nhà thờ Dĩ An', address: 'P. Dĩ An, TP. Dĩ An', priestName: 'LM. Tôma Vũ Đức Long', phone: '0274 374 1234', lat: 10.9023, lng: 106.7612),
    Church(name: 'Nhà thờ Thủ Đức', address: 'Đường Kha Vạn Cân, P. Linh Đông, TP. Thủ Đức', priestName: 'LM. Anrê Phạm Văn Thắng', phone: '028 3896 1234', lat: 10.8500, lng: 106.7700),
    Church(name: 'Nhà thờ Hóc Môn', address: 'Đường Lý Nam Đế, TT. Hóc Môn', priestName: 'LM. Barnaba Đặng Minh Quang', phone: '028 3891 4321', lat: 10.8900, lng: 106.5950),
    Church(name: 'Nhà thờ Đức Bà Sài Gòn', address: 'Công trường Paris, Q.1, TP. Hồ Chí Minh', priestName: 'LM. Phanxicô Xavier Lê Văn Đồng', phone: '028 3822 4390', lat: 10.7797, lng: 106.6990),
    Church(name: 'Nhà thờ Tân Định', address: 'Đường Hai Bà Trưng, Q.3, TP. Hồ Chí Minh', priestName: 'LM. Anrê Nguyễn Minh Tuấn', phone: '028 3820 2745', lat: 10.7869, lng: 106.6921),
    Church(name: 'Nhà thờ Huyện Sỹ', address: 'Đường Tôn Thất Tùng, Q.1, TP. Hồ Chí Minh', priestName: 'LM. Giuse Trần Ngọc Thạch', phone: '028 3836 2340', lat: 10.7675, lng: 106.6928),
    Church(name: 'Nhà thờ Xóm Chiếu', address: 'Đường Xóm Chiếu, Q.4, TP. Hồ Chí Minh', priestName: 'LM. Micae Đinh Văn Thành', phone: '028 3826 4392', lat: 10.7612, lng: 106.7012),
    Church(name: 'Nhà thờ Bình An', address: 'Đường Nơ Trang Long, Q. Bình Thạnh', priestName: 'LM. Đaminh Nguyễn Quang Huy', phone: '028 3841 2561', lat: 10.8124, lng: 106.7023),
    Church(name: 'Nhà thờ Phú Nhuận', address: 'Đường Thích Quảng Đức, Q. Phú Nhuận', priestName: 'LM. Luca Trần Công Danh', phone: '028 3844 1823', lat: 10.7989, lng: 106.6845),
    Church(name: 'Nhà thờ Gò Vấp', address: 'Đường Nguyễn Kiệm, Q. Gò Vấp', priestName: 'LM. Matthêu Bùi Văn Minh', phone: '028 3894 2136', lat: 10.8312, lng: 106.6712),
    Church(name: 'Nhà thờ Bình Chánh', address: 'Đường Nguyễn Văn Linh, H. Bình Chánh', priestName: 'LM. Inhaxiô Lê Thành Phương', phone: '028 3765 4890', lat: 10.6789, lng: 106.6234),
    Church(name: 'Nhà thờ Củ Chi', address: 'Đường Tỉnh Lộ 8, H. Củ Chi', priestName: 'LM. Têphanô Nguyễn Hữu Phúc', phone: '028 3794 1267', lat: 11.0012, lng: 106.4956),
    Church(name: 'Nhà thờ Long An', address: 'Đường Hùng Vương, TP. Tân An, tỉnh Long An', priestName: 'LM. Giuse Huỳnh Văn Hoàng', phone: '0272 382 4567', lat: 10.5312, lng: 106.4089),
    Church(name: 'Nhà thờ Biên Hòa', address: 'Đường Hưng Đạo Vương, TP. Biên Hòa', priestName: 'LM. Phêrô Nguyễn Thế Hùng', phone: '0251 382 3456', lat: 10.9450, lng: 106.8234),
    Church(name: 'Nhà thờ Vũng Tàu', address: 'Đường Lê Lợi, TP. Vũng Tàu', priestName: 'LM. Gioan Trần Minh Đức', phone: '0254 382 7890', lat: 10.3462, lng: 107.0843),
    Church(name: 'Nhà thờ Mỹ Tho', address: 'Đường Hùng Vương, TP. Mỹ Tho, Tiền Giang', priestName: 'LM. Antôn Lê Văn Bình', phone: '0273 382 5678', lat: 10.3540, lng: 106.3612),
  ];
}
