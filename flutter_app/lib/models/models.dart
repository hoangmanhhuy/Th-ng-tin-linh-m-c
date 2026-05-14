import 'dart:convert';
import 'package:flutter/material.dart';

class LiturgicalReading {
  final String label;
  final String text;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const LiturgicalReading({
    required this.label,
    required this.text,
    required this.icon,
    required this.color,
    required this.iconColor,
  });
}

class LiturgicalData {
  final String dateString;
  final String season;
  final String feast;
  final List<LiturgicalReading> readings;

  const LiturgicalData({
    required this.dateString,
    required this.season,
    required this.feast,
    required this.readings,
  });
}

enum UserRole { public, priest }

class UserProfile {
  final String id;
  final String holyName;
  final String fullName;
  final String diocese;
  final String? parish;
  final String? role;
  final String? birthDate;
  final String? ordinationDate;
  final String? degree;
  final String? email;
  final String? phone;

  const UserProfile({
    required this.id,
    required this.holyName,
    required this.fullName,
    required this.diocese,
    this.parish,
    this.role,
    this.birthDate,
    this.ordinationDate,
    this.degree,
    this.email,
    this.phone,
  });
}

class HistoryItem {
  final int id;
  final String type;
  final String title;
  final String status;
  final String date;
  final IconData icon;
  final Color borderColor;
  final Color statusTextColor;
  final Color statusBgColor;

  const HistoryItem({
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

// Format QR/NFC: "PRIEST:ID" hoặc JSON {"id":"...","holyName":"...",...}
class PriestDatabase {
  static const _db = {
    'SL-PC-12051980': UserProfile(
      id: 'SL-PC-12051980',
      holyName: 'Phaolô',
      fullName: 'Hoàng Mạnh Huy',
      diocese: 'Giáo phận Phú Cường',
      parish: 'Giáo xứ Phú Cường',
      role: 'Trưởng ban Truyền thông',
      birthDate: '12/05/1980',
      ordinationDate: '20/06/2008',
      degree: 'Thạc sĩ Mục vụ',
      email: 'hoangmanhhuy@gmail.com',
      phone: '090 123 4567',
    ),
    'SL-HN-15061975': UserProfile(
      id: 'SL-HN-15061975',
      holyName: 'Giuse',
      fullName: 'Trần Văn Huy',
      diocese: 'Tổng Giáo phận Hà Nội',
      parish: 'Giáo xứ Hàm Long',
      role: 'Quản xứ',
      birthDate: '15/06/1975',
      ordinationDate: '29/06/2003',
      degree: 'Thạc sĩ Mục vụ Giáo hội',
      email: 'tranvanhuy@hanoi.catholic.org',
      phone: '098 765 4321',
    ),
    'SL-SG-03081985': UserProfile(
      id: 'SL-SG-03081985',
      holyName: 'Anrê',
      fullName: 'Nguyễn Minh Tuấn',
      diocese: 'Tổng Giáo phận Sài Gòn',
      parish: 'Giáo xứ Tân Định',
      role: 'Phó quản xứ',
      birthDate: '03/08/1985',
      ordinationDate: '15/08/2012',
      degree: 'Cử nhân Thần học',
      email: 'nguyenminhtuan@saigon.catholic.org',
      phone: '091 234 5678',
    ),
  };

  static UserProfile? lookup(String raw) {
    final s = raw.trim();
    if (s.startsWith('PRIEST:')) {
      return _db[s.substring(7).trim()];
    }
    if (s.startsWith('{')) {
      try {
        final map = jsonDecode(s) as Map<String, dynamic>;
        final id = map['id'] as String?;
        if (id != null && _db.containsKey(id)) return _db[id];
        return UserProfile(
          id: map['id'] ?? '',
          holyName: map['holyName'] ?? '',
          fullName: map['fullName'] ?? '',
          diocese: map['diocese'] ?? '',
          parish: map['parish'],
          role: map['role'],
          birthDate: map['birthDate'],
          ordinationDate: map['ordinationDate'],
          degree: map['degree'],
          email: map['email'],
          phone: map['phone'],
        );
      } catch (_) {}
    }
    return _db[s];
  }
}

class NotificationItem {
  final int id;
  final String title;
  final String content;
  final String time;
  final bool isRead;
  final String type;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.isRead,
    required this.type,
  });
}
