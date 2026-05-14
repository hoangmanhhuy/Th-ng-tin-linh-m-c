import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/models.dart';
import '../core/app_theme.dart';

class LiturgicalViewModel extends ChangeNotifier {
  LiturgicalData getLiturgicalData(DateTime date) {
    const dayNames = [
      "Chúa Nhật",
      "Thứ Hai",
      "Thứ Ba",
      "Thứ Tư",
      "Thứ Năm",
      "Thứ Sáu",
      "Thứ Bảy",
    ];
    final currentDayName = dayNames[date.weekday % 7];
    final formattedDateString =
        "$currentDayName, ${date.day} Tháng ${date.month}";

    if (date.year == 2026 && date.month == 5) {
      String week = "VI";
      if (date.day <= 2) {
        week = "IV";
      } else if (date.day <= 9) {
        week = "V";
      } else if (date.day <= 16) {
        week = "VI";
      } else if (date.day <= 23) {
        week = "VII";
      } else {
        week = "VIII";
      }

      return LiturgicalData(
        dateString: formattedDateString,
        season: "Tuần $week Phục Sinh",
        feast: date.day == 13
            ? "Đức Mẹ Fatima. Lễ Nhớ."
            : date.day == 14
            ? "Thánh Matthias, Tông đồ. Lễ Kính."
            : "Ngày tuần trong Mùa Phục Sinh",
        readings: [
          LiturgicalReading(
            label: "Bài Đọc I",
            text: date.day == 13
                ? "Cv 17, 15.22—18,1"
                : date.day == 14
                ? "Cv 1,15-17.20-26"
                : "Cv Lời Chúa",
            icon: LucideIcons.bookOpen,
            color: AppColors.blue50,
            iconColor: AppColors.primary,
          ),
          LiturgicalReading(
            label: "Đáp Ca",
            text: date.day == 13
                ? "Tv 148, 1-2.11-12.13.14"
                : date.day == 14
                ? "Tv 112,1-2.3-4.5-6.7-8"
                : "Tv Lời Chúa",
            icon: LucideIcons.music,
            color: AppColors.indigo50,
            iconColor: AppColors.indigo600,
          ),
          LiturgicalReading(
            label: "Tin Mừng",
            text: date.day == 13
                ? "Ga 16, 12-15"
                : date.day == 14
                ? "Ga 15,9-17"
                : "Ga Lời Chúa",
            icon: LucideIcons.quote,
            color: Color(0xFFFEF2F2),
            iconColor: AppColors.red,
          ),
        ],
      );
    }

    return LiturgicalData(
      dateString: formattedDateString,
      season: "Mùa Thường Niên",
      feast: "Ngày trong tuần",
      readings: [
        LiturgicalReading(
          label: "Bài Đọc I",
          text: "Lời Chúa hằng ngày",
          icon: LucideIcons.bookOpen,
          color: AppColors.blue50,
          iconColor: AppColors.primary,
        ),
        LiturgicalReading(
          label: "Đáp Ca",
          text: "Thánh vịnh đáp ca",
          icon: LucideIcons.music,
          color: AppColors.indigo50,
          iconColor: AppColors.indigo600,
        ),
        LiturgicalReading(
          label: "Tin Mừng",
          text: "Tin Mừng theo ngày",
          icon: LucideIcons.quote,
          color: Color(0xFFFEF2F2),
          iconColor: AppColors.red,
        ),
      ],
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
