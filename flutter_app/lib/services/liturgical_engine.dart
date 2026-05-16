/// Liturgical Calendar Engine — Dart port of the Python FastAPI
/// Computes moveable feasts, seasons, and reading IDs for Catholic
/// liturgical calendar (Vietnamese norms / Giáo phận Phú Cường).
library liturgical_engine;

// ── Easter: Meeus/Jones/Butcher algorithm ─────────────────────────

/// Computes Easter Sunday for [year] (Gregorian calendar).
DateTime calcEaster(int year) {
  final a = year % 19;
  final b = year ~/ 100;
  final c = year % 100;
  final d = b ~/ 4;
  final e = b % 4;
  final f = (b + 8) ~/ 25;
  final g = (b - f + 1) ~/ 3;
  final h = (19 * a + b - d - g + 15) % 30;
  final i = c ~/ 4;
  final k = c % 4;
  final l = (32 + 2 * e + 2 * i - h - k) % 7;
  final m = (a + 11 * h + 22 * l) ~/ 451;
  final month = (h + l - 7 * m + 114) ~/ 31;
  final day = ((h + l - 7 * m + 114) % 31) + 1;
  return DateTime(year, month, day);
}

// ── Moveable feasts ───────────────────────────────────────────────

/// CN đầu tiên trong khoảng Jan 2–8 (Hiển Linh VN).
DateTime leHienLinhVN(int year) {
  DateTime d = DateTime(year, 1, 2);
  while (d.weekday != DateTime.sunday) {
    d = d.add(const Duration(days: 1));
  }
  return d;
}

/// Thứ Hai ngay sau Hiển Linh VN (Lễ Chúa Giêsu Chịu Phép Rửa VN).
DateTime leCPRvn(int year) => leHienLinhVN(year).add(const Duration(days: 1));

/// Ngày CN đầu tiên >= 27/11 (CN I Mùa Vọng).
DateTime _cnIMuaVong(int year) {
  DateTime d = DateTime(year, 11, 27);
  // weekday: Mon=1..Sun=7
  final daysToSun = (DateTime.sunday - d.weekday + 7) % 7;
  return d.add(Duration(days: daysToSun));
}

/// Lễ Thánh Gia Thất: nếu Giáng Sinh là CN → 28/12, ngược lại CN đầu sau 25/12.
DateTime leTGT(int year) {
  final gs = DateTime(year, 12, 25);
  if (gs.weekday == DateTime.sunday) return DateTime(year, 12, 30);
  DateTime d = gs.add(const Duration(days: 1));
  while (d.weekday != DateTime.sunday) {
    d = d.add(const Duration(days: 1));
  }
  return d;
}

/// Trả về map các lễ di động của [year].
/// Keys: thuTuLeTro, cnLeLa, thu5TuanThanh, thu6TuanThanh, thu7TuanThanh,
///       phucSinh, leTrangThien, leHienXuong, leBaNgoi, leMinhMau, cnIMuaVong.
Map<String, DateTime> calcMovableFeasts(int year) {
  final ps = calcEaster(year);
  final thuTuLeTro = ps.subtract(const Duration(days: 46));
  final cnLeLa = ps.subtract(const Duration(days: 7));
  final thu5TuanThanh = ps.subtract(const Duration(days: 3));
  final thu6TuanThanh = ps.subtract(const Duration(days: 2));
  final thu7TuanThanh = ps.subtract(const Duration(days: 1));
  final leTrangThien = ps.add(const Duration(days: 39));
  final leHienXuong = ps.add(const Duration(days: 49));
  final leBaNgoi = ps.add(const Duration(days: 56));
  final leMinhMau = ps.add(const Duration(days: 63));
  final cnIMuaVong = _cnIMuaVong(year);

  return {
    'thuTuLeTro': thuTuLeTro,
    'cnLeLa': cnLeLa,
    'thu5TuanThanh': thu5TuanThanh,
    'thu6TuanThanh': thu6TuanThanh,
    'thu7TuanThanh': thu7TuanThanh,
    'phucSinh': ps,
    'leTrangThien': leTrangThien,
    'leHienXuong': leHienXuong,
    'leBaNgoi': leBaNgoi,
    'leMinhMau': leMinhMau,
    'cnIMuaVong': cnIMuaVong,
  };
}

