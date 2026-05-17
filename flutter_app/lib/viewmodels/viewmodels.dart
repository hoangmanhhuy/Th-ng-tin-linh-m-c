import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/models.dart';
import '../models/api_models.dart';
import '../core/app_theme.dart';
import '../services/auth_service.dart';
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

// ── AuthViewModel ─────────────────────────────────────────────────────────────

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService;

  UserRole _role = UserRole.public;
  UserProfile? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._authService);

  UserRole get role => _role;
  UserProfile? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Khôi phục session khi app khởi động
  Future<void> init() async {
    if (await _authService.hasValidToken()) {
      final user = await _authService.getStoredUser();
      if (user != null) {
        _currentUser = user;
        _role = UserRole.priest;
        notifyListeners();

        // Thử refresh profile từ server trong background
        _refreshProfileInBackground();
      }
    }
  }

  void _refreshProfileInBackground() async {
    try {
      final fresh = await _authService.fetchProfile();
      if (fresh != null && _role == UserRole.priest) {
        _currentUser = fresh;
        notifyListeners();
      }
    } catch (_) {
      // Không nghiêm trọng — giữ nguyên cached profile
    }
  }

  /// Đăng nhập với email/phone và mật khẩu
  Future<void> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _authService.login(email.trim(), password);
      _currentUser = result.priest;
      _role = UserRole.priest;
    } on ApiError catch (e) {
      _errorMessage = e.message;
    } catch (e) {
      _errorMessage = 'Đăng nhập thất bại. Vui lòng thử lại.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Đăng xuất
  Future<void> logout() async {
    await _authService.logout();
    _role = UserRole.public;
    _currentUser = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Đổi mật khẩu — throws ApiError nếu thất bại
  Future<void> changePassword(String current, String newPass) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _authService.changePassword(current, newPass);
    } on ApiError catch (e) {
      _errorMessage = e.message;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
