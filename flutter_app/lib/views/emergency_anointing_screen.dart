import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';

// ─── Data ────────────────────────────────────────────────────────────────────

class _Church {
  final String name;
  final String address;
  final String priestName;
  final String phone;
  final double lat;
  final double lng;
  double distance;

  _Church({
    required this.name,
    required this.address,
    required this.priestName,
    required this.phone,
    required this.lat,
    required this.lng,
    this.distance = 0,
  });
}

final List<_Church> _allChurches = [
  _Church(name: 'Nhà thờ Chính tòa Phú Cường', address: 'Đường Huỳnh Văn Lũy, P. Phú Cường, TP. Thủ Dầu Một', priestName: 'LM. Phaolô Hoàng Mạnh Huy', phone: '0274 382 3456', lat: 11.0047, lng: 106.6489),
  _Church(name: 'Nhà thờ Chánh Lộ', address: 'Đường Cách Mạng Tháng 8, P. Chánh Lộ, TP. Thủ Dầu Một', priestName: 'LM. Giuse Nguyễn Văn Bình', phone: '0274 383 1234', lat: 10.9791, lng: 106.6519),
  _Church(name: 'Nhà thờ Lái Thiêu', address: 'Đường Nguyễn Chí Thanh, P. Lái Thiêu, TP. Thuận An', priestName: 'LM. Phêrô Trần Minh Đức', phone: '0274 375 2345', lat: 10.9265, lng: 106.7025),
  _Church(name: 'Nhà thờ Dĩ An', address: 'Đường Đồng Khởi, P. Dĩ An, TP. Dĩ An', priestName: 'LM. Anrê Lê Văn Hùng', phone: '0274 376 3456', lat: 10.8987, lng: 106.7536),
  _Church(name: 'Nhà thờ Tân Uyên', address: 'Đường Thái Hòa, P. Uyên Hưng, TX. Tân Uyên', priestName: 'LM. Tôma Nguyễn Minh Khoa', phone: '0274 365 4567', lat: 11.0421, lng: 106.8076),
  _Church(name: 'Nhà thờ Bến Cát', address: 'Đường Mỹ Phước, P. Mỹ Phước, TX. Bến Cát', priestName: 'LM. Đaminh Bùi Văn Long', phone: '0274 355 5678', lat: 11.1563, lng: 106.5921),
  _Church(name: 'Nhà thờ Thủ Đức', address: 'Đường Kha Vạn Cân, P. Linh Chiểu, TP. Thủ Đức', priestName: 'LM. Micae Phạm Quang Vinh', phone: '028 3896 1234', lat: 10.8525, lng: 106.7539),
  _Church(name: 'Nhà thờ Fatima Bình Triệu', address: 'Đường Nơ Trang Long, P. 13, Q. Bình Thạnh', priestName: 'LM. Gioan Vũ Đức Thịnh', phone: '028 3898 2345', lat: 10.8489, lng: 106.7272),
  _Church(name: 'Nhà thờ Tân Định', address: 'Đường Hai Bà Trưng, P. 6, Q. 3, TP. HCM', priestName: 'LM. Antôn Trần Quốc Tuấn', phone: '028 3829 3456', lat: 10.7892, lng: 106.6973),
  _Church(name: 'Nhà thờ Đức Bà Sài Gòn', address: 'Công xã Paris, P. Bến Nghé, Q. 1, TP. HCM', priestName: 'LM. Giuse Đinh Văn Hải', phone: '028 3822 4567', lat: 10.7797, lng: 106.6990),
  _Church(name: 'Nhà thờ Huyện Sỹ', address: 'Đường Tôn Thất Tùng, P. Phạm Ngũ Lão, Q. 1', priestName: 'LM. Phanxicô Châu Minh Tân', phone: '028 3835 5678', lat: 10.7728, lng: 106.6944),
  _Church(name: 'Nhà thờ Kỳ Đồng', address: 'Đường Kỳ Đồng, P. 9, Q. 3, TP. HCM', priestName: 'LM. Luca Nguyễn Hữu Phúc', phone: '028 3843 6789', lat: 10.7764, lng: 106.6902),
  _Church(name: 'Nhà thờ Biên Hòa', address: 'Đường Hưng Đạo Vương, P. Trung Dũng, TP. Biên Hòa', priestName: 'LM. Barnaba Đỗ Văn Sơn', phone: '0251 382 7890', lat: 10.9461, lng: 106.8237),
  _Church(name: 'Nhà thờ Hố Nai', address: 'Đường Hưng Đạo, KP. 1, P. Hố Nai, TP. Biên Hòa', priestName: 'LM. Matthêu Lý Minh Tâm', phone: '0251 383 8901', lat: 10.9320, lng: 106.8590),
  _Church(name: 'Nhà thờ Xuân Lộc', address: 'Đường Hùng Vương, TT. Xuân Lộc, H. Xuân Lộc', priestName: 'LM. Phêrô Vũ Ngọc Hải', phone: '0251 371 9012', lat: 10.9317, lng: 107.2414),
  _Church(name: 'Nhà thờ Gia Kiệm', address: 'TT. Gia Kiệm, H. Thống Nhất, Đồng Nai', priestName: 'LM. Giuse Nguyễn Thế Phong', phone: '0251 376 0123', lat: 11.0152, lng: 107.0892),
  _Church(name: 'Nhà thờ Gò Vấp', address: 'Đường Nguyễn Văn Nghi, P. 7, Q. Gò Vấp, TP. HCM', priestName: 'LM. Anrê Trần Đức Bình', phone: '028 3895 1235', lat: 10.8326, lng: 106.6814),
  _Church(name: 'Nhà thờ Hạnh Thông Tây', address: 'Đường Quang Trung, P. 11, Q. Gò Vấp', priestName: 'LM. Gioan Lê Đình Bảo', phone: '028 3894 2346', lat: 10.8214, lng: 106.6648),
  _Church(name: 'Nhà thờ Tân Phú', address: 'Đường Lũy Bán Bích, P. Tân Thới Hòa, Q. Tân Phú', priestName: 'LM. Phêrô Nguyễn Văn Chính', phone: '028 3817 3457', lat: 10.7951, lng: 106.6295),
  _Church(name: 'Nhà thờ Bình Chánh', address: 'Đường Nguyễn Hữu Trí, TT. Tân Túc, H. Bình Chánh', priestName: 'LM. Micae Bùi Quang Khải', phone: '028 3768 4568', lat: 10.7156, lng: 106.5923),
];