// Cache keyed by year
final Map<int, Map<String, DateTime>> _ddCache = {};

/// Cached moveable feasts for [year].
Map<String, DateTime> getDD(int year) {
  return _ddCache.putIfAbsent(year, () => calcMovableFeasts(year));
}

// ── Helper ────────────────────────────────────────────────────────

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Days between two dates (b - a), rounding to calendar days.
int daysBetween(DateTime a, DateTime b) {
  final aDate = DateTime(a.year, a.month, a.day);
  final bDate = DateTime(b.year, b.month, b.day);
  return bDate.difference(aDate).inDays;
}

// ── Liturgical year ───────────────────────────────────────────────

/// NamPV = năm kết thúc năm phụng vụ. E.g. for 2025-2026 → 2026.
int namPhungVu(DateTime date) {
  final y = date.year;
  final dd = getDD(y);
  return isSameDay(date, dd['cnIMuaVong']!) || date.isAfter(dd['cnIMuaVong']!)
      ? y + 1
      : y;
}

/// Sunday cycle for [namPV]: A if namPV%3==1, B if ==2, C if ==0.
String namABC(int namPV) {
  final r = namPV % 3;
  if (r == 1) return 'A';
  if (r == 2) return 'B';
  return 'C';
}

// ── Liturgical season ─────────────────────────────────────────────

/// Returns one of: "Mùa Vọng", "Mùa Giáng Sinh", "Mùa Thường Niên",
/// "Mùa Chay", "Mùa Phục Sinh".
String xacDinhMua(DateTime ngay) {
  final y = ngay.year;
  final dd = getDD(y);
  final ps = dd['phucSinh']!;
  final ttlt = dd['thuTuLeTro']!;
  final hx = dd['leHienXuong']!;
  final cnVong = dd['cnIMuaVong']!;
  final gs = DateTime(y, 12, 25);
  final cprVN = leCPRvn(y);

  if (!ngay.isBefore(gs)) return 'Mùa Giáng Sinh';
  if (!ngay.isBefore(cnVong)) return 'Mùa Vọng';
  if (ngay.isAfter(hx)) return 'Mùa Thường Niên';
  if (!ngay.isBefore(ps)) return 'Mùa Phục Sinh';
  if (!ngay.isBefore(ttlt)) return 'Mùa Chay';
  // Đầu năm
  if (ngay.isAfter(cprVN)) return 'Mùa Thường Niên';
  final gsTruoc = DateTime(y - 1, 12, 25);
  if (!ngay.isBefore(gsTruoc)) return 'Mùa Giáng Sinh';
  return 'Mùa Thường Niên';
}

// ── Count TN Sundays before Lent ─────────────────────────────────

/// Đếm số CN Thường Niên trước Mùa Chay của [year].
int cnTNTruocChay(int year) {
  final dd = getDD(year);
  final cprt = leCPRvn(year);
  DateTime cnII = cprt.add(const Duration(days: 1));
  while (cnII.weekday != DateTime.sunday) {
    cnII = cnII.add(const Duration(days: 1));
  }
  int n = 0;
  DateTime cn = cnII;
  while (cn.isBefore(dd['thuTuLeTro']!)) {
    n++;
    cn = cn.add(const Duration(days: 7));
  }
  return n;
}

const int _anchorYear = 2016;
int? _nAnchor;

int get nAnchor {
  _nAnchor ??= cnTNTruocChay(_anchorYear);
  return _nAnchor!;
}

// ── id_mua ────────────────────────────────────────────────────────

/// In Python: Mon=0..Sun=6 → CN=0, Mon=1..Sat=6.
/// In Dart: Mon=1..Sun=7 → w = (weekday == 7) ? 0 : weekday.
int _w(DateTime ngay) => ngay.weekday == DateTime.sunday ? 0 : ngay.weekday;

