import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';
import '../models/api_models.dart';
import '../services/api_client.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationService _service;
  List<AppNotification> _notifications = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _service = RemoteNotificationService(context.read<ApiClient>());
    _load();
  }

  Future<void> _load() async {
    setState(() { _isLoading = true; _error = null; });
    try {
      final items = await _service.getNotifications();
      if (mounted) setState(() { _notifications = items; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() { _isLoading = false; _error = e.toString(); });
    }
  }

  Future<void> _markAllRead() async {
    await _service.markAllRead();
    if (mounted) {
      setState(() {
        _notifications = _notifications
            .map((n) => AppNotification(
                  id: n.id,
                  title: n.title,
                  content: n.content,
                  time: n.time,
                  isRead: true,
                  type: n.type,
                ))
            .toList();
      });
    }
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
          l10n.notificationsTitle,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.primary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _load,
            icon: const Icon(LucideIcons.refreshCw, color: AppColors.primary, size: 18),
          ),
        ],
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: AppColors.gray100),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(LucideIcons.wifiOff, color: AppColors.gray300, size: 48),
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: AppColors.gray400)),
                      const SizedBox(height: 16),
                      ElevatedButton(onPressed: _load, child: const Text('Thử lại')),
                    ],
                  ),
                )
              : CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      sliver: SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.notifLatest,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gray400, letterSpacing: 1.5),
                            ),
                            TextButton(
                              onPressed: _markAllRead,
                              style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                              child: Text(
                                l10n.markAllRead,
                                style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w700, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (_notifications.isEmpty)
                      const SliverFillRemaining(
                        child: Center(child: Icon(LucideIcons.inbox, color: AppColors.gray200, size: 64)),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _NotifCard(data: _notifications[i]),
                            ),
                            childCount: _notifications.length,
                          ),
                        ),
                      ),
                  ],
                ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final AppNotification data;
  const _NotifCard({required this.data});

  String get _normalizedType {
    final t = data.type.toUpperCase();
    if (t.contains('MASS')) return 'mass';
    if (t.contains('SYSTEM') || t.contains('UPDATE')) return 'system';
    if (t.contains('CALENDAR') || t.contains('SCHEDULE')) return 'calendar';
    return 'profile';
  }

  Color get _iconBg {
    switch (_normalizedType) {
      case 'mass': return AppColors.indigo50;
      case 'system': return AppColors.emerald50;
      case 'calendar': return AppColors.amber50;
      default: return AppColors.blue50;
    }
  }

  Color get _iconColor {
    switch (_normalizedType) {
      case 'mass': return AppColors.indigo600;
      case 'system': return AppColors.emerald600;
      case 'calendar': return AppColors.amber600;
      default: return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (_normalizedType) {
      case 'mass': return LucideIcons.clock;
      case 'system': return LucideIcons.badgeCheck;
      case 'calendar': return LucideIcons.calendar;
      default: return LucideIcons.user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: data.isRead ? AppColors.gray100 : AppColors.blue100),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(_icon, size: 20, color: _iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: data.isRead ? AppColors.gray700 : AppColors.gray900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data.content,
                      style: const TextStyle(fontSize: 12, color: AppColors.gray500, height: 1.4),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      data.time.toUpperCase(),
                      style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: AppColors.gray300, letterSpacing: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (!data.isRead)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
