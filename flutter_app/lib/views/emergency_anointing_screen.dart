import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/api_models.dart';
import '../services/api_client.dart';
import '../services/church_service.dart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

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
  List<Church> _nearby = [];
  late final ChurchService _service;

  @override
  void initState() {
    super.initState();
    _service = RemoteChurchService(context.read<ApiClient>());
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

      final nearby = await _service.getNearby(pos.latitude, pos.longitude, radiusKm: 10);
      final top5 = nearby.take(5).toList();
      setState(() {
        _nearby = top5;
        _state = top5.isEmpty ? _ScreenState.empty : _ScreenState.results;
      });
    } catch (_) {
      setState(() => _state = _ScreenState.error);
    }
  }

  Future<void> _callChurch(Church church) async {
    final uri = Uri.parse('tel:${church.phone.replaceAll(' ', '')}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppStrings.of(context).cannotCall(church.phone)),
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
    final l10n = AppStrings.of(context);
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
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.emergency_rounded, color: Colors.white, size: 10),
                                const SizedBox(width: 4),
                                Text(l10n.emergencyBadge, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.emergencyAnointingTitle,
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900),
                      ),
                      Text(
                        l10n.emergencyAnointingSubtitle,
                        style: const TextStyle(color: Colors.white70, fontSize: 11),
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
    final l10n = AppStrings.of(context);
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
            Text(
              l10n.locating,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.locatingDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final l10n = AppStrings.of(context);
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
                      l10n.nearbyChurchesFound(_nearby.length),
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      l10n.nearbyRadius,
                      style: const TextStyle(color: Colors.white70, fontSize: 11),
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

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
          child: Row(
            children: [
              Text(l10n.nearestChurches, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5)),
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
    final l10n = AppStrings.of(context);
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
            Text(l10n.noChurchFound, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            Text(
              l10n.noChurchFoundDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _findNearbyChurches,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.retryLower, style: const TextStyle(fontWeight: FontWeight.w900)),
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
    final l10n = AppStrings.of(context);
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
            Text(l10n.locationPermissionRequired, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            Text(
              l10n.locationPermissionDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.6),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  await Geolocator.openAppSettings();
                },
                icon: const Icon(Icons.settings_rounded, size: 18),
                label: Text(l10n.openSettings, style: const TextStyle(fontWeight: FontWeight.w900)),
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
                label: Text(l10n.retryLower, style: const TextStyle(fontWeight: FontWeight.w900)),
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
    final l10n = AppStrings.of(context);
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
            Text(l10n.cannotGetLocation, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            Text(
              l10n.cannotGetLocationDesc,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _findNearbyChurches,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.retryLower, style: const TextStyle(fontWeight: FontWeight.w900)),
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
  final Church church;
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
                            _fmtDistance(church.distanceKm ?? 0),
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