/// Computes the id_mua directly from the liturgical position.
/// Returns 0 if falling on special feasts (Ba Ngôi / Mình Máu etc.)
/// or dates in the Christmas season handled by lich_map fallback.
int tinhIdMua(DateTime ngay) {
  final y = ngay.year;
  final dd = getDD(y);
  final ps = dd['phucSinh']!;
  final ttlt = dd['thuTuLeTro']!;
  final hx = dd['leHienXuong']!;
  final cnMV = dd['cnIMuaVong']!;
  final mm = dd['leMinhMau']!;
  final hienLinh = leHienLinhVN(y);
  final cpr = leCPRvn(y);
  final w = _w(ngay);

  // Mùa Giáng Sinh: Dec 25-31
  if (ngay.month == 12 && ngay.day >= 25) {
    return 29 + (ngay.day - 25);
  }

  // Jan 1
  if (ngay.month == 1 && ngay.day == 1) return 36;

  // Jan 2 → day before Hiển Linh VN
  if (ngay.month == 1 &&
      !DateTime(y, 1, 2).isAfter(ngay) &&
      ngay.isBefore(hienLinh)) {
    return 39 + ngay.weekday - 1; // Dart Mon=1→+0 offset makes it Mon=39..Sat=44
    // Actually: Python Mon=0→39, so w_py = weekday (Mon=0..Sat=5)
    // Dart: Mon=1..Sat=6, so 39 + (ngay.weekday - 1)
  }

  if (isSameDay(ngay, hienLinh)) return 45;
  if (isSameDay(ngay, cpr)) return 53;

  // Mùa Vọng
  if (!ngay.isBefore(cnMV) && ngay.isBefore(DateTime(y, 12, 25))) {
    final tuan = (daysBetween(cnMV, ngay) ~/ 7 + 1).clamp(1, 4);
    return 1 + (tuan - 1) * 7 + w;
  }

  // Mùa Chay
  if (!ngay.isBefore(ttlt) && ngay.isBefore(ps)) {
    if (isSameDay(ngay, ttlt)) return 291;
    DateTime cnIMC = ttlt.add(const Duration(days: 1));
    while (cnIMC.weekday != DateTime.sunday) {
      cnIMC = cnIMC.add(const Duration(days: 1));
    }
    if (ngay.isBefore(cnIMC)) {
      return 291 + daysBetween(ttlt, ngay);
    }
    final tuan = daysBetween(cnIMC, ngay) ~/ 7 + 1;
    return 295 + (tuan - 1) * 7 + w;
  }

  // Mùa Phục Sinh
  if (!ngay.isBefore(ps) && !ngay.isAfter(hx)) {
    return 337 + daysBetween(ps, ngay);
  }

  // Mùa Thường Niên
  final cprtVN = leCPRvn(y);
  DateTime cnIITN = cprtVN.add(const Duration(days: 1));
  while (cnIITN.weekday != DateTime.sunday) {
    cnIITN = cnIITN.add(const Duration(days: 1));
  }

  // TN trước Mùa Chay
  if (!ngay.isBefore(cnIITN) && ngay.isBefore(ttlt)) {
    final tuan = daysBetween(cnIITN, ngay) ~/ 7 + 2;
    return 60 + (tuan - 2) * 7 + w;
  }

  // Ngày thường TN giữa CPR và CN II TN
  if (ngay.isAfter(cprtVN) && ngay.isBefore(cnIITN)) {
    final daysToCN = daysBetween(ngay, cnIITN);
    return 60 - daysToCN;
  }

  // TN sau Hiện Xuống
  if (ngay.isAfter(hx)) {
    final cnTNSauMM = mm.add(const Duration(days: 7));
    if (ngay.isBefore(cnTNSauMM)) return 0; // Ba Ngôi / Mình Máu / Thánh Tâm
    final offset = cnTNTruocChay(y) - nAnchor;
    final tuanDau = 10 + offset;
    final tuan = tuanDau + daysBetween(cnTNSauMM, ngay) ~/ 7;
    return 60 + (tuan - 2) * 7 + w;
  }

  return 0; // Fallback (Mùa Giáng Sinh)
}

