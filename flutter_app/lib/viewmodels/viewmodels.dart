import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/models.dart';
import '../core/app_theme.dart';
import '../services/liturgical_service.dart';

class LiturgicalViewModel extends ChangeNotifier {
  final LiturgicalService _service = LiturgicalService();

  LiturgicalData? _cached;
  DateTime? _cachedDate;

  bool get isLoaded => _service.isLoaded;

  /// Returns cached data if available (for synchronous access after preloading).
  LiturgicalData? get cachedData => _cached;

  Future<LiturgicalData> getLiturgicalData(DateTime date) async {
    final day = DateTime(date.year, date.month, date.day);
    if (_cached != null && _cachedDate != null &&
        _cachedDate!.year == day.year &&
        _cachedDate!.month == day.month &&
        _cachedDate!.day == day.day) {
      return _cached!;
    }

    final info = await _service.getInfo(date);
    final result = _buildLiturgicalData(info);
    _cached = result;
    _cachedDate = day;
    return result;
  }

  LiturgicalData _buildLiturgicalData(LiturgicalInfo info) {
    final readings = <LiturgicalReading>[];

    if (info.bd1.isNotEmpty) {
      readings.add(LiturgicalReading(
        label: 'Bài Đọc I',
        text: info.bd1,
        icon: LucideIcons.bookOpen,
        color: AppColors.blue50,
        iconColor: AppColors.primary,
      ));
    }

    if (info.bd2.isNotEmpty) {
      readings.add(LiturgicalReading(
        label: 'Bài Đọc II',
        text: info.bd2,
        icon: LucideIcons.bookOpen,
        color: AppColors.indigo50,
        iconColor: AppColors.indigo600,
      ));
    } else {
      // Đáp Ca placeholder (bd2 field used for responsorial psalm in display)
      // For weekdays bd2 is empty but we still show a slot for Đáp Ca
      // The actual Đáp Ca reference is embedded in bd1 for some entries
      // Show it only if bd1 is present to avoid empty state
      if (info.bd1.isNotEmpty) {
        readings.add(const LiturgicalReading(
          label: 'Đáp Ca',
          text: 'Thánh vịnh',
          icon: LucideIcons.music,
          color: AppColors.indigo50,
          iconColor: AppColors.indigo600,
        ));
      }
    }

    if (info.tinMung.isNotEmpty) {
      readings.add(LiturgicalReading(
        label: 'Tin Mừng',
        text: info.tinMung,
        icon: LucideIcons.quote,
        color: const Color(0xFFFEF2F2),
        iconColor: AppColors.red,
      ));
    }

    return LiturgicalData(
      dateString: info.dateString,
      season: info.season,
      feast: info.feast,
      readings: readings,
    );
  }
}

class AuthViewModel extends ChangeNotifier {
  UserRole _role = UserRole.public;
  UserProfile? _currentUser;

  UserRole get role => _role;
  UserProfile? get currentUser => _currentUser;

  void login() {
    _role = UserRole.priest;
    _currentUser = const UserProfile(
      id: "SL-PC-12051980",
      holyName: "Phaolô",
      fullName: "Hoàng Mạnh Huy",
      diocese: "Giáo phận Phú Cường",
      parish: "Giáo xứ Phú Cường",
      role: "Trưởng ban Truyền thông",
      birthDate: "12/05/1980",
      ordinationDate: "20/06/2008",
      degree: "Thạc sĩ Mục vụ",
      email: "hoangmanhhuy@gmail.com",
      phone: "090 123 4567",
    );
    notifyListeners();
  }

  void logout() {
    _role = UserRole.public;
    _currentUser = null;
    notifyListeners();
  }
}
