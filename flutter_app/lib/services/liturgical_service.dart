import 'dart:convert';
import 'package:flutter/services.dart';
import 'liturgical_engine.dart';

// ── Data model ────────────────────────────────────────────────────

class LiturgicalInfo {
  final String dateString; // "Thứ Tư, 15 Tháng 5"
  final String season;    // "Tuần VI Phục Sinh"
  final String feast;     // feast or day description
  final String mauLe;     // "Tr", "Đ", "X", "Tm"
  final String bd1;       // reading 1 reference
  final String bd2;       // reading 2 reference (may be empty)
  final String tinMung;   // gospel reference
  final String ghiChu;    // note

  const LiturgicalInfo({
    required this.dateString,
    required this.season,
    required this.feast,
    required this.mauLe,
    required this.bd1,
    required this.bd2,
    required this.tinMung,
    required this.ghiChu,
  });
}

// ── Service ───────────────────────────────────────────────────────

class LiturgicalService {
  // JSON caches
  Map<String, dynamic>? _readings;
  Map<String, dynamic>? _saints;
  Map<String, dynamic>? _cfg;
  Map<String, dynamic>? _lichMap;
  Map<int, Map<String, dynamic>>? _tenLeById;

  bool get isLoaded => _readings != null;

  Future<void> _load() async {
    if (isLoaded) return;
    final readingsStr =
        await rootBundle.loadString('assets/liturgical/readings.json');
    final saintsStr =
        await rootBundle.loadString('assets/liturgical/saints.json');
    final cfgStr =
        await rootBundle.loadString('assets/liturgical/ten_le_config.json');
    final lichMapStr =
        await rootBundle.loadString('assets/liturgical/lich_map.json');
    final tenLeStr =
        await rootBundle.loadString('assets/liturgical/ten_le.json');

    _readings = jsonDecode(readingsStr) as Map<String, dynamic>;
    _saints = jsonDecode(saintsStr) as Map<String, dynamic>;
    _cfg = jsonDecode(cfgStr) as Map<String, dynamic>;
    _lichMap = jsonDecode(lichMapStr) as Map<String, dynamic>;

    final tenLeList = jsonDecode(tenLeStr) as List<dynamic>;
    _tenLeById = {
      for (final rec in tenLeList)
        (rec as Map<String, dynamic>)['ID'] as int: rec,
    };
  }

  // ── Main entry point ─────────────────────────────────────────────

  Future<LiturgicalInfo> getInfo(DateTime date) async {
    await _load();
    final ngay = DateTime(date.year, date.month, date.day); // strip time
    return _compute(ngay);
  }

  // ── Internal computation ─────────────────────────────────────────

  LiturgicalInfo _compute(DateTime ngay) {
    final y = ngay.year;
    final dd = getDD(y);
    final ddPrev = getDD(y - 1);

    final mua = xacDinhMua(ngay);
    final npv = namPhungVu(ngay);
    final nam = namABC(npv);
    final laCN = ngay.weekday == DateTime.sunday;

    // Date string
    final dateStr = _formatDate(ngay);

    // Season badge
    final season = _buildSeason(ngay, dd, ddPrev, mua, laCN);

    // ── Determine feast name ────────────────────────────────────────
    String feast = '';
    String mauLe = _defaultColor(mua, ngay, dd);

    // Priority 1: moveable feasts (hard-coded)
    final moveableFeast = _getMoveableFeast(ngay, dd, ddPrev, nam);
    if (moveableFeast != null) {
      feast = moveableFeast;
    }

    // Priority 2: saints.json
    if (feast.isEmpty) {
      final sk = '${ngay.month.toString().padLeft(2, '0')}-'
          '${ngay.day.toString().padLeft(2, '0')}';
      final saintsList = _saints![sk];
      if (saintsList is List && saintsList.isNotEmpty) {
        // Check if bac_le beats current day rank
        final bac = _bacNgayNPVRM(ngay, dd);
        for (final f in saintsList) {
          if (f is! Map) continue;
          final bacThanh = (f['bac_le'] as num?)?.toInt() ?? 99;
          final tenLe = f['ten_le'] as String? ?? '';
          if (bacThanh < bac || (bacThanh == 10 && bac >= 13)) {
            feast = tenLe;
            final mauThanh = f['mau_le'] as String?;
            if (mauThanh != null && mauThanh.isNotEmpty) mauLe = mauThanh;
            break;
          }
        }
      }
    }

    // Priority 3: week position
    if (feast.isEmpty) {
      feast = _weekDayName(ngay, dd, mua, laCN);
    }

    // ── Reading lookup ──────────────────────────────────────────────
    final readings = _getReadings(ngay, dd, nam, mua, laCN);

    return LiturgicalInfo(
      dateString: dateStr,
      season: season,
      feast: feast,
      mauLe: mauLe,
      bd1: readings['bd1'] ?? '',
      bd2: readings['bd2'] ?? '',
      tinMung: readings['tm'] ?? '',
      ghiChu: readings['ghi_chu'] ?? '',
    );
  }

