import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/models.dart';
import '../viewmodels/viewmodels.dart';

class PriestProfileScreen extends StatelessWidget {
  final UserProfile user;
  const PriestProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();
    final l10n = AppStrings.of(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Digital Ecclesia',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.bell, color: AppColors.primary, size: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                auth.logout();
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary.withOpacity(0.08),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              ),
              child: Text(
                l10n.logout,
                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
        child: Column(
          children: [
            // ── Avatar + Name ──────────────────────────────────
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.blue100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 16),
                    ],
                  ),
                  child: const Icon(LucideIcons.user, size: 44, color: AppColors.primary),
                ),
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 14),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.holyName,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gray400, letterSpacing: 2),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.translateHolyName(user.holyName),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
            ),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.emerald50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.emerald100),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: AppColors.emerald, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    l10n.activeStatus,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.emerald600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Thẻ định danh xanh ────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E6FD9), Color(0xFF1243A8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Stack(
                children: [
                  // Decorative circles
                  Positioned(
                    right: -20, bottom: -20,
                    child: Container(
                      width: 100, height: 100,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.06), shape: BoxShape.circle),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.priestIdCode,
                                  style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user.id,
                                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.open_in_full_rounded, color: Colors.white, size: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(height: 1, color: Colors.white.withOpacity(0.15)),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.dioceseLabel,
                                  style: const TextStyle(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.5),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.translateDiocese(user.diocese).toUpperCase(),
                                  style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _showQr(context),
                            child: Container(
                              width: 38, height: 38,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Thông tin chi tiết ─────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: AppColors.gray50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.clipboardList, size: 14, color: AppColors.gray400),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.sectionDetailedInfo,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Ngày sinh + Thụ phong
                  Row(
                    children: [
                      Expanded(
                        child: _InfoTile(
                          icon: LucideIcons.cake,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.blue50,
                          label: l10n.labelBirthDate,
                          value: user.birthDate ?? '—',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoTile(
                          icon: LucideIcons.sparkles,
                          iconColor: AppColors.fuchsia500,
                          iconBg: AppColors.fuchsia50,
                          label: l10n.labelOrdination,
                          value: user.ordinationDate ?? '—',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  _InfoRow(
                    icon: LucideIcons.church,
                    iconColor: AppColors.indigo600,
                    iconBg: AppColors.indigo50,
                    label: l10n.labelCurrentParish,
                    value: l10n.translateDiocese(user.parish ?? '—'),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    icon: LucideIcons.graduationCap,
                    iconColor: AppColors.emerald600,
                    iconBg: AppColors.emerald50,
                    label: l10n.labelDegree,
                    value: l10n.translateDegree(user.degree ?? '—'),
                  ),
                  if (user.email != null) ...[
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: LucideIcons.mail,
                      iconColor: AppColors.orange500,
                      iconBg: AppColors.orange50,
                      label: l10n.labelEmail,
                      value: user.email!,
                      onTap: () => Clipboard.setData(ClipboardData(text: user.email!)),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Mã QR ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Column(
                children: [
                  Text(
                    l10n.qrIdCode,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.gray100),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
                    ),
                    child: QrImageView(
                      data: 'PRIEST:${user.id}',
                      version: QrVersions.auto,
                      size: 180,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.qrUsageDesc,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.5),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Lịch sử công tác ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 30, height: 30,
                        decoration: BoxDecoration(color: AppColors.blue50, borderRadius: BorderRadius.circular(8)),
                        child: const Icon(LucideIcons.briefcase, size: 14, color: AppColors.primary),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.sectionWorkHistory,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _WorkItem(
                    period: '${_year(user.ordinationDate)} - ${l10n.toPresent}',
                    title: l10n.translateRole(user.role ?? 'Linh mục'),
                    place: '${l10n.translateDiocese(user.parish ?? '')}, ${l10n.translateDiocese(user.diocese)}',
                    isActive: true,
                  ),
                  const SizedBox(height: 12),
                  _WorkItem(
                    period: '${_prevYear(user.ordinationDate)} - ${_year(user.ordinationDate)}',
                    title: l10n.vicePriest,
                    place: '${l10n.parishOf} ${user.diocese}',
                    isActive: false,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Lịch sử cập nhật ──────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.sectionUpdateHistory,
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 12),
                  _UpdateRow(label: l10n.updateRoleNew, date: '12/10/2023'),
                  const SizedBox(height: 8),
                  _UpdateRow(label: l10n.updateContactChange, date: '05/08/2023'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showQr(BuildContext context) {
    final l10n = AppStrings.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.gray200, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            Text(l10n.qrIdCodeModal, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textMain)),
            const SizedBox(height: 20),
            QrImageView(data: 'PRIEST:${user.id}', version: QrVersions.auto, size: 220, backgroundColor: Colors.white),
            const SizedBox(height: 16),
            Text(user.id, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1)),
          ],
        ),
      ),
    );
  }

  String _year(String? date) {
    if (date == null) return '2000';
    final parts = date.split('/');
    return parts.length == 3 ? parts[2] : '2000';
  }

  String _prevYear(String? date) {
    final y = int.tryParse(_year(date)) ?? 2000;
    return '${y - 6}';
  }
}

// ── Widgets helper ──────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: AppColors.gray400)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: AppColors.textMain)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gray400)),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: onTap != null ? AppColors.primary : AppColors.gray700,
                  ),
                ),
              ],
            ),
          ),
          if (onTap != null)
            const Icon(Icons.copy_rounded, size: 14, color: AppColors.gray300),
        ],
      ),
    );
  }
}

class _WorkItem extends StatelessWidget {
  final String period;
  final String title;
  final String place;
  final bool isActive;

  const _WorkItem({
    required this.period,
    required this.title,
    required this.place,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14, height: 14,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.gray300,
                shape: BoxShape.circle,
                border: Border.all(color: isActive ? AppColors.primary.withOpacity(0.3) : AppColors.gray200, width: 3),
              ),
            ),
            if (!isActive)
              Container(width: 2, height: 40, color: AppColors.gray100),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                period,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isActive ? AppColors.primary : AppColors.gray400,
                ),
              ),
              const SizedBox(height: 4),
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textMain)),
              const SizedBox(height: 2),
              Text(place, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
            ],
          ),
        ),
      ],
    );
  }
}

class _UpdateRow extends StatelessWidget {
  final String label;
  final String date;

  const _UpdateRow({required this.label, required this.date});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: AppColors.gray600)),
        Text(date, style: const TextStyle(fontSize: 12, color: AppColors.gray400, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
