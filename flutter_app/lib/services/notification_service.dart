// lib/services/notification_service.dart
// Service lấy và quản lý thông báo của linh mục.

import '../core/app_config.dart';
import '../models/api_models.dart';
import 'api_client.dart';

abstract class NotificationService {
  Future<List<AppNotification>> getNotifications({bool unreadOnly});
  Future<void> markAllRead();
}

class RemoteNotificationService implements NotificationService {
  final ApiClient _client;
  RemoteNotificationService(this._client);

  @override
  Future<List<AppNotification>> getNotifications({
    bool unreadOnly = false,
  }) async {
    try {
      final resp = await _client.get(
        AppConfig.epNotifications,
        params: {'page': 1, 'pageSize': 50},
      );
      // Real API wraps in: { status, statusCode, payload: [...] }
      final raw = resp.data;
      List<dynamic> data;
      if (raw is Map<String, dynamic> && raw['payload'] is List) {
        data = raw['payload'] as List<dynamic>;
      } else if (raw is Map<String, dynamic> && raw['data'] is List) {
        data = raw['data'] as List<dynamic>;
      } else if (raw is List) {
        data = raw;
      } else {
        data = [];
      }
      final notifications = data
          .map((e) => AppNotification.fromJson(e as Map<String, dynamic>))
          .toList();
      if (unreadOnly) {
        return notifications.where((n) => !n.isRead).toList();
      }
      return notifications;
    } on Exception {
      return _mockNotifications; // offline fallback
    }
  }

  @override
  Future<void> markAllRead() async {
    try {
      await _client.patch(AppConfig.epNotificationsReadAll);
    } on Exception {
      // Bỏ qua lỗi khi offline
    }
  }

  // Mock data — xoá khi backend sẵn sàng
  // id dùng String UUID để khớp với real API
  static const List<AppNotification> _mockNotifications = [
    AppNotification(
      id: 'mock-notif-001',
      title: 'Yêu cầu dâng lễ mới',
      content: 'Có yêu cầu dâng lễ an táng mới gửi đến.',
      time: '5 phút trước',
      isRead: false,
      type: 'MASS_REQUEST',
    ),
    AppNotification(
      id: 'mock-notif-002',
      title: 'Cập nhật hệ thống',
      content: 'Hệ thống đã được cập nhật lên phiên bản mới.',
      time: '2 giờ trước',
      isRead: true,
      type: 'SYSTEM',
    ),
    AppNotification(
      id: 'mock-notif-003',
      title: 'Nhắc lịch công tác',
      content: 'Ngày mai bạn có buổi dâng lễ tại Giáo xứ Tân Định lúc 08:00.',
      time: '1 ngày trước',
      isRead: true,
      type: 'CALENDAR',
    ),
    AppNotification(
      id: 'mock-notif-004',
      title: 'Yêu cầu cập nhật thông tin',
      content: 'Văn phòng Giáo phận yêu cầu bạn cập nhật học vị mới.',
      time: '3 ngày trước',
      isRead: true,
      type: 'PROFILE',
    ),
  ];
}