  // ── Date string ──────────────────────────────────────────────────

  String _formatDate(DateTime ngay) {
    const thuNames = [
      'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm',
      'Thứ Sáu', 'Thứ Bảy', 'Chúa Nhật',
    ];
    final thu = thuNames[ngay.weekday - 1];
    return '$thu, ${ngay.day} Tháng ${ngay.month}';
  }

  // ── Season badge ─────────────────────────────────────────────────

  String _buildSeason(
    DateTime ngay,
    Map<String, DateTime> dd,
    Map<String, DateTime> ddPrev,
    String mua,
    bool laCN,
  ) {
    // For special feasts, show their name
    final moveableLabel = _getMoveableSeasonLabel(ngay, dd, ddPrev);
    if (moveableLabel != null) return moveableLabel;

    return tinhTenTuan(ngay);
  }

  String? _getMoveableSeasonLabel(
    DateTime ngay,
    Map<String, DateTime> dd,
    Map<String, DateTime> ddPrev,
  ) {
    final ps = dd['phucSinh']!;
    final leMM = dd['leMinhMau']!;
    final leHX = dd['leHienXuong']!;
    final leBaNgoi = dd['leBaNgoi']!;
    final leTT = dd['leTrangThien']!;
    final cnMV = dd['cnIMuaVong']!;
    final hienLinh = leHienLinhVN(ngay.year);
    final cprVN = leCPRvn(ngay.year);
    final cnVIIPS = leTT.add(const Duration(days: 3));

    if (isSameDay(ngay, ps)) return 'Chúa Nhật Phục Sinh';
    if (isSameDay(ngay, ps.add(const Duration(days: 7)))) {
      return 'CN II Phục Sinh - Lòng Thương Xót';
    }
    if (isSameDay(ngay, cnVIIPS)) return 'Lễ Thăng Thiên';
    if (isSameDay(ngay, leHX)) return 'Lễ Hiện Xuống';
    if (isSameDay(ngay, leBaNgoi)) return 'Lễ Chúa Ba Ngôi';
    if (isSameDay(ngay, leMM)) return 'Lễ Mình Máu Thánh';
    if (isSameDay(ngay, leMM.add(const Duration(days: 5)))) {
      return 'Lễ Thánh Tâm';
    }
    if (isSameDay(ngay, cnMV.subtract(const Duration(days: 7)))) {
      return 'Lễ Chúa Kitô Vua';
    }
    if (isSameDay(ngay, hienLinh)) return 'Lễ Hiển Linh';
    if (isSameDay(ngay, cprVN)) return 'Lễ Chúa Giêsu Chịu Phép Rửa';
    if (ngay.month == 12 && ngay.day == 25) return 'Lễ Giáng Sinh';
    return null;
  }

  // ── Default mass color ───────────────────────────────────────────

