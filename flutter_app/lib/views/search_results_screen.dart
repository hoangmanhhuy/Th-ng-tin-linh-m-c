import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';
import '../models/models.dart';
import 'search_detail_screen.dart';
import 'nfc_management_screen.dart';
import 'mass_request_screen.dart';

class SearchResultsScreen extends StatelessWidget {
  final String query;
  final String diocese;
  final List<UserProfile> results;

  const SearchResultsScreen({
    super.key,
    required this.query,
    required this.diocese,
    required this.results,
  });

  String _abbreviateDiocese(String diocese) {
    return diocese
        .replaceAll('Tổng Giáo phận', 'TGP')
        .replaceAll('Giáo phận', 'GP');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.primary,
          ),
        ),
        title: const Text(
          'Kết quả tìm kiếm',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: Column(
        children: [
          // Summary bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      if (query.isNotEmpty)
                        _Chip(
                          label: '"$query"',
                          icon: LucideIcons.search,
                          color: AppColors.primary,
                          bg: AppColors.blue50,
                        ),
                      if (diocese.isNotEmpty &&
                          diocese.toLowerCase() != 'chọn giáo phận' &&
                          diocese.toLowerCase() != 'chọn giáo phận')
                        _Chip(
                          label: _abbreviateDiocese(diocese),
                          icon: LucideIcons.church,
                          color: AppColors.indigo600,
                          bg: AppColors.indigo50,
                        ),
                      if (query.isEmpty &&
                          (diocese.isEmpty ||
                              diocese.toLowerCase() == 'chọn giáo phận'))
                        _Chip(
                          label: 'Tất cả',
                          icon: LucideIcons.users,
                          color: AppColors.emerald600,
                          bg: AppColors.emerald50,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: results.isEmpty
                        ? AppColors.gray100
                        : AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${results.length} kết quả',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: results.isEmpty
                          ? AppColors.gray400
                          : AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.gray100),

          // List or empty state
          Expanded(
            child: results.isEmpty
                ? _EmptyState()
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      return _PriestResultCard(
                        priest: results[index],
                        abbreviate: _abbreviateDiocese,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final Color bg;

  const _Chip({
    required this.label,
    required this.icon,
    required this.color,
    required this.bg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                LucideIcons.searchX,
                size: 36,
                color: AppColors.gray400,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Không tìm thấy linh mục',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: AppColors.gray700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thử tìm kiếm với tên khác hoặc\nthay đổi giáo phận.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.gray500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _PriestResultCard extends StatelessWidget {
  final UserProfile priest;
  final String Function(String) abbreviate;

  const _PriestResultCard({
    required this.priest,
    required this.abbreviate,
  });

  void _resetPassword(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56, height: 56,
              decoration: const BoxDecoration(color: AppColors.red50, shape: BoxShape.circle),
              child: const Icon(LucideIcons.keyRound, color: AppColors.red, size: 26),
            ),
            const SizedBox(height: 16),
            const Text('Reset mật khẩu?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.gray800)),
            const SizedBox(height: 8),
            const Text(
              'Mật khẩu sẽ được đặt lại về mặc định. Linh mục cần đổi mật khẩu khi đăng nhập lại.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: AppColors.gray500, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.gray400, fontWeight: FontWeight.w700)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã reset mật khẩu cho LM. ${priest.holyName} ${priest.fullName}'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Reset', style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.gray100),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
      ),
      child: Column(
        children: [
          // ── Priest info row (tap → details) ──
          InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchDetailScreen(priest: priest)),
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 52, height: 52,
                    decoration: BoxDecoration(color: AppColors.blue100, borderRadius: BorderRadius.circular(16)),
                    child: const Icon(LucideIcons.user, size: 24, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LM. ${priest.holyName}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 0.3),
                        ),
                        const SizedBox(height: 2),
                        Text(priest.fullName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            const Icon(LucideIcons.church, size: 12, color: AppColors.gray400),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                priest.parish ?? priest.diocese,
                                style: const TextStyle(fontSize: 12, color: AppColors.gray500),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppColors.blue50, borderRadius: BorderRadius.circular(8), border: Border.all(color: AppColors.blue100)),
                        child: Text(abbreviate(priest.diocese), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      ),
                      const SizedBox(height: 6),
                      const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.gray300),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ── Divider ──
          const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.gray100),

          // ── Management action buttons ──
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
            child: Row(
              children: [
                Expanded(
                  child: _MgmtBtn(
                    icon: LucideIcons.keyRound,
                    label: 'Reset MK',
                    color: AppColors.red600,
                    bg: AppColors.red50,
                    onTap: () => _resetPassword(context),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MgmtBtn(
                    icon: Icons.nfc_rounded,
                    label: 'Thẻ NFC',
                    color: AppColors.orange500,
                    bg: AppColors.orange50,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => NfcManagementScreen(priest: priest)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MgmtBtn(
                    icon: LucideIcons.clock,
                    label: 'Xin lễ',
                    color: AppColors.indigo600,
                    bg: AppColors.indigo50,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => MassRequestScreen(priest: priest)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MgmtBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bg;
  final VoidCallback onTap;

  const _MgmtBtn({
    required this.icon,
    required this.label,
    required this.color,
    required this.bg,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: color)),
          ],
        ),
      ),
    );
  }
}
