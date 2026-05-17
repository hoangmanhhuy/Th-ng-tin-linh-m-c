// lib/models/api_models.dart
// Models cho API request / response — tách khỏi domain model để dễ versioning.
// Mapping theo API thực của Giáo phận Phú Cường:
//   base: https://diocese-client-api.cmate.vn/api/v1/

import 'package:intl/intl.dart';
import 'models.dart';

// ── Helpers ───────────────────────────────────────────────────────────────────

/// Format ISO date thành thời gian tương đối (vừa xong, 5 phút trước, ...)
String _relativeTime(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return '';
  try {
    DateTime date;
    try {
      date = DateTime.parse(rawDate);
    } catch (_) {
      date = DateTime.parse(rawDate.replaceFirst(' ', 'T'));
    }
    final now = DateTime.now().toUtc();
    final diff = now.difference(date);
    if (diff.inHours < 24) {
      if (diff.inHours <= 0) {
        if (diff.inMinutes <= 1) return 'Vừa xong';
        return '${diff.inMinutes} phút trước';
      }
      return '${diff.inHours} giờ trước';
    }
    return DateFormat('dd/MM/yyyy').format(date.toLocal());
  } catch (_) {
    return rawDate;
  }
}

/// Parse ISO date → dd/MM/yyyy
String _fmtDate(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final dt = DateTime.parse(iso).toUtc().add(const Duration(hours: 7));
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  } catch (_) {
    return iso;
  }
}

// ── Auth ─────────────────────────────────────────────────────────────────────

class AuthResult {
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final UserProfile priest;

  const AuthResult({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.priest,
  });

  /// Real API response:
  /// { "accessToken": "...", "refreshToken": "...", "userInfo": { userId, cId, fullName, saints, phone, level } }
  factory AuthResult.fromJson(Map<String, dynamic> json) {
    final userInfoRaw = json['userInfo'];
    UserProfile priest;
    if (userInfoRaw is Map<String, dynamic>) {
      priest = UserProfile.fromUserInfo(userInfoRaw);
    } else if (json['priest'] is Map<String, dynamic>) {
      // legacy / future format
      priest = UserProfile.fromJson(json['priest'] as Map<String, dynamic>);
    } else {
      priest = const UserProfile(id: '', holyName: '', fullName: '', diocese: '');
    }

    return AuthResult(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int? ?? 3600,
      priest: priest,
    );
  }
}

// ── API Error ─────────────────────────────────────────────────────────────────

class ApiError implements Exception {
  final String code;
  final String message;
  final int? statusCode;

  const ApiError({
    required this.code,
    required this.message,
    this.statusCode,
  });

  /// Real API error format: { "status": false, "statusCode": 401, "message": "..." }
  factory ApiError.fromJson(Map<String, dynamic> json, {int? statusCode}) =>
      ApiError(
        code: json['code'] as String? ??
            'HTTP_${json['statusCode'] ?? statusCode ?? 0}',
        message: json['message'] as String? ?? 'Có lỗi xảy ra',
        statusCode: json['statusCode'] as int? ?? statusCode,
      );

  factory ApiError.network() => const ApiError(
        code: 'NETWORK_ERROR',
        message: 'Không thể kết nối máy chủ. Vui lòng kiểm tra kết nối mạng.',
      );

  factory ApiError.timeout() => const ApiError(
        code: 'TIMEOUT',
        message: 'Kết nối quá thời gian chờ. Vui lòng thử lại.',
      );

  bool get isNetworkError => code == 'NETWORK_ERROR' || code == 'TIMEOUT';
  bool get isAuthError =>
      code == 'INVALID_CREDENTIALS' ||
      code == 'ACCOUNT_LOCKED' ||
      statusCode == 401;
  bool get isWrongPassword => code == 'WRONG_CURRENT_PASSWORD';

  @override
  String toString() => 'ApiError($code): $message';
}

// ── NFC Card ─────────────────────────────────────────────────────────────────

class NfcCard {
  final String id;
  final String addedDate;
  final bool isActive;