  String _defaultColor(
      String mua, DateTime ngay, Map<String, DateTime> dd) {
    final leHX = dd['leHienXuong']!;
    final leMM = dd['leMinhMau']!;
    final leBaNgoi = dd['leBaNgoi']!;
    final leTT = dd['leTrangThien']!;
    final cnVIIPS = leTT.add(const Duration(days: 3));
    final cnMV = dd['cnIMuaVong']!;

    if (isSameDay(ngay, leHX)) return 'Đ';
    if (isSameDay(ngay, leBaNgoi)) return 'Tr';
    if (isSameDay(ngay, leMM)) return 'Tr';
    if (isSameDay(ngay, leMM.add(const Duration(days: 5)))) return 'Đ';
    if (isSameDay(ngay, cnVIIPS)) return 'Tr';
    if (isSameDay(ngay, cnMV.subtract(const Duration(days: 7)))) return 'Tr';

    switch (mua) {
      case 'Mùa Vọng':
        return 'Tm';
      case 'Mùa Chay':
        return 'Tm';
      case 'Mùa Phục Sinh':
        return 'Tr';
      case 'Mùa Giáng Sinh':
        return 'Tr';
      default:
        return 'X';
    }
  }

  // ── NPVRM rank ───────────────────────────────────────────────────

  int _bacNgayNPVRM(DateTime ngay, Map<String, DateTime> dd) {
    final ps = dd['phucSinh']!;
    final ttlt = dd['thuTuLeTro']!;
    final hx = dd['leHienXuong']!;
    final cnMV = dd['cnIMuaVong']!;
    final thu5 = dd['thu5TuanThanh']!;
    final cnLL = dd['cnLeLa']!;
    final leMM = dd['leMinhMau']!;
    final leBaNgoi = dd['leBaNgoi']!;

    // Bậc 1: Tam Nhật Vượt Qua
    if (!ngay.isBefore(thu5) && !ngay.isAfter(ps)) return 1;

    // Bậc 2: Bát Nhật PS
    if (ngay.isAfter(ps) && !ngay.isAfter(ps.add(const Duration(days: 7)))) {
      return 2;
    }
    // Bậc 2: GS
    if (ngay.month == 12 && ngay.day == 25) return 2;
    // Bậc 2: Tuần Thánh
    if (!ngay.isBefore(cnLL) && ngay.isBefore(thu5)) return 2;
    // Bậc 2: Lễ Trọng di động Chúa sau HX
    if (isSameDay(ngay, leBaNgoi)) return 2;
    if (isSameDay(ngay, leMM)) return 2;
    if (isSameDay(ngay, leMM.add(const Duration(days: 5)))) return 2;
    if (isSameDay(ngay, cnMV.subtract(const Duration(days: 7)))) return 2;

    if (ngay.weekday == DateTime.sunday) {
      if (!ngay.isBefore(cnMV)) return 2; // CN MV
      if (!ngay.isBefore(ttlt) && ngay.isBefore(ps)) return 2; // CN MC
      if (ngay.isAfter(ps) && !ngay.isAfter(hx)) return 2; // CN PS
      return 6; // CN TN/GS
    }

    // Bậc 9: ngày thường MC/MV/PS
    if (!ngay.isBefore(ttlt) && ngay.isBefore(cnLL)) return 9;
    if (!ngay.isBefore(cnMV)) return 9;
    if (ngay.isAfter(ps) && ngay.isBefore(hx)) return 9;

    return 13; // ngày TN/GS thấp
  }

  // ── Moveable feast name ──────────────────────────────────────────

