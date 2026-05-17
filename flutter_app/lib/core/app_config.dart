// lib/core/app_config.dart
// Cấu hình môi trường ứng dụng.
//
// Để thay đổi môi trường khi build:
//   flutter build ios --dart-define=ENV=prod --dart-define=BASE_URL=https://api.yourdomain.com
//
// Mặc định (dev): app thử kết nối server, nếu thất bại tự fallback mock data.

class AppConfig {
  AppConfig._();

  /// Môi trường: "dev" hoặc "prod"
  static const String env =
      String.fromEnvironment('ENV', defaultValue: 'dev');

  static bool get isDev => env == 'dev';
  static bool get isProd => env == 'prod';

  /// Base URL của API backend.
  /// Dev:  http://dev.diocese.api.admin.giaophanphucuong.com
  /// Prod: https://diocese-client-api.cmate.vn
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'https://diocese-client-api.cmate.vn',
  );

  /// Dev base URL — dùng khi build với --dart-define=ENV=dev
  static const String _devBaseUrl =
      'http://dev.diocese.api.admin.giaophanphucuong.com';

  /// Chọn base URL theo môi trường
  static String get effectiveBaseUrl => isDev ? _devBaseUrl : baseUrl;

  /// Đường dẫn prefix của API
  static const String apiPrefix = '/api/v1';

  /// Full API root (dùng làm baseUrl cho Dio)
  static String get apiBase => '$effectiveBaseUrl$apiPrefix';

  // ── Timeouts ────────────────────────────────────────────────────────────────
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  static const Duration sendTimeout = Duration(seconds: 30);

  // ── Keys lưu trữ an toàn (flutter_secure_storage) ───────────────────────────
  static const String kAccessToken = 'access_token';
  static const String kRefreshToken = 'refresh_token';
  static const String kPriestId = 'priest_id';
  static const String kPriestProfile = 'priest_profile';

  // ── API Endpoints (tương đối so với apiBase) ─────────────────────────────────
  // Auth
  static const String epLogin = '/priest/auth/login';
  static const String epRefresh = '/priest/auth/token-refresh';
  static const String epChangePassword = '/priest/auth/change-password';
  static const String epPriestProfile = '/priest/auth/profile';

  // Priest
  static const String epPriests = '/priest';
  static const String epPriestSearch = '/priest/mobile-search';
  static const String epPriestVerify = '/priest/verify';
  static const String epPriestQr = '/priest/qr-code';

  // NFC Cards
  static const String epNfcCardsOwn = '/priest_cards/priest/basic';
  static String epNfcCards(String priestId) => '/priest_cards/priest/$priestId';

  // Mass requests
  static const String epMassRequests = '/forms/mass_request';
  static const String epMassRequesterHistory = '/forms/mass_request/requester';
  static const String epMassApproverHistory = '/forms/mass_request/approver';
  static const String epHistory = '/forms/mass_request/requester';

  // Update profile
  static const String epUpdateRequests = '/priest/edit-requests';

  // Notifications
  static const String epNotifications = '/notifications';
  static const String epNotificationsUnread = '/notifications/unread-count';
  static const String epNotificationsReadAll = '/notifications/read-all';

  // Emergency anointing — nearest facility/church
  static const String epChurchesNearby = '/facility/nearest';
}
