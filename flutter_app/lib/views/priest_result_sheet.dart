import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/models.dart';

Future<void> showPriestResultSheet(
  BuildContext context,
  UserProfile priest, {
  VoidCallback? onDismissed,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => _PriestResultSheet(priest: priest),
  );
  onDismissed?.call();
}

class _PriestResultSheet extends StatelessWidget {
  final UserProfile priest;
  const _PriestResultSheet({required this.priest});

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.gray200,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                children: [
                  // Verified badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.emerald50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.emerald100),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(LucideIcons.shieldCheck, size: 14, color: AppColors.emerald),
                          const SizedBox(width: 6),
                          Text(
                            l10n.verified,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w900,
                              color: AppColors.emerald600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Profile card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.gray100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: AppColors.blue100,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.15),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: const Icon(LucideIcons.user, size: 36, color: AppColors.primary),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'LM. ${priest.holyName} ${priest.fullName}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.gray800,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          priest.diocese.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.idCode} ${priest.id}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.gray400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Info card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(color: AppColors.gray100),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.gray50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(LucideIcons.user, size: 15, color: AppColors.gray400),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n.sectionBasicInfo,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                color: AppColors.gray400,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (priest.birthDate != null || priest.ordinationDate != null)
                          _InfoRow(
                            bgColor: AppColors.blue50,
                            iconColor: AppColors.primary,
                            icon: LucideIcons.calendar,
                            label: l10n.birthAndOrdination,
                            value:
                                '${priest.birthDate ?? '—'} — ${l10n.ordinationPrefix} ${priest.ordinationDate ?? '—'}',
                          ),
                        if (priest.parish != null) ...[
                          const SizedBox(height: 12),
                          _InfoRow(
                            bgColor: AppColors.indigo50,
                            iconColor: AppColors.indigo600,
                            icon: LucideIcons.church,
                            label: l10n.labelCurrentParish,
                            value: priest.parish!,
                          ),
                        ],
                        if (priest.role != null) ...[
                          const SizedBox(height: 12),
                          _InfoRow(
                            bgColor: AppColors.orange50,
                            iconColor: AppColors.orange500,
                            icon: LucideIcons.briefcase,
                            label: l10n.fieldRole,
                            value: priest.role!,
                          ),
                        ],
                        if (priest.degree != null) ...[
                          const SizedBox(height: 12),
                          _InfoRow(
                            bgColor: AppColors.emerald50,
                            iconColor: AppColors.emerald600,
                            icon: LucideIcons.graduationCap,
                            label: l10n.fieldDegree,
                            value: priest.degree!,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Action buttons
                  Row(
                    children: [
                      if (priest.phone != null)
                        Expanded(
                          child: _ActionBtn(
                            icon: LucideIcons.phone,
                            label: l10n.callPhone,
                            bgColor: AppColors.blue100,
                            iconColor: AppColors.primary,
                            onTap: () => _copyToClipboard(context, priest.phone!),
                          ),
                        ),
                      if (priest.phone != null && priest.email != null)
                        const SizedBox(width: 12),
                      if (priest.email != null)
                        Expanded(
                          child: _ActionBtn(
                            icon: LucideIcons.mail,
                            label: l10n.sendEmail,
                            bgColor: AppColors.indigo50,
                            iconColor: AppColors.indigo600,
                            onTap: () => _copyToClipboard(context, priest.email!),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        l10n.close,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: AppColors.gray500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    final l10n = AppStrings.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n.copiedValue}: $text'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final Color bgColor;
  final Color iconColor;
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.bgColor,
    required this.iconColor,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gray400,
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.gray700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, size: 22, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w900,
                color: AppColors.gray600,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