  String? _getMoveableFeast(
    DateTime ngay,
    Map<String, DateTime> dd,
    Map<String, DateTime> ddPrev,
    String nam,
  ) {
    final ps = dd['phucSinh']!;
    final ttlt = dd['thuTuLeTro']!;
    final cnLL = dd['cnLeLa']!;
    final thu5 = dd['thu5TuanThanh']!;
    final thu6 = dd['thu6TuanThanh']!;
    final thu7 = dd['thu7TuanThanh']!;
    final leTT = dd['leTrangThien']!;
    final leHX = dd['leHienXuong']!;
    final leBaNgoi = dd['leBaNgoi']!;
    final leMM = dd['leMinhMau']!;
    final cnMV = dd['cnIMuaVong']!;
    final hienLinh = leHienLinhVN(ngay.year);
    final cprVN = leCPRvn(ngay.year);
    final cnVIIPS = leTT.add(const Duration(days: 3));
    final leVua = cnMV.subtract(const Duration(days: 7));

    if (isSameDay(ngay, ttlt)) return 'Thứ Tư Lễ Tro';
    if (isSameDay(ngay, cnLL)) return 'Chúa Nhật Lễ Lá - Cuộc Thương Khó';
    if (isSameDay(ngay, thu5)) return 'Thứ Năm Tuần Thánh - Lễ Tiệc Ly';
    if (isSameDay(ngay, thu6)) return 'Thứ Sáu Tuần Thánh - Cuộc Khổ Nạn';
    if (isSameDay(ngay, thu7)) return 'Thứ Bảy Tuần Thánh - Vọng Phục Sinh';
    if (isSameDay(ngay, ps)) return 'Chúa Nhật Phục Sinh';

    // Bát Nhật Phục Sinh
    final diffPS = daysBetween(ps, ngay);
    if (diffPS >= 1 && diffPS <= 7) {
      if (diffPS == 7) return 'CN II Phục Sinh - Lòng Thương Xót Chúa';
      const roman = ['II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII'];
      return 'Ngày ${roman[diffPS - 1]} Bát Nhật Phục Sinh';
    }

    // Thăng Thiên dời vào CN VII PS (VN norm)
    if (isSameDay(ngay, cnVIIPS)) return 'Lễ Thăng Thiên';
    if (isSameDay(ngay, leHX)) return 'Lễ Chúa Thánh Thần Hiện Xuống';
    if (isSameDay(ngay, leBaNgoi)) return 'Lễ Chúa Ba Ngôi';
    if (isSameDay(ngay, leMM)) return 'Lễ Mình Máu Thánh Chúa Kitô';
    if (isSameDay(ngay, leMM.add(const Duration(days: 5)))) {
      return 'Lễ Thánh Tâm Chúa Giêsu';
    }
    if (isSameDay(ngay, leVua)) return 'Lễ Chúa Giêsu Kitô, Vua Vũ Trụ';
    if (isSameDay(ngay, hienLinh)) return 'Lễ Hiển Linh';
    if (isSameDay(ngay, cprVN)) return 'Lễ Chúa Giêsu Chịu Phép Rửa';

    // Giáng Sinh
    if (ngay.month == 12 && ngay.day == 25) return 'Lễ Giáng Sinh';

    // Thánh Gia Thất
    if (ngay.month == 12 && ngay.day >= 26 && ngay.day <= 31) {
      if (isSameDay(ngay, leTGT(ngay.year))) return 'Lễ Thánh Gia Thất';
    }

    // Các Chúa Nhật Mùa Vọng
    if (!ngay.isBefore(cnMV) && ngay.weekday == DateTime.sunday) {
      final soCN = daysBetween(cnMV, ngay) ~/ 7 + 1;
      if (soCN >= 1 && soCN <= 4) {
        const roman = ['I', 'II', 'III', 'IV'];
        return 'Chúa Nhật ${roman[soCN - 1]} Mùa Vọng';
      }
    }

    // Các Chúa Nhật Mùa Chay (I–V)
    if (!ngay.isBefore(ttlt) && ngay.isBefore(cnLL) &&
        ngay.weekday == DateTime.sunday) {
      DateTime cnIMC = ttlt.add(const Duration(days: 1));
      while (cnIMC.weekday != DateTime.sunday) {
        cnIMC = cnIMC.add(const Duration(days: 1));
      }
      if (!ngay.isBefore(cnIMC)) {
        final soCN = daysBetween(cnIMC, ngay) ~/ 7 + 1;
        if (soCN >= 1 && soCN <= 5) {
          const roman = ['I', 'II', 'III', 'IV', 'V'];
          return 'Chúa Nhật ${roman[soCN - 1]} Mùa Chay';
        }
      }
    }

    // Các Chúa Nhật Mùa Phục Sinh (III–VII)
    final diffHX = daysBetween(ps, ngay);
    if (diffHX >= 14 && !ngay.isAfter(leHX) &&
        ngay.weekday == DateTime.sunday) {
      final soCN = diffHX ~/ 7 + 1;
      if (soCN >= 3 && soCN <= 7) {
        const roman = ['III', 'IV', 'V', 'VI', 'VII'];
        return 'Chúa Nhật ${roman[soCN - 3]} Phục Sinh';
      }
    }

    return null;
  }

