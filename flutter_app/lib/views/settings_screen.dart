import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../core/app_theme.dart';
import 'notifications_screen.dart';
import 'personal_info_screen.dart';
import 'biometrics_screen.dart';
import 'change_password_screen.dart';
import 'language_screen.dart';
import 'update_request_screen.dart';
import 'help_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthViewModel>();
    final user = auth.currentUser;

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
            GestureDetector(
              onTap: user != null
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalInfoScreen(user: user)))
                  : null,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(color: AppColors.gray100),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
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
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8)],
                      ),
                      child: const Icon(LucideIcons.user, size: 28, color: AppColors.primary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user != null ? 'LM. ${user.holyName} ${user.fullName}' : 'Linh mục',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.gray800),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user?.diocese.toUpperCase() ?? '',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1.5),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right_rounded, color: AppColors.gray300, size: 20),
                  ],
                ),
              ),
            ),

            // Tài khoản & Bảo mật
            const Padding(
              padding: EdgeInsets.only(top: 24, left: 4, bottom: 10),
              child: Text(
                'TÀI KHOẢN & BẢO MẬT',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
              ),
            ),
            _SettingsTile(
              icon: LucideIcons.user,
              label: 'Thông tin cá nhân',
              iconColor: AppColors.primary,
              bgColor: AppColors.blue50,
              onTap: user != null
                  ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => PersonalInfoScreen(user: user)))
                  : null,
            ),
            _SettingsTile(
              icon: LucideIcons.fingerprint,
              label: 'Sinh trắc học',
              iconColor: AppColors.orange500,
              bgColor: AppColors.orange50,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BiometricsScreen())),
            ),
            _SettingsTile(
              icon: LucideIcons.lock,
              label: 'Đổi mật khẩu',
              iconColor: AppColors.red600,
              bgColor: AppColors.red50,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ChangePasswordScreen())),
              isLast: true,
            ),

            // Ứng dụng & Hỗ trợ
            const Padding(
              padding: EdgeInsets.only(top: 24, left: 4, bottom: 10),
              child: Text(
                'ỨNG DỤNG & HỖ TRỢ',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
              ),
            ),
            _SettingsTile(
              icon: LucideIcons.languages,
              label: 'Ngôn ngữ',
              iconColor: AppColors.emerald600,
              bgColor: AppColors.emerald50,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LanguageScreen())),
            ),
            _SettingsTile(
              icon: LucideIcons.undo2,
              label: 'Đề nghị cập nhật',
              iconColor: AppColors.indigo600,
              bgColor: AppColors.indigo50,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const UpdateRequestScreen())),
            ),
            _SettingsTile(
              icon: LucideIcons.helpCircle,
              label: 'Hỗ trợ',
              iconColor: AppColors.amber600,
              bgColor: AppColors.amber50,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpScreen())),
              isLast: true,
            ),

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

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback? onTap;
  final bool isFirst;
  final bool isLast;

  const _SettingsTile({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    this.onTap,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: isFirst ? const Radius.circular(24) : Radius.zero,
          bottom: isLast ? const Radius.circular(24) : Radius.zero,
        ),
        border: Border(
          left: const BorderSide(color: AppColors.gray100),
          right: const BorderSide(color: AppColors.gray100),
          top: isFirst ? const BorderSide(color: AppColors.gray100) : BorderSide.none,
          bottom: const BorderSide(color: AppColors.gray100),
        ),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.vertical(
              top: isFirst ? const Radius.circular(24) : Radius.zero,
              bottom: isLast ? const Radius.circular(24) : Radius.zero,
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
                  Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray700)),
                  const Spacer(),
                  const Icon(Icons.chevron_right_rounded, color: AppColors.gray300, size: 20),
                ],
              ),
            ),
          ),
          if (!isLast) const Divider(height: 1, indent: 70, color: AppColors.gray100),
        ],
      ),
    );
  }
}
