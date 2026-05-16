import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';

class BiometricsScreen extends StatefulWidget {
  const BiometricsScreen({super.key});

  @override
  State<BiometricsScreen> createState() => _BiometricsScreenState();
}

class _BiometricsScreenState extends State<BiometricsScreen> {
  bool _faceIdEnabled = false;
  bool _fingerprintEnabled = false;
  bool _autoLockEnabled = true;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _faceIdEnabled = prefs.getBool('bio_faceid') ?? false;
      _fingerprintEnabled = prefs.getBool('bio_fingerprint') ?? false;
      _autoLockEnabled = prefs.getBool('bio_autolock') ?? true;
      _loading = false;
    });
  }

  Future<void> _toggle(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
        ),
        title: Text(
          l10n.biometricsTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFFF8C60)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Icon(LucideIcons.fingerprint, size: 28, color: Colors.white),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.biometricsSecurity,
                                style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.biometricsDesc,
                                style: const TextStyle(color: Colors.white70, fontSize: 11, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _SectionLabel(title: l10n.sectionAuthMethod),
                  _ToggleCard(
                    icon: LucideIcons.scan,
                    iconColor: AppColors.primary,
                    bgColor: AppColors.blue50,
                    title: 'Face ID',
                    subtitle: l10n.faceIdSubtitle,
                    value: _faceIdEnabled,
                    onChanged: (v) {
                      setState(() => _faceIdEnabled = v);
                      _toggle('bio_faceid', v);
                      if (v) {
                        _showConfirmSnack(context, l10n.faceIdEnabled);
                      }
                    },
                  ),
                  const SizedBox(height: 1),
                  _ToggleCard(
                    icon: LucideIcons.fingerprint,
                    iconColor: AppColors.orange500,
                    bgColor: AppColors.orange50,
                    title: l10n.touchId,
                    subtitle: l10n.touchIdSubtitle,
                    value: _fingerprintEnabled,
                    onChanged: (v) {
                      setState(() => _fingerprintEnabled = v);
                      _toggle('bio_fingerprint', v);
                      if (v) {
                        _showConfirmSnack(context, l10n.touchIdEnabled);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  _SectionLabel(title: l10n.sectionLockSettings),
                  _ToggleCard(
                    icon: LucideIcons.lock,
                    iconColor: AppColors.emerald600,
                    bgColor: AppColors.emerald50,
                    title: l10n.autoLock,
                    subtitle: l10n.autoLockSubtitle,
                    value: _autoLockEnabled,
                    onChanged: (v) {
                      setState(() => _autoLockEnabled = v);
                      _toggle('bio_autolock', v);
                    },
                  ),

                  const SizedBox(height: 20),

                  // Info box
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.amber50,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.amber100),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(LucideIcons.shieldAlert, size: 16, color: AppColors.amber600),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            l10n.biometricsNote,
                            style: const TextStyle(fontSize: 12, color: AppColors.amber600, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  void _showConfirmSnack(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ));
  }
}

class _SectionLabel extends StatelessWidget {
  final String title;
  const _SectionLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
        ),
      ),
    );
  }
}

class _ToggleCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleCard({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: value ? AppColors.primary.withValues(alpha: 0.2) : AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, size: 18, color: iconColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray700)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: AppColors.gray400)),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