  // ── Week-day name fallback ───────────────────────────────────────

  String _weekDayName(
    DateTime ngay,
    Map<String, DateTime> dd,
    String mua,
    bool laCN,
  ) {
    final thu = thuName(ngay);
    final tuan = tinhTenTuan(ngay);
    if (laCN) return tuan;
    return '$thu. $tuan';
  }

  // ── Reading lookup ───────────────────────────────────────────────

  Map<String, dynamic> _getReadings(
    DateTime ngay,
    Map<String, DateTime> dd,
    String nam,
    String mua,
    bool laCN,
  ) {
    final y = ngay.year;
    final ps = dd['phucSinh']!;
    final leMM = dd['leMinhMau']!;
    final leTT = dd['leTrangThien']!;
    final thu5 = dd['thu5TuanThanh']!;
    final thu6 = dd['thu6TuanThanh']!;
    final thu7 = dd['thu7TuanThanh']!;
    final hienLinh = leHienLinhVN(y);
    final cprVN = leCPRvn(y);
    final cnVIIPS = leTT.add(const Duration(days: 3));

    // ── Hard-coded feasts ──────────────────────────────────────────

    // Triduum
    if (isSameDay(ngay, thu5)) return _cfgMap('triduum', 'thu_5');
    if (isSameDay(ngay, thu6)) return _cfgMap('triduum', 'thu_6');
    if (isSameDay(ngay, thu7)) return _cfgMap('triduum', 'thu_7');
    if (isSameDay(ngay, ps)) return _cfgMap('triduum', 'ps_$nam');

    // Lễ Thăng Thiên dời vào CN VII PS
    if (isSameDay(ngay, cnVIIPS)) {
      final r379 = (_readings!['379'] as Map?)?.cast<String, dynamic>() ?? {};
      final bd = (r379['CN_$nam'] as Map?)?.cast<String, dynamic>() ?? {};
      final tangThienTM =
          ((_cfg!['tang_thien_tin_mung'] as Map?)?[nam] as String?) ??
              (bd['tm'] as String? ?? '');
      return {
        'bd1': bd['bd1'] ?? '',
        'bd2': bd['bd2'] ?? '',
        'tm': tangThienTM,
        'ghi_chu': 'Lễ Thăng Thiên Năm $nam (dời vào CN VII PS)',
      };
    }

    // Lễ Hiển Linh VN
    if (isSameDay(ngay, hienLinh)) {
      return (_cfg!['bai_doc_hien_linh'] as Map).cast<String, dynamic>();
    }

    // Lễ CPR VN
    if (isSameDay(ngay, cprVN)) {
      final r53 = (_readings!['53'] as Map?)?.cast<String, dynamic>() ?? {};
      final bd = (r53['CN_$nam'] as Map?)?.cast<String, dynamic>() ?? {};
      return {
        'bd1': bd['bd1'] ?? '',
        'bd2': bd['bd2'] ?? '',
        'tm': bd['tm'] ?? '',
        'ghi_chu': 'Lễ Chúa Giêsu Chịu Phép Rửa Năm $nam',
      };
    }

    // Lễ Giáng Sinh (25/12)
    if (ngay.month == 12 && ngay.day == 25) {
      final r29 = (_readings!['29'] as Map?)?.cast<String, dynamic>() ?? {};
      return {
        'bd1': r29['nam_le'] ?? '',
        'bd2': r29['nam_chan'] ?? '',
        'tm': r29['tin_mung'] ?? '',
        'ghi_chu': 'Lễ Giáng Sinh',
      };
    }

    // Lễ Thánh Gia Thất
    if (ngay.month == 12 && ngay.day >= 26 && ngay.day <= 31) {
      if (isSameDay(ngay, leTGT(y))) {
        final bdTGT = _cfg!['bai_doc_thanh_gia_that'] as Map?;
        final bd = (bdTGT?[nam] as Map?)?.cast<String, dynamic>() ?? {};
        return {
          'bd1': bd['bd1'] ?? '',
          'bd2': bd['bd2'] ?? '',
          'tm': bd['tm'] ?? '',
          'ghi_chu': 'Lễ Thánh Gia Thất Năm $nam',
        };
      }
    }

    // Lễ Thánh Tâm Chúa Giêsu (Thứ Sáu sau Mình Máu, MM+5)
    if (isSameDay(ngay, leMM.add(const Duration(days: 5)))) {
      final r389 = (_readings!['389'] as Map?)?.cast<String, dynamic>() ?? {};
      final bd = (r389['CN_$nam'] as Map?)?.cast<String, dynamic>() ??
          (r389['CN_A'] as Map?)?.cast<String, dynamic>() ??
          {};
      return {
        'bd1': bd['bd1'] ?? '',
        'bd2': bd['bd2'] ?? '',
        'tm': bd['tm'] ?? '',
        'ghi_chu': 'Lễ Thánh Tâm Chúa Giêsu Năm $nam',
      };
    }

    // Cuối Mùa Vọng 17-24/12 (ngày thường)
    if (ngay.month == 12 && ngay.day >= 17 && ngay.day <= 24 && !laCN) {
      final key = '12-${ngay.day.toString().padLeft(2, '0')}';
      final cv = (_cfg!['bai_doc_cuoi_vong'] as Map?)?[key];
      if (cv is Map) return cv.cast<String, dynamic>();
    }

    // Lễ Cầu Hồn 2/11
    if (ngay.month == 11 && ngay.day == 2) {
      return (_cfg!['bai_doc_cau_hon'] as Map).cast<String, dynamic>();
    }

    // ── Get id_mua ─────────────────────────────────────────────────
    int idMua = tinhIdMua(ngay);

    // Fallback to lich_map for id_mua == 0 (GS / Ba Ngôi / MM special)
    if (idMua == 0) {
      final ps2016 = DateTime(2016, 3, 27);
      final npv2 = namPhungVu(ngay);
      final ps2 = calcEaster(npv2 > ngay.year ? ngay.year : npv2);
      final delta = daysBetween(ps2, ngay);
      final equiv = ps2016.add(Duration(days: delta));
      final equivStr =
          '${equiv.year}-${equiv.month.toString().padLeft(2, '0')}-'
          '${equiv.day.toString().padLeft(2, '0')}';
      final info = (_lichMap![equivStr] as Map?)?.cast<String, dynamic>() ?? {};
      idMua = (info['id_mua'] as num?)?.toInt() ?? 0;

      // Apply TN offset for TN after HX
      if (mua == 'Mùa Thường Niên' && idMua > 0 && _tenLeById != null) {
        final rec = _tenLeById![idMua];
        if (rec != null) {
          final bac1Val = (rec['BacLe1'] as num?)?.toInt() ?? 0;
          final tenLe = rec['TenLe'] as String? ?? '';
          if ((bac1Val == 6 || bac1Val == 13) &&
              tenLe.contains('Thường Niên')) {
            final offset = cnTNTruocChay(y) - nAnchor;
            idMua = idMua + offset * 7;
          }
        }
      }
    }

    final baseId = idMua >= 1000 ? idMua % 1000 : idMua;
    final r = (_readings![baseId.toString()] as Map?)
            ?.cast<String, dynamic>() ??
        {};

    // ── Sunday readings ─────────────────────────────────────────────
    if (laCN) {
      final sk0 = '${ngay.month.toString().padLeft(2, '0')}-'
          '${ngay.day.toString().padLeft(2, '0')}';
      // Lễ Kính Chúa cố định thắng CN TN
      final leKinhChuaThangCN =
          (_cfg!['le_kinh_chua_thang_cn'] as List?)?.cast<String>() ?? [];
      if (leKinhChuaThangCN.contains(sk0) &&
          _bacNgayNPVRM(ngay, getDD(ngay.year)) == 6) {
        final saintsList = _saints![sk0];
        if (saintsList is List) {
          for (final f in saintsList) {
            if (f is! Map) continue;
            final fid = (f['id'] as num?)?.toInt() ?? 0;
            final r2 = (_readings![fid.toString()] as Map?)
                    ?.cast<String, dynamic>() ??
                {};
            final bd = (r2['CN_$nam'] as Map?)?.cast<String, dynamic>() ??
                (r2['CN_A'] as Map?)?.cast<String, dynamic>() ??
                {};
            return {
              'bd1': bd['bd1'] ?? r2['nam_le'] ?? '',
              'bd2': bd['bd2'] ?? r2['nam_chan'] ?? '',
              'tm': bd['tm'] ?? r2['tin_mung'] ?? '',
              'ghi_chu': 'Lễ Kính — ${f['ten_le'] ?? ''}',
            };
          }
        }
      }

      // Fallback to CN_B for fixed solemnities that have same readings every year
      final bd = (r['CN_$nam'] as Map?)?.cast<String, dynamic>() ??
          (r['CN_B'] as Map?)?.cast<String, dynamic>() ??
          (r['CN_A'] as Map?)?.cast<String, dynamic>() ??
          {};
      return {
        'bd1': bd['bd1'] ?? '',
        'bd2': bd['bd2'] ?? '',
        'tm': bd['tm'] ?? '',
        'ghi_chu': 'Chúa Nhật Năm $nam',
      };
    }

    // ── Weekday readings ────────────────────────────────────────────
    String bd1;
    String ghiChu;
    if (mua == 'Mùa Thường Niên') {
      bd1 = ngay.year % 2 == 1
          ? (r['nam_le'] as String? ?? '')
          : (r['nam_chan'] as String? ?? '');
      ghiChu = 'Năm ${ngay.year % 2 == 1 ? 'I lẻ' : 'II chẵn'}';
    } else {
      bd1 = r['nam_le'] as String? ?? '';
      ghiChu = mua;
    }

    // Check if a saint's feast overrides
    final sk = '${ngay.month.toString().padLeft(2, '0')}-'
        '${ngay.day.toString().padLeft(2, '0')}';

    // Lễ Kính Chúa cố định (le_kinh_chua_co_dinh)
    final leKinhChuaCD =
        (_cfg!['le_kinh_chua_co_dinh'] as Map?)?.cast<String, dynamic>() ??
            {};
    if (leKinhChuaCD.containsKey(sk)) {
      final v = leKinhChuaCD[sk] as Map;
      return {
        'bd1': v['bd1'] ?? '',
        'bd2': v['bd2'] ?? '',
        'tm': v['tm'] ?? '',
        'ghi_chu': 'Lễ Kính — Lễ Cố Định',
      };
    }

    final bacNgay = _bacNgayNPVRM(ngay, getDD(ngay.year));
    final saintsList = _saints![sk];
    if (saintsList is List) {
      for (final f in saintsList) {
        if (f is! Map) continue;
        final bacThanh = (f['bac_le'] as num?)?.toInt() ?? 99;
        final fid = (f['id'] as num?)?.toInt() ?? 0;
        final r2 =
            (_readings![fid.toString()] as Map?)?.cast<String, dynamic>() ??
                {};

        if (bacThanh < bacNgay) {
          if (bacThanh == 7) {
            // Lễ Kính
            return {
              'bd1': r2['nam_le'] ?? '',
              'bd2': '',
              'tm': r2['tin_mung'] ?? '',
              'ghi_chu': 'Lễ Kính — ${f['ten_le'] ?? ''}',
            };
          } else if (bacThanh <= 5) {
            // Lễ Trọng ngày thường
            final bd = (r2['CN_A'] as Map?)?.cast<String, dynamic>() ?? {};
            return {
              'bd1': bd['bd1'] ?? r2['nam_le'] ?? '',
              'bd2': bd['bd2'] ?? r2['nam_chan'] ?? '',
              'tm': bd['tm'] ?? r2['tin_mung'] ?? '',
              'ghi_chu': 'Lễ Trọng — ${f['ten_le'] ?? ''}',
            };
          }
        }
        break; // Only first (highest priority) saint
      }
    }

    return {
      'bd1': bd1,
      'bd2': '',
      'tm': r['tin_mung'] as String? ?? '',
      'ghi_chu': ghiChu,
    };
  }

  // ── Helper: read triduum data from cfg ───────────────────────────

  Map<String, dynamic> _cfgMap(String section, String key) {
    final m = (_cfg![section] as Map?)?[key];
    if (m is Map) return m.cast<String, dynamic>();
    return {};
  }
}