// ── Roman numeral helpers ─────────────────────────────────────────

const _tenTuanTN = [
  'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
  'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX',
  'XXI', 'XXII', 'XXIII', 'XXIV', 'XXV', 'XXVI', 'XXVII', 'XXVIII',
  'XXIX', 'XXX', 'XXXI', 'XXXII', 'XXXIII', 'XXXIV',
];

const _thuTen = [
  'Thứ Hai', // Mon=1
  'Thứ Ba',
  'Thứ Tư',
  'Thứ Năm',
  'Thứ Sáu',
  'Thứ Bảy',
  'Chúa Nhật', // Sun=7
];

String thuName(DateTime ngay) => _thuTen[ngay.weekday - 1];

/// Returns week position text like "Tuần VI Phục Sinh"
/// for use as the season badge.
String tinhTenTuan(DateTime ngay) {
  final y = ngay.year;
  final dd = getDD(y);
  final ps = dd['phucSinh']!;
  final ttlt = dd['thuTuLeTro']!;
  final hx = dd['leHienXuong']!;
  final cnMV = dd['cnIMuaVong']!;

  // Mùa Vọng
  if (!ngay.isBefore(cnMV) && ngay.isBefore(DateTime(y, 12, 25))) {
    final tuan = (daysBetween(cnMV, ngay) ~/ 7 + 1).clamp(1, 4);
    return 'Tuần ${_tenTuanTN[tuan - 1]} Mùa Vọng';
  }

  // Mùa Giáng Sinh
  final mua = xacDinhMua(ngay);
  if (mua == 'Mùa Giáng Sinh') return 'Mùa Giáng Sinh';

  // Mùa Chay
  if (!ngay.isBefore(ttlt) && ngay.isBefore(ps)) {
    if (isSameDay(ngay, ttlt)) return 'Thứ Tư Lễ Tro';
    DateTime cnIMC = ttlt.add(const Duration(days: 1));
    while (cnIMC.weekday != DateTime.sunday) {
      cnIMC = cnIMC.add(const Duration(days: 1));
    }
    final tuan = (daysBetween(cnIMC, ngay) ~/ 7 + 1).clamp(1, 5);
    return 'Tuần ${_tenTuanTN[tuan - 1]} Mùa Chay';
  }

  // Mùa Phục Sinh
  if (!ngay.isBefore(ps) && !ngay.isAfter(hx)) {
    final tuanPS = daysBetween(ps, ngay) ~/ 7 + 1;
    return 'Tuần ${_tenTuanTN[(tuanPS - 1).clamp(0, 7)]} Phục Sinh';
  }

  // Mùa Thường Niên — sau HX
  if (ngay.isAfter(hx)) {
    final mm = dd['leMinhMau']!;
    final cnTNSauMM = mm.add(const Duration(days: 7));
    if (ngay.isBefore(cnTNSauMM)) {
      // Ba Ngôi / Mình Máu / Thánh Tâm period
      return 'Mùa Thường Niên';
    }
    final offset = cnTNTruocChay(y) - nAnchor;
    final tuanDau = 10 + offset;
    final tuan = tuanDau + daysBetween(cnTNSauMM, ngay) ~/ 7;
    return 'Tuần ${_tenTuanTN[(tuan - 1).clamp(0, 33)]} Thường Niên';
  }

  // TN trước Chay (đầu năm)
  final cprtVN = leCPRvn(y);
  DateTime cnIITN = cprtVN.add(const Duration(days: 1));
  while (cnIITN.weekday != DateTime.sunday) {
    cnIITN = cnIITN.add(const Duration(days: 1));
  }
  if (!ngay.isBefore(cnIITN) && ngay.isBefore(ttlt)) {
    final tuan = daysBetween(cnIITN, ngay) ~/ 7 + 2;
    return 'Tuần ${_tenTuanTN[(tuan - 1).clamp(0, 33)]} Thường Niên';
  }

  return 'Mùa Thường Niên';
}
