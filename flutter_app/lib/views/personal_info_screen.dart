import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/models.dart';

class PersonalInfoScreen extends StatelessWidget {
  final UserProfile user;
  const PersonalInfoScreen({super.key, required this.user});

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
          l10n.personalInfoTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 8),

            // Avatar card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF3B82F6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 2),
                    ),
                    child: ClipOval(
                      child: (user.photo != null && user.photo!.isNotEmpty)
                          ? Image.network(
                              user.photo!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(LucideIcons.user, size: 36, color: Colors.white),
                            )
                          : const Icon(LucideIcons.user, size: 36, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    l10n.holyName,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.translateHolyName(user.holyName),
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.fullName,
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.circle, color: Color(0xFF4ADE80), size: 8),
                        const SizedBox(width: 6),
                        Text(l10n.activeStatus, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _InfoSection(
              title: l10n.sectionIdentity,
              items: [
                _InfoEntry(icon: LucideIcons.fingerprint, label: l10n.fieldId, value: user.id, copyable: true),
                _InfoEntry(icon: LucideIcons.building2, label: l10n.fieldDiocese, value: l10n.translateDiocese(user.diocese)),
                if (user.parish != null)
                  _InfoEntry(icon: LucideIcons.mapPin, label: l10n.fieldParish, value: l10n.translateDiocese(user.parish!)),
                if (user.role != null)
                  _InfoEntry(icon: LucideIcons.briefcase, label: l10n.fieldRole, value: l10n.translateRole(user.role!)),
              ],
            ),

            const SizedBox(height: 16),

            _InfoSection(
              title: l10n.sectionPersonal,
              items: [
                if (user.birthDate != null)
                  _InfoEntry(icon: LucideIcons.cake, label: l10n.fieldBirthDate, value: user.birthDate!),
                if (user.ordinationDate != null)
                  _InfoEntry(icon: LucideIcons.cross, label: l10n.fieldOrdinationDate, value: user.ordinationDate!),
                if (user.degree != null)
                  _InfoEntry(icon: LucideIcons.graduationCap, label: l10n.fieldDegree, value: l10n.translateDegree(user.degree!)),
              ],
            ),

            const SizedBox(height: 16),

            _InfoSection(
              title: l10n.sectionContact,
              items: [
                if (user.email != null)
                  _InfoEntry(icon: LucideIcons.mail, label: l10n.fieldEmail, value: user.email!, copyable: true),
                if (user.phone != null)
                  _InfoEntry(icon: LucideIcons.phone, label: l10n.fieldPhone, value: user.phone!, copyable: true),
              ],
            ),

            const SizedBox(height: 24),

            // Note
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.blue50,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.blue100),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(LucideIcons.info, size: 16, color: AppColors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.personalInfoNote,
                      style: const TextStyle(fontSize: 12, color: AppColors.primary, height: 1.5),
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
}

class _InfoSection extends StatelessWidget {
  final String title;
  final List<_InfoEntry> items;
  const _InfoSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            title,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gray100),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
          ),
          child: Column(
            children: items.asMap().entries.map((e) {
              final isLast = e.key == items.length - 1;
              final item = e.value;
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.blue50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(item.icon, size: 16, color: AppColors.primary),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.label, style: const TextStyle(fontSize: 10, color: AppColors.gray400, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                              const SizedBox(height: 2),
                              Text(item.value, style: const TextStyle(fontSize: 13, color: AppColors.gray800, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        if (item.copyable)
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: item.value));
                              final l10n = AppStrings.of(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${l10n.copiedValue}: ${item.value}'),
                                  duration: const Duration(seconds: 2),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.gray50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(LucideIcons.copy, size: 14, color: AppColors.gray400),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 66, color: AppColors.gray100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _InfoEntry {
  final IconData icon;
  final String label;
  final String value;
  final bool copyable;
  const _InfoEntry({required this.icon, required this.label, required this.value, this.copyable = false});
}