  const NfcCard({
    required this.id,
    required this.addedDate,
    this.isActive = true,
  });

  /// Real API format (PriestCardData):
  /// { "cardNumber": "ab:cd:ef:12", "status": "ACTIVE"/"INACTIVE", "expirationDate": "...", "created": "..." }
  factory NfcCard.fromJson(Map<String, dynamic> json) => NfcCard(
        id: json['cardNumber'] as String? ?? json['id'] as String? ?? '',
        addedDate: _fmtDate(
          json['created'] as String? ?? json['addedDate'] as String?,
        ),
        isActive: (json['status'] as String? ?? 'ACTIVE').toUpperCase() ==
            'ACTIVE',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'addedDate': addedDate,
        'isActive': isActive,
      };
}

// ── Mass Request ──────────────────────────────────────────────────────────────

class MassRequestPayload {
  final String massType;   // purpose
  final String scheduledAt; // estimatedTime (ISO 8601)
  final String location;
  final String intention;  // note
  final String? forPriestId; // priestId

  const MassRequestPayload({
    required this.massType,
    required this.scheduledAt,
    required this.location,
    required this.intention,
    this.forPriestId,
  });

  /// Real API body: { priestId, purpose, estimatedTime, note }
  Map<String, dynamic> toJson() => {
        if (forPriestId != null && forPriestId!.isNotEmpty)
          'priestId': forPriestId,
        'purpose': massType,
        'estimatedTime': scheduledAt,
        'note': intention,
      };
}

class MassRequest {
  final String id;
  final String massType;
  final String scheduledAt;
  final String? location;
  final String? intention;
  final String status; // pending | approved | rejected
  final String createdAt;
  final String? requesterName;

  const MassRequest({
    required this.id,
    required this.massType,
    required this.scheduledAt,
    this.location,
    this.intention,
    required this.status,
    required this.createdAt,
    this.requesterName,
  });

  /// Real API format (MassHistoryData):
  /// { id, created, status: "PENDING"/"APPROVED"/"REJECTED",
  ///   metadata: { Purpose, EstimatedTime, Note }, ... }
  factory MassRequest.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>?;
    final rawStatus = (json['status'] as String? ?? 'pending').toLowerCase();
    final status = rawStatus == 'approved'
        ? 'approved'
        : rawStatus == 'rejected'
            ? 'rejected'
            : 'pending';

    return MassRequest(
      id: json['id'] as String? ?? '',
      massType: metadata?['Purpose'] as String? ??
          metadata?['purpose'] as String? ??
          json['massType'] as String? ?? '',
      scheduledAt: metadata?['EstimatedTime'] as String? ??
          metadata?['estimatedTime'] as String? ??
          json['scheduledAt'] as String? ?? '',
      location: json['location'] as String?,
      intention: metadata?['Note'] as String? ??
          metadata?['note'] as String? ??
          json['intention'] as String?,
      status: status,
      createdAt: json['created'] as String? ?? json['createdAt'] as String? ?? '',
      requesterName: json['requesterName'] as String?,
    );
  }
}

// ── History Item ──────────────────────────────────────────────────────────────

class HistoryRecord {
  final String id;   // UUID string từ server
  final String type; // "mass" | "update"
  final String title;
  final String status; // "completed" | "processing" | "rejected"
  final String date;
  final String? refId;

  const HistoryRecord({
    required this.id,
    required this.type,
    required this.title,
    required this.status,
    required this.date,
    this.refId,
  });

  /// Real API format (MassHistoryData từ /forms/mass_request/requester):
  /// { id (UUID), created, status: "PENDING"/"APPROVED"/"REJECTED",
  ///   metadata: { Purpose, EstimatedTime, Note }, saints, firstName, ... }
  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>?;
    final rawStatus = (json['status'] as String? ?? '').toUpperCase();
    final status = rawStatus == 'APPROVED'
        ? 'completed'
        : rawStatus == 'REJECTED'
            ? 'rejected'
            : 'processing';