// ─── Helpers ─────────────────────────────────────────────────────────────────

double _haversine(double lat1, double lng1, double lat2, double lng2) {
  const r = 6371.0;
  final dLat = (lat2 - lat1) * pi / 180;
  final dLng = (lng2 - lng1) * pi / 180;
  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180) * cos(lat2 * pi / 180) * sin(dLng / 2) * sin(dLng / 2);
  return r * 2 * atan2(sqrt(a), sqrt(1 - a));
}

String _fmtDistance(double km) {
  if (km < 1) return '${(km * 1000).round()} m';
  return '${km.toStringAsFixed(1)} km';
}

// ─── Screen ──────────────────────────────────────────────────────────────────

enum _ScreenState { loading, results, empty, permissionDenied, error }

class EmergencyAnointingScreen extends StatefulWidget {
  const EmergencyAnointingScreen({super.key});

  @override
  State<EmergencyAnointingScreen> createState() => _EmergencyAnointingScreenState();
}

class _EmergencyAnointingScreenState extends State<EmergencyAnointingScreen> {
  _ScreenState _state = _ScreenState.loading;
  List<_Church> _nearby = [];
  String _errorMsg = '';

  @override
  void initState() {
    super.initState();
    _findNearbyChurches();
  }

  Future<void> _findNearbyChurches() async {
    setState(() => _state = _ScreenState.loading);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied || perm == LocationPermission.deniedForever) {
        setState(() => _state = _ScreenState.permissionDenied);
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );

      final nearby = _allChurches.map((c) {
        c.distance = _haversine(pos.latitude, pos.longitude, c.lat, c.lng);
        return c;
      }).where((c) => c.distance <= 10).toList()
        ..sort((a, b) => a.distance.compareTo(b.distance));

