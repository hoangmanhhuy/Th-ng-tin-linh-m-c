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
    'SL-HUE-21031970': UserProfile(
      id: 'SL-HUE-21031970',
      holyName: 'Phêrô',
      fullName: 'Lê Thanh Bình',
      diocese: 'Tổng Giáo phận Huế',
      parish: 'Giáo xứ Phủ Cam',
      role: 'Quản xứ',
      birthDate: '21/03/1970',
      ordinationDate: '15/08/1998',
      degree: 'Tiến sĩ Thần học',
      email: 'lethanhbinh@hue.catholic.org',
      phone: '092 345 6789',
    ),
    'SL-DNA-08091978': UserProfile(
      id: 'SL-DNA-08091978',
      holyName: 'Tôma',
      fullName: 'Võ Đình Khoa',
      diocese: 'Giáo phận Đà Nẵng',
      parish: 'Giáo xứ Chính Tòa Đà Nẵng',
      role: 'Quản xứ',
      birthDate: '08/09/1978',
      ordinationDate: '29/06/2005',
      degree: 'Thạc sĩ Mục vụ',
      email: 'vodikhoa@danang.catholic.org',
      phone: '093 456 7890',
    ),
    'SL-BUC-14021972': UserProfile(
      id: 'SL-BUC-14021972',
      holyName: 'Đaminh',
      fullName: 'Phạm Quang Trung',
      diocese: 'Giáo phận Bùi Chu',
      parish: 'Giáo xứ Bùi Chu',
      role: 'Giám đốc Đại chủng viện',
      birthDate: '14/02/1972',
      ordinationDate: '01/11/2000',
      degree: 'Tiến sĩ Triết học',
      email: 'phamquangtrung@buichu.catholic.org',
      phone: '094 567 8901',
    ),
    'SL-VIN-03051968': UserProfile(
      id: 'SL-VIN-03051968',
      holyName: 'Antôn',
      fullName: 'Nguyễn Văn Phúc',
      diocese: 'Giáo phận Vinh',
      parish: 'Giáo xứ Xã Đoài',
      role: 'Hạt trưởng',
      birthDate: '03/05/1968',
      ordinationDate: '06/01/1996',
      degree: 'Thạc sĩ Thần học',
      email: 'nguyenvanphuc@vinh.catholic.org',
      phone: '095 678 9012',
    ),
    'SL-DAL-17071983': UserProfile(
      id: 'SL-DAL-17071983',
      holyName: 'Gioan',
      fullName: 'Trần Quốc Dũng',
      diocese: 'Giáo phận Đà Lạt',
      parish: 'Giáo xứ Chính Tòa Đà Lạt',
      role: 'Phó quản xứ',
      birthDate: '17/07/1983',
      ordinationDate: '08/12/2010',
      degree: 'Cử nhân Thần học',
      email: 'tranquocdung@dalat.catholic.org',
      phone: '096 789 0123',
    ),
    'SL-XUL-25121977': UserProfile(
      id: 'SL-XUL-25121977',
      holyName: 'Luca',
      fullName: 'Bùi Văn Thắng',
      diocese: 'Giáo phận Xuân Lộc',
      parish: 'Giáo xứ Long Khánh',
      role: 'Quản xứ',
      birthDate: '25/12/1977',
      ordinationDate: '25/12/2004',
      degree: 'Thạc sĩ Giáo luật',
      email: 'buivanthang@xuanloc.catholic.org',
      phone: '097 890 1234',
    ),
    'SL-CTH-10101980': UserProfile(
      id: 'SL-CTH-10101980',
      holyName: 'Matthêu',
      fullName: 'Lý Minh Hùng',
      diocese: 'Giáo phận Cần Thơ',
      parish: 'Giáo xứ Cần Thơ',
      role: 'Quản xứ',
      birthDate: '10/10/1980',
      ordinationDate: '29/06/2007',
      degree: 'Cử nhân Thần học',
      email: 'lyminhhung@cantho.catholic.org',
      phone: '098 901 2345',
    ),
    'SL-HAP-05031974': UserProfile(
      id: 'SL-HAP-05031974',
      holyName: 'Barnaba',
      fullName: 'Đỗ Hữu Thành',
      diocese: 'Giáo phận Hải Phòng',
      parish: 'Giáo xứ Hải Phòng',
      role: 'Hạt trưởng',
      birthDate: '05/03/1974',
      ordinationDate: '15/08/2001',
      degree: 'Thạc sĩ Mục vụ',
      email: 'dohuuthanh@haiphong.catholic.org',
      phone: '099 012 3456',
    ),
    'SL-LXU-28061982': UserProfile(
      id: 'SL-LXU-28061982',
      holyName: 'Phêrô',
      fullName: 'Châu Minh Đức',
      diocese: 'Giáo phận Long Xuyên',
      parish: 'Giáo xứ Long Xuyên',
      role: 'Phó quản xứ',
      birthDate: '28/06/1982',
      ordinationDate: '29/06/2009',
      degree: 'Cử nhân Thần học',
      email: 'chauminduc@longxuyen.catholic.org',
      phone: '090 123 5678',
    ),
    'SL-PC-18091979': UserProfile(
      id: 'SL-PC-18091979',
      holyName: 'Micae',
      fullName: 'Nguyễn Thanh Hải',
      diocese: 'Giáo phận Phú Cường',
      parish: 'Giáo xứ Thủ Dầu Một',
      role: 'Quản xứ',
      birthDate: '18/09/1979',
      ordinationDate: '08/12/2006',
      degree: 'Thạc sĩ Thần học',
      email: 'nguyenthanhhai@phucuong.catholic.org',
      phone: '091 987 6543',
    ),
    'SL-HN-22111971': UserProfile(
      id: 'SL-HN-22111971',
      holyName: 'Phanxicô',
      fullName: 'Vũ Đức Toàn',
      diocese: 'Tổng Giáo phận Hà Nội',
      parish: 'Nhà thờ Lớn Hà Nội',
      role: 'Phó quản xứ',
      birthDate: '22/11/1971',
      ordinationDate: '01/05/1999',
      degree: 'Thạc sĩ Kinh Thánh',
      email: 'vuductoan@hanoi.catholic.org',
      phone: '092 876 5432',
    ),
  };

  static List<UserProfile> search({String query = '', String diocese = ''}) {
    final q = query.toLowerCase().trim();
    final d = diocese.toLowerCase().trim();
    return _db.values.where((p) {
      final nameMatch = q.isEmpty ||
          p.fullName.toLowerCase().contains(q) ||
          p.holyName.toLowerCase().contains(q);
      final dioceseMatch = d.isEmpty || d == 'chọn giáo phận' ||
          p.diocese.toLowerCase().contains(d);
      return nameMatch && dioceseMatch;
    }).toList()
      ..sort((a, b) => a.fullName.compareTo(b.fullName));
  }

  static List<String> get allDioceses {
    final list = _db.values.map((p) => p.diocese).toSet().toList();
    list.sort();
    return list;
  }

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
