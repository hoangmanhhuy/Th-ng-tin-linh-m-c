import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/app_theme.dart';
import '../core/app_strings.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  List<_NotifData> _buildNotifications(AppStrings l10n) => [
    _NotifData(
      id: 1,
      title: l10n.isEn ? 'New Mass Request' : 'Yêu cầu dâng lễ mới',
      content: l10n.isEn
          ? 'Fr. Paul Hoang Manh Huy sent a request for a Funeral Mass.'
          : 'Linh mục Phaolô Hoàng Mạnh Huy gửi yêu cầu dâng lễ an táng.',
      time: l10n.isEn ? '5 minutes ago' : '5 phút trước',
      isRead: false,
      type: 'mass',
    ),
    _NotifData(
      id: 2,
      title: l10n.isEn ? 'System Update' : 'Cập nhật hệ thống',
      content: l10n.isEn
          ? 'Sacred Link has been updated to version 1.0.4.'
          : 'Hệ thống Sacred Link đã được cập nhật lên phiên bản 1.0.4.',
      time: l10n.isEn ? '2 hours ago' : '2 giờ trước',
      isRead: true,
      type: 'system',
    ),
    _NotifData(
      id: 3,
      title: l10n.isEn ? 'Schedule Reminder' : 'Nhắc lịch công tác',
      content: l10n.isEn
          ? 'You have a Mass at Parish of Tan Dinh tomorrow at 08:00.'
          : 'Ngày mai bạn có buổi dâng lễ tại Giáo xứ Tân Định lúc 08:00.',
      time: l10n.isEn ? '1 day ago' : '1 ngày trước',
      isRead: true,
      type: 'calendar',
    ),
    _NotifData(
      id: 4,
      title: l10n.isEn ? 'Profile Update Request' : 'Yêu cầu cập nhật thông tin',
      content: l10n.isEn
          ? 'The Diocesan Office requests you update your academic degree.'
          : 'Văn phòng Giáo phận yêu cầu bạn cập nhật học vị mới.',
      time: l10n.isEn ? '3 days ago' : '3 ngày trước',
      isRead: true,
      type: 'profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppStrings.of(context);
    final notifications = _buildNotifications(l10n);
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
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded, color: AppColors.primary),
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
                    onPressed: () {},
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
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (_, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _NotifCard(data: notifications[i]),
                ),
                childCount: notifications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotifData {
  final int id;
  final String title;
  final String content;
  final String time;
  final bool isRead;
  final String type;

  const _NotifData({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
    required this.type,
  });
}

class _NotifCard extends StatelessWidget {
  final _NotifData data;
  const _NotifCard({required this.data});

  Color get _iconBg {
    switch (data.type) {
      case 'mass': return AppColors.indigo50;
      case 'system': return AppColors.emerald50;
      case 'calendar': return AppColors.amber50;
      default: return AppColors.blue50;
    }
  }

  Color get _iconColor {
    switch (data.type) {
      case 'mass': return AppColors.indigo600;
      case 'system': return AppColors.emerald600;
      case 'calendar': return AppColors.amber600;
      default: return AppColors.primary;
    }
  }

  IconData get _icon {
    switch (data.type) {
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
