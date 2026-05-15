import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../viewmodels/viewmodels.dart';
import '../models/models.dart';
import '../core/app_theme.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';
import 'qr_screen.dart';
import 'help_screen.dart';
import 'mass_request_screen.dart';
import 'search_detail_screen.dart';
import 'priest_profile_screen.dart';

// ─── Public Home ────────────────────────────────────────────────────────────

class PublicHomeScreen extends StatelessWidget {
  const PublicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          _PublicAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _SearchCard(),
                const SizedBox(height: 16),
                _EmergencyCard(),
                const SizedBox(height: 16),
                _DailyWordCard(),
                const SizedBox(height: 20),
                _PopularPriestSection(context: context),
                const SizedBox(height: 20),
                _InfoSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PublicAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.white.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      title: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 8),
              ],
            ),
            child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 10),
          const Text(
            'THÔNG TIN LINH MỤC',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
      titleSpacing: 16,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            ),
            icon: const Icon(LucideIcons.logIn, size: 14),
            label: const Text('Đăng nhập', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              side: const BorderSide(color: AppColors.gray200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.gray100),
      ),
    );
  }
}

class _SearchCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tìm kiếm linh mục',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textMain),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Nhập tên linh mục',
              hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
              prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.gray400),
              filled: true,
              fillColor: AppColors.gray50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.gray50,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: 'Chọn giáo phận',
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.gray400),
                style: const TextStyle(color: AppColors.textMain, fontSize: 14),
                items: const [
                  DropdownMenuItem(value: 'Chọn giáo phận', child: Text('Chọn giáo phận', style: TextStyle(color: AppColors.gray400))),
                  DropdownMenuItem(value: 'Phú Cường', child: Text('Phú Cường')),
                  DropdownMenuItem(value: 'Sài Gòn', child: Text('Sài Gòn')),
                  DropdownMenuItem(value: 'Hà Nội', child: Text('Hà Nội')),
                ],
                onChanged: (_) {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmergencyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.red50,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFFFE2E2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DÀNH CHO TRƯỜNG HỢP KHẨN CẤP',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.redAccent, letterSpacing: 1),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Liên hệ xức dầu',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.red900),
                ),
                const Text(
                  'Tìm linh mục gần nhất để cử hành bí tích',
                  style: TextStyle(fontSize: 12, color: Colors.redAccent),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppColors.red100,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(LucideIcons.phone, color: Colors.red, size: 24),
          ),
        ],
      ),
    );
  }
}

class _DailyWordCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9F2),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.orange50),
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
                  color: AppColors.orange100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(LucideIcons.bookOpen, size: 16, color: AppColors.amber600),
              ),
              const SizedBox(width: 8),
              const Text(
                'LỜI CHÚA HÔM NAY',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.orangeAccent, letterSpacing: 1.5),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.red50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.red100),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6, height: 6,
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 4),
                    const Text('Lễ kính buộc', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: Colors.red, letterSpacing: 0.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Lễ Kính Thánh Tâm Chúa Giêsu',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFF7C2D12)),
          ),
          const SizedBox(height: 8),
          const Text(
            '"Ta là con đường, là sự thật và là sự sống. Không ai đến được với Cha mà không qua Thầy."',
            style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic, color: AppColors.gray800, height: 1.5),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)],
              ),
              child: const Text('— Ga 14, 6', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text(
                'Suy niệm thêm',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.orange500, letterSpacing: 1),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward_rounded, size: 14, color: AppColors.orange500),
            ],
          ),
        ],
      ),
    );
  }
}

class _PopularPriestSection extends StatelessWidget {
  final BuildContext context;
  const _PopularPriestSection({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Linh mục tìm nhiều',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.textMain),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Xem tất cả', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 13)),
                  Icon(Icons.chevron_right_rounded, size: 16, color: AppColors.primary),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _PriestCard(
          holyName: 'LM. Giuse',
          fullName: 'Nguyễn Văn A',
          parish: 'Giáo xứ Tân Định',
          role: 'Cha sở',
          diocese: 'Sài Gòn',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SearchDetailScreen()),
          ),
        ),
        const SizedBox(height: 12),
        _PriestCard(
          holyName: 'LM. Phanxicô Xaviê',
          fullName: 'Trần Văn B',
          parish: 'Đại chủng viện Thánh Giuse',
          role: 'Giáo sư',
          diocese: 'Hà Nội',
        ),
      ],
    );
  }
}