    // Lấy tiêu đề từ metadata.Purpose hoặc metadata.purpose
    final purpose = metadata?['Purpose'] as String? ??
        metadata?['purpose'] as String? ??
        json['title'] as String?;

    return HistoryRecord(
      id: json['id'] as String? ?? '',
      type: json['type'] as String? ?? 'mass',
      title: purpose?.isNotEmpty == true ? purpose! : 'Yêu cầu dâng lễ',
      status: status,
      date: _fmtDate(json['created'] as String? ?? json['date'] as String?),
      refId: json['id'] as String? ?? json['refId'] as String?,
    );
  }
}

// ── Notification ──────────────────────────────────────────────────────────────

class AppNotification {
  final String id;   // UUID string
  final String title;
  final String content;
  final String time;
  final bool isRead;
  final String type; // "MASS_REQUEST" | "SYSTEM" | ...

  const AppNotification({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
    required this.type,
  });

  /// Real API format (NotificationData):
  /// { id (UUID), type, status: "READ"/"UNREAD", created,
  ///   relatedEntityId, metadata: { title, body } }
  factory AppNotification.fromJson(Map<String, dynamic> json) {
    final metadata = json['metadata'] as Map<String, dynamic>?;
    final status = (json['status'] as String? ?? '').toUpperCase();

    return AppNotification(
      id: json['id']?.toString() ?? '',
      title: metadata?['title'] as String? ?? json['title'] as String? ?? '',
      content: metadata?['body'] as String? ?? json['content'] as String? ?? '',
      time: _relativeTime(json['created'] as String? ?? json['time'] as String?),
      isRead: status == 'READ',
      type: json['type'] as String? ?? 'system',
    );
  }
}

// ── Church / Facility (Emergency Anointing) ───────────────────────────────────

class Church {
  final String name;
  final String address;
  final String priestName;
  final String phone;
  final double lat;
  final double lng;
  final double? distanceKm;

  const Church({
    required this.name,
    required this.address,
    required this.priestName,
    required this.phone,
    this.lat = 0.0,
    this.lng = 0.0,
    this.distanceKm,
  });

  /// Real API format (ParishData từ /facility/nearest):
  /// { id, name, photo, distance,
  ///   priestInformation: [{ id, name, photo, phone, position }] }
  factory Church.fromJson(Map<String, dynamic> json) {
    final priests = json['priestInformation'] as List<dynamic>?;
    Map<String, dynamic>? firstPriest;
    if (priests != null && priests.isNotEmpty) {
      firstPriest = priests.first as Map<String, dynamic>?;
    }

    return Church(
      name: json['name'] as String? ?? '',
      address: json['address'] as String? ?? json['name'] as String? ?? '',
      priestName: firstPriest?['name'] as String? ?? '',
      phone: firstPriest?['phone'] as String? ?? '',
      lat: (json['lat'] as num?)?.toDouble() ?? 0.0,
      lng: (json['lng'] as num?)?.toDouble() ?? 0.0,
      distanceKm: (json['distance'] as num?)?.toDouble() ??
          (json['distanceKm'] as num?)?.toDouble(),
    );
  }
}

// ── Priest Search Result (paginated) ─────────────────────────────────────────

class PriestSearchResult {
  final List<UserProfile> data;
  final int total;
  final int page;
  final int limit;

  const PriestSearchResult({
    required this.data,
    required this.total,
    required this.page,
    required this.limit,
  });

  /// Real API paged format:
  /// { results: [...], pageCount: N } wrapped in payload
  factory PriestSearchResult.fromJson(Map<String, dynamic> json) {
    // Try multiple payload shapes
    final rawList = json['results'] as List<dynamic>? ??
        json['data'] as List<dynamic>? ??
        [];
    final priests = rawList
        .map((e) => UserProfile.fromPriestDetail(e as Map<String, dynamic>))
        .toList();

    return PriestSearchResult(
      data: priests,
      total: json['pageCount'] as int? ??
          json['total'] as int? ??
          priests.length,
      page: json['page'] as int? ?? 1,
      limit: json['limit'] as int? ?? 20,
    );
  }
}