      final top5 = nearby.take(5).toList();
      setState(() {
        _nearby = top5;
        _state = top5.isEmpty ? _ScreenState.empty : _ScreenState.results;
      });
    } catch (e) {
      setState(() {
        _state = _ScreenState.error;
        _errorMsg = e.toString();
      });
    }
  }

  Future<void> _callChurch(_Church church) async {
    final uri = Uri.parse('tel:${church.phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể gọi ${church.phone}'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppColors.gray800,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverFillRemaining(
            hasScrollBody: _state == _ScreenState.results,
            child: _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 120,
      backgroundColor: const Color(0xFFDC2626),
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20, top: -20,
                child: Container(
                  width: 120, height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.06),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                left: -10, bottom: -10,
                child: Container(
                  width: 80, height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.04),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(64, 12, 16, 16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.emergency_rounded, color: Colors.white, size: 10),
                                SizedBox(width: 4),
                                Text('KHẨN CẤP', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Liên hệ Xức Dầu',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      const Text(
                        'Tìm linh mục gần nhất để cử hành bí tích',
                        style: TextStyle(color: Colors.white70, fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_state) {
      case _ScreenState.loading:
        return _buildLoading();
      case _ScreenState.results:
        return _buildResults();
      case _ScreenState.empty:
        return _buildEmpty();
      case _ScreenState.permissionDenied:
        return _buildPermissionDenied();
      case _ScreenState.error:
        return _buildError();
    }
  }

  Widget _buildLoading() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withValues(alpha: 0.15), blurRadius: 20)],
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: CircularProgressIndicator(
                  color: Color(0xFFDC2626),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Đang xác định vị trí...',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800),
            ),
            const SizedBox(height: 8),
            const Text(
              'Hệ thống đang tìm nhà thờ\ngần nhất trong bán kính 10km',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        // Result count banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withValues(alpha: 0.25), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tìm thấy ${_nearby.length} nhà thờ',
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    const Text(
                      'Trong bán kính 10km từ vị trí của bạn',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${_nearby.length}/5',
                  style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: [
              Text('NHÀ THỜ GẦN NHẤT', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5)),
            ],
          ),
        ),

        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            itemCount: _nearby.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (_, i) => _ChurchCard(
              church: _nearby[i],
              rank: i + 1,
              onCall: () => _callChurch(_nearby[i]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(24)),
              child: const Icon(LucideIcons.church, size: 36, color: Color(0xFFDC2626)),
            ),
            const SizedBox(height: 20),
            const Text('Không tìm thấy nhà thờ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Không có nhà thờ nào trong bán kính 10km.\nVui lòng liên hệ trực tiếp với giáo phận.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _findNearbyChurches,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: const Color(0xFFFEF3C7), borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.location_off_rounded, size: 40, color: Color(0xFFD97706)),
            ),
            const SizedBox(height: 20),
            const Text('Cần quyền truy cập vị trí', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Vào Cài đặt → Thông Tin Linh Mục\n→ Vị trí → Cho phép khi dùng app',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: const Text('Mở Cài đặt', style: TextStyle(fontWeight: FontWeight.w900)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _findNearbyChurches,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.w900)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.gray600,
                  side: const BorderSide(color: AppColors.gray200),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(24)),
              child: const Icon(Icons.gps_off_rounded, size: 40, color: Color(0xFFDC2626)),
            ),
            const SizedBox(height: 20),
            const Text('Không lấy được vị trí', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Hãy đảm bảo GPS đang bật\nvà thử lại.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _findNearbyChurches,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Thử lại', style: TextStyle(fontWeight: FontWeight.w900)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Church Card ─────────────────────────────────────────────────────────────

class _ChurchCard extends StatelessWidget {
  final _Church church;
  final int rank;
  final VoidCallback onCall;

  const _ChurchCard({required this.church, required this.rank, required this.onCall});

  @override
  Widget build(BuildContext context) {
    final isNearest = rank == 1;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isNearest ? const Color(0xFFDC2626).withValues(alpha: 0.3) : AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          // Left red bar
          Positioned(
            left: 0, top: 0, bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: isNearest ? const Color(0xFFDC2626) : AppColors.gray200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Church icon
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(
                        color: isNearest ? const Color(0xFFFEE2E2) : AppColors.gray50,
                        borderRadius: BorderRadius.circular(13),
                      ),
                      child: Icon(
                        LucideIcons.church,
                        size: 22,
                        color: isNearest ? const Color(0xFFDC2626) : AppColors.gray400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isNearest)
                            Container(
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEE2E2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('GẦN NHẤT', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Color(0xFFDC2626), letterSpacing: 1)),
                            ),
                          Text(
                            church.name,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray800),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            church.address,
                            style: const TextStyle(fontSize: 11, color: AppColors.gray500, height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),
                const Divider(height: 1, color: AppColors.gray100),
                const SizedBox(height: 10),

                // Priest + distance + call button
                Row(
                  children: [
                    const Icon(LucideIcons.user, size: 13, color: AppColors.primary),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        church.priestName,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.place_rounded, size: 11, color: Color(0xFFDC2626)),
                          const SizedBox(width: 3),
                          Text(
                            _fmtDistance(church.distance),
                            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFFDC2626)),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onCall,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: const Color(0xFFDC2626).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 3))],
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.phone_rounded, color: Colors.white, size: 14),
                            SizedBox(width: 5),
                            Text('GỌI NGAY', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