class _PriestCard extends StatelessWidget {
  final String holyName;
  final String fullName;
  final String parish;
  final String role;
  final String diocese;
  final VoidCallback? onTap;

  const _PriestCard({
    required this.holyName,
    required this.fullName,
    required this.parish,
    required this.role,
    required this.diocese,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AppColors.gray100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 80,
                  height: 110,
                  decoration: BoxDecoration(
                    color: AppColors.gray100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(LucideIcons.user, size: 40, color: AppColors.gray300),
                ),
                Positioned(
                  bottom: -10,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: diocese == 'Sài Gòn' ? const Color(0xFFFFEEDD) : const Color(0xFFE1EFFF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 4)],
                      ),
                      child: Text(
                        diocese,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          color: diocese == 'Sài Gòn' ? const Color(0xFF884400) : const Color(0xFF004AC6),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      holyName,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      fullName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(LucideIcons.church, size: 12, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            parish,
                            style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.verified_rounded, size: 12, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text(role, style: const TextStyle(fontSize: 12, color: AppColors.gray500)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.gray50,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(LucideIcons.info, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Thông tin cần biết',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _InfoRow(
            icon: LucideIcons.shieldCheck,
            title: 'Dữ liệu chính thức',
            description: 'Thông tin được xác thực bởi văn phòng các Giáo phận.',
          ),
          const SizedBox(height: 16),
          _InfoRow(
            icon: LucideIcons.search,
            title: 'Hướng dẫn tìm kiếm',
            description: 'Sử dụng tên thánh hoặc tên thật để có kết quả chính xác nhất.',
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoRow({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
          ),
          child: Icon(icon, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: AppColors.textMain)),
              const SizedBox(height: 4),
              Text(description, style: const TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Priest Home ─────────────────────────────────────────────────────────────

class PriestHomeScreen extends StatelessWidget {
  const PriestHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final liturgicalData =
        context.read<LiturgicalViewModel>().getLiturgicalData(DateTime.now());
    final auth = context.read<AuthViewModel>();
    final user = auth.currentUser!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CustomScrollView(
        slivers: [
          _PriestAppBar(auth: auth),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _PriestIdCard(user: user),
                const SizedBox(height: 16),
                _ActionBar(context: context),
                const SizedBox(height: 16),
                _MassRequestCard(context: context),
                const SizedBox(height: 20),
                _SearchSection(context: context),
                const SizedBox(height: 16),
                _LiturgicalSection(data: liturgicalData),
                const SizedBox(height: 12),
                _HelpButton(context: context),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PriestAppBar extends StatelessWidget {
  final AuthViewModel auth;
  const _PriestAppBar({required this.auth});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface.withOpacity(0.95),
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(LucideIcons.shieldCheck, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          const Text(
            'THÔNG TIN LINH MỤC',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.5),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => auth.logout(),
          child: const Text(
            'THOÁT',
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1),
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              ),
              icon: const Icon(LucideIcons.bell, color: AppColors.primary),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.surface, width: 1.5),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

class _PriestIdCard extends StatelessWidget {
  final UserProfile user;
  const _PriestIdCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -16,
            bottom: -16,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -12,
            top: -12,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [BoxShadow(color: Color(0x22000000), blurRadius: 8)],
                ),
                child: const Icon(LucideIcons.user, color: AppColors.primary, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'CĂN CƯỚC LINH MỤC',
                      style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'LM. ${user.holyName.toUpperCase()}',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                    Text(
                      user.fullName.toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w900, height: 1.2),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.diocese,
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PriestProfileScreen(user: user)),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(LucideIcons.info, color: Colors.white, size: 20),
                      SizedBox(height: 4),
                      Text('THÔNG TIN', style: TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.w900, letterSpacing: 1)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionBar extends StatelessWidget {
  final BuildContext context;
  const _ActionBar({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _ActionItem(
            icon: Icons.nfc_rounded,
            label: 'Quét thẻ',
            color: AppColors.orange500,
            onTap: () {},
          ),
          _ActionItem(
            icon: LucideIcons.clock,
            label: 'Xin lễ',
            color: AppColors.indigo600,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MassRequestScreen()),
            ),
          ),
          _ActionItem(
            icon: LucideIcons.qrCode,
            label: 'Mã QR',
            color: AppColors.fuchsia500,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const QrScreen()),
            ),
          ),
          _ActionItem(
            icon: LucideIcons.fingerprint,
            label: 'FaceID',
            color: AppColors.emerald,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray600)),
        ],
      ),
    );
  }
}

class _MassRequestCard extends StatelessWidget {
  final BuildContext context;
  const _MassRequestCard({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 5,
              decoration: const BoxDecoration(
                color: AppColors.indigo600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 16),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.gray50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gray100),
                      ),
                      child: const Icon(LucideIcons.clock, size: 20, color: AppColors.indigo600),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Linh mục Phaolô Hoàng Mạnh Huy Giáo phận Phú Cường xin dâng lễ an táng.',
                        style: TextStyle(fontSize: 13, color: AppColors.gray800, height: 1.4),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('5 PHÚT TRƯỚC', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray300, letterSpacing: 1.5)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MassRequestDetailScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.gray50,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.gray100),
                            ),
                            child: const Text('CHI TIẾT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.gray500)),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.indigo600,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [BoxShadow(color: AppColors.indigo600.withOpacity(0.3), blurRadius: 8)],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.check_rounded, color: Colors.white, size: 14),
                              SizedBox(width: 4),
                              Text('DUYỆT', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
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

class _SearchSection extends StatelessWidget {
  final BuildContext context;
  const _SearchSection({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tìm kiếm Linh mục',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textMain),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.gray100),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập tên Linh mục...',
                  hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
                  prefixIcon: const Icon(LucideIcons.search, size: 20, color: AppColors.gray300),
                  filled: true,
                  fillColor: AppColors.surface,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: AppColors.primary, width: 1)),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: 'Chọn Giáo phận',
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.gray300),
                    items: const [
                      DropdownMenuItem(value: 'Chọn Giáo phận', child: Text('Chọn Giáo phận', style: TextStyle(color: AppColors.gray400, fontSize: 14))),
                      DropdownMenuItem(value: 'Phú Cường', child: Text('Phú Cường')),
                      DropdownMenuItem(value: 'Sài Gòn', child: Text('Sài Gòn')),
                      DropdownMenuItem(value: 'Hà Nội', child: Text('Hà Nội')),
                    ],
                    onChanged: (_) {},
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SearchDetailScreen()),
                  ),
                  icon: const Icon(LucideIcons.search, size: 16),
                  label: const Text('TÌM KIẾM', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiturgicalSection extends StatelessWidget {
  final LiturgicalData data;
  const _LiturgicalSection({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray100),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.emerald50.withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: const Border(bottom: BorderSide(color: Color(0xFFD1FAE5))),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.emerald100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFA7F3D0)),
                  ),
                  child: const Icon(LucideIcons.calendar, size: 20, color: AppColors.emerald600),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('NGÀY PHỤNG VỤ', style: TextStyle(color: AppColors.emerald600, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    Text(data.dateString, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.emerald50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.emerald100),
                  ),
                  child: Text(
                    data.season,
                    style: const TextStyle(color: AppColors.emerald700, fontSize: 9, fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          ),
          // Feast Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.amber50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.amber100),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.amber100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.star_rounded, size: 16, color: AppColors.amber600),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('LỄ KÍNH / KỶ NIỆM', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: AppColors.amber, letterSpacing: 1)),
                        Text(data.feast, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray700)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Readings
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: data.readings.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: r.color,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(r.icon, color: r.iconColor, size: 14),
                    ),
                    const SizedBox(width: 10),
                    Text(r.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.gray600)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(r.text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary)),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpButton extends StatelessWidget {
  final BuildContext context;
  const _HelpButton({required this.context});

  @override
  Widget build(BuildContext ctx) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HelpScreen()),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(LucideIcons.helpCircle, size: 16, color: AppColors.primary),
            SizedBox(width: 6),
            Text(
              'Hướng dẫn sử dụng Căn cước Linh mục',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
