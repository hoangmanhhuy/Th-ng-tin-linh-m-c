import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../core/app_theme.dart';
import 'notifications_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();

    final settingsGroups = [
      _SettingsGroup(
        title: 'Tài khoản & Bảo mật',
        items: [
          _SettingsItem(icon: LucideIcons.user, label: 'Thông tin cá nhân', iconColor: AppColors.primary, bgColor: AppColors.blue50),
          _SettingsItem(icon: LucideIcons.fingerprint, label: 'Sinh trắc học', iconColor: AppColors.orange500, bgColor: AppColors.orange50),
          _SettingsItem(icon: LucideIcons.lock, label: 'Đổi mật khẩu', iconColor: AppColors.red600, bgColor: AppColors.red50),
        ],
      ),
      _SettingsGroup(
        title: 'Ứng dụng & Hỗ trợ',
        items: [
          _SettingsItem(icon: LucideIcons.languages, label: 'Ngôn ngữ', iconColor: AppColors.emerald600, bgColor: AppColors.emerald50),
          _SettingsItem(icon: LucideIcons.undo2, label: 'Đề nghị cập nhật', iconColor: AppColors.indigo600, bgColor: AppColors.indigo50),
          _SettingsItem(icon: LucideIcons.helpCircle, label: 'Hỗ trợ', iconColor: AppColors.amber600, bgColor: AppColors.amber50),
        ],
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Cài đặt',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
            icon: const Icon(LucideIcons.bell, color: AppColors.primary),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Profile Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: AppColors.gray100),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.blue100,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                    ),
                    child: const Icon(LucideIcons.user, size: 28, color: AppColors.primary),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'LM. Phaolô Hoàng Mạnh Huy',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.gray800),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'GIÁO PHẬN PHÚ CƯỜNG',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            ...settingsGroups.map((group) => Padding(
              padding: const EdgeInsets.only(top: 24),
              child: _SettingsGroupWidget(group: group),
            )),

            const SizedBox(height: 24),

            // Logout
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => auth.logout(),
                icon: const Icon(LucideIcons.logOut, size: 18),
                label: const Text(
                  'ĐĂNG XUẤT',
                  style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.red,
                  side: const BorderSide(color: AppColors.red100, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
              ),
            ),

            const SizedBox(height: 32),

            const Center(
              child: Column(
                children: [
                  Text(
                    'SACRED LINK v1.0.4',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray300, letterSpacing: 3),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Copyright © 2024 Digital Ecclesia',
                    style: TextStyle(fontSize: 10, color: AppColors.gray200),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SettingsGroup {
  final String title;
  final List<_SettingsItem> items;
  const _SettingsGroup({required this.title, required this.items});
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  const _SettingsItem({required this.icon, required this.label, required this.iconColor, required this.bgColor});
}

class _SettingsGroupWidget extends StatelessWidget {
  final _SettingsGroup group;
  const _SettingsGroupWidget({required this.group});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(
            group.title.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.gray400,
              letterSpacing: 1.5,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.gray100),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Column(
            children: group.items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isLast = i == group.items.length - 1;
              return Column(
                children: [
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: item.bgColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(item.icon, size: 18, color: item.iconColor),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            item.label,
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray700),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded, color: AppColors.gray300, size: 20),
                        ],
                      ),
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, indent: 70, color: AppColors.gray100),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
