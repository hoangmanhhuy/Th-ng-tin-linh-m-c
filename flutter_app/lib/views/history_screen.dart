import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/api_models.dart';
import '../services/api_client.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _activeFilterIndex = 0;
  late final HistoryService _service;
  List<HistoryRecord> _allItems = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = RemoteHistoryService(context.read<ApiClient>());
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final items = await _service.getHistory();
      if (mounted) setState(() { _allItems = items; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final filters = [l10n.filterAll, l10n.filterUpdate, l10n.filterMass, l10n.filterContribution];

    // Convert HistoryRecord → _HistoryItemData for display
    List<_HistoryItemData> toDisplay(List<HistoryRecord> records) {
      return records.map((r) {
        final isMass = r.type == 'mass';
        final isCompleted = r.status == 'completed';
        final isRejected = r.status == 'rejected';
        return _HistoryItemData(
          id: r.id,
          typeIndex: isMass ? 2 : 1,
          title: r.title,
          status: isCompleted
              ? l10n.statusCompleted
              : isRejected
                  ? l10n.statusRejected
                  : l10n.statusProcessing,
          date: r.date,
          icon: isMass ? LucideIcons.church : LucideIcons.userCog,
          borderColor: isCompleted
              ? AppColors.emerald
              : isRejected
                  ? AppColors.red
                  : AppColors.orange500,
          statusTextColor: isCompleted
              ? AppColors.emerald600
              : isRejected
                  ? AppColors.red600
                  : AppColors.amber600,
          statusBgColor: isCompleted
              ? AppColors.emerald50
              : isRejected
                  ? AppColors.red50
                  : AppColors.amber50,
        );
      }).toList();
    }

    final allDisplayItems = toDisplay(_allItems);
    final filtered = _activeFilterIndex == 0
        ? allDisplayItems
        : allDisplayItems.where((i) => i.typeIndex == _activeFilterIndex).toList();

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
        title: Text(
          l10n.appTitleShort,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _loadHistory,
            icon: const Icon(LucideIcons.refreshCw, color: AppColors.primary, size: 20),
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
                  Text(
                    l10n.historyTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.historySubtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.gray400, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      hintText: l10n.historySearch,
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
                itemCount: filters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final f = filters[i];
                  final isActive = i == _activeFilterIndex;
                  return GestureDetector(
                    onTap: () => setState(() => _activeFilterIndex = i),
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
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_error != null)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.wifiOff, color: AppColors.gray300, size: 48),
                    const SizedBox(height: 12),
                    Text(
                      l10n.historySubtitle,
                      style: const TextStyle(color: AppColors.gray400),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadHistory,
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            )
          else if (filtered.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Icon(LucideIcons.inbox, color: AppColors.gray200, size: 64),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) {
                    final item = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _HistoryCard(item: item),
                    );
                  },
                  childCount: filtered.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HistoryItemData {
  final String id;
  final int typeIndex; // 1=update, 2=mass
  final String title;
  final String status;
  final String date;
  final IconData icon;
  final Color borderColor;
  final Color statusTextColor;
  final Color statusBgColor;

  const _HistoryItemData({
    required this.id,
    required this.typeIndex,
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
