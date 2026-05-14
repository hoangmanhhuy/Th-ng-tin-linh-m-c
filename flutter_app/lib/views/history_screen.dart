import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _activeFilter = 'Tất cả';
  final _filters = ['Tất cả', 'Cập nhật', 'Dâng lễ', 'Đóng góp'];

  final _historyItems = const [
    _HistoryItemData(
      id: 1,
      type: 'Cập nhật',
      title: 'Yêu cầu cập nhật thông tin',
      status: 'Đã hoàn thành',
      date: '20/10/2023',
      icon: LucideIcons.userCog,
      borderColor: AppColors.emerald,
      statusTextColor: AppColors.emerald600,
      statusBgColor: AppColors.emerald50,
    ),
    _HistoryItemData(
      id: 2,
      type: 'Dâng lễ',
      title: 'Xin dâng lễ tạ ơn',
      status: 'Đang xử lý',
      date: '18/10/2023',
      icon: LucideIcons.church,
      borderColor: AppColors.orange500,
      statusTextColor: AppColors.amber600,
      statusBgColor: AppColors.amber50,
    ),
    _HistoryItemData(
      id: 3,
      type: 'Cập nhật',
      title: 'Yêu cầu cập nhật thông tin',
      status: 'Đã từ chối',
      date: '15/10/2023',
      icon: LucideIcons.undo2,
      borderColor: AppColors.red,
      statusTextColor: AppColors.red600,
      statusBgColor: AppColors.red50,
    ),
    _HistoryItemData(
      id: 4,
      type: 'Dâng lễ',
      title: 'Xin dâng lễ cầu bình an',
      status: 'Đã hoàn thành',
      date: '10/10/2023',
      icon: LucideIcons.church,
      borderColor: AppColors.emerald,
      statusTextColor: AppColors.emerald600,
      statusBgColor: AppColors.emerald50,
    ),
  ];

  List<_HistoryItemData> get _filtered {
    if (_activeFilter == 'Tất cả') return _historyItems;
    return _historyItems.where((i) => i.type == _activeFilter).toList();
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
          onPressed: () {},
          icon: const Icon(Icons.menu_rounded, color: AppColors.primary),
        ),
        title: const Text(
          'Sacred Link',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(LucideIcons.search, color: AppColors.primary),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Lịch sử hoạt động',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Theo dõi các yêu cầu và cập nhật của bạn.',
                    style: TextStyle(fontSize: 13, color: AppColors.gray400, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm lịch sử...',
                      hintStyle: const TextStyle(color: AppColors.gray400, fontSize: 14),
                      prefixIcon: const Icon(LucideIcons.search, size: 18, color: AppColors.gray300),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide.none),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Filters
          SliverToBoxAdapter(
            child: SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final isActive = f == _activeFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isActive ? AppColors.primary : AppColors.gray100),
                        boxShadow: isActive
                            ? [BoxShadow(color: AppColors.primary.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 2))]
                            : null,
                      ),
                      child: Text(
                        f,
                        style: TextStyle(
                          color: isActive ? Colors.white : AppColors.gray400,
                          fontWeight: FontWeight.w900,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverPadding(padding: EdgeInsets.only(top: 16)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) {
                  final item = _filtered[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _HistoryCard(item: item),
                  );
                },
                childCount: _filtered.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryItemData {
  final int id;
  final String type;
  final String title;
  final String status;
  final String date;
  final IconData icon;
  final Color borderColor;
  final Color statusTextColor;
  final Color statusBgColor;

  const _HistoryItemData({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    required this.icon,
    required this.borderColor,
    required this.statusTextColor,
    required this.statusBgColor,
  });
}

class _HistoryCard extends StatelessWidget {
  final _HistoryItemData item;
  const _HistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
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
              decoration: BoxDecoration(
                color: item.borderColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 12, 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(item.icon, size: 22, color: AppColors.gray400),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.gray800),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: item.statusBgColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.status,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: item.statusTextColor, letterSpacing: 0.5),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '• ${item.date}',
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.gray300, letterSpacing: 1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: AppColors.gray300, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
