"""
liturgical_engine.py
Lịch phụng vụ Công giáo — Python port từ Dart (TTLM project).
Tính các ngày di động, mùa phụng vụ, bậc lễ, và bài đọc.
"""

from __future__ import annotations
from datetime import date, timedelta
from functools import lru_cache


# ── Easter: Meeus/Jones/Butcher ───────────────────────────────────────

def calc_easter(year: int) -> date:
    a = year % 19
    b = year // 100
    c = year % 100
    d = b // 4
    e = b % 4
    f = (b + 8) // 25
    g = (b - f + 1) // 3
    h = (19 * a + b - d - g + 15) % 30
    i = c // 4
    k = c % 4
    ll = (32 + 2 * e + 2 * i - h - k) % 7
    m = (a + 11 * h + 22 * ll) // 451
    month = (h + ll - 7 * m + 114) // 31
    day = ((h + ll - 7 * m + 114) % 31) + 1
    return date(year, month, day)


# ── Moveable feasts ───────────────────────────────────────────────────

def le_hien_linh_vn(year: int) -> date:
    """CN đầu tiên trong khoảng Jan 2–8 (Hiển Linh VN)."""
    d = date(year, 1, 2)
    while d.weekday() != 6:   # Sunday = 6 in Python
        d += timedelta(days=1)
    return d


def le_cpr_vn(year: int) -> date:
    """Thứ Hai sau Hiển Linh VN (Lễ CPR VN)."""
    return le_hien_linh_vn(year) + timedelta(days=1)


def _cn_i_mua_vong(year: int) -> date:
    """CN đầu tiên >= 27/11."""
    d = date(year, 11, 27)
    days_to_sun = (6 - d.weekday()) % 7
    return d + timedelta(days=days_to_sun)


def le_tgt(year: int) -> date:
    """Lễ Thánh Gia Thất: nếu GS là CN → 30/12, ngược lại CN đầu sau 25/12."""
    gs = date(year, 12, 25)
    if gs.weekday() == 6:      # Sunday
        return date(year, 12, 30)
    d = gs + timedelta(days=1)
    while d.weekday() != 6:
        d += timedelta(days=1)
    return d


def le_vong_hien_xuong(year: int) -> date:
    """Thứ Bảy trước Lễ Hiện Xuống (Lễ Vọng Hiện Xuống) = PS + 48."""
    return calc_easter(year) + timedelta(days=48)


@lru_cache(maxsize=64)
def calc_movable_feasts(year: int) -> dict[str, date]:
    ps = calc_easter(year)
    thu_tu_le_tro   = ps - timedelta(days=46)
    cn_le_la        = ps - timedelta(days=7)
    thu5_tuan_thanh = ps - timedelta(days=3)
    thu6_tuan_thanh = ps - timedelta(days=2)
    thu7_tuan_thanh = ps - timedelta(days=1)
    le_trang_thien  = ps + timedelta(days=39)
    le_hien_xuong   = ps + timedelta(days=49)
    le_ba_ngoi      = ps + timedelta(days=56)
    le_minh_mau     = ps + timedelta(days=63)
    cn_i_mua_vong   = _cn_i_mua_vong(year)
    cn_vii_ps       = le_trang_thien + timedelta(days=3)   # Thăng Thiên dời vào CN VII PS

    return {
        'thu_tu_le_tro':   thu_tu_le_tro,
        'cn_le_la':        cn_le_la,
        'thu5_tuan_thanh': thu5_tuan_thanh,
        'thu6_tuan_thanh': thu6_tuan_thanh,
        'thu7_tuan_thanh': thu7_tuan_thanh,
        'phuc_sinh':       ps,
        'le_trang_thien':  le_trang_thien,
        'le_hien_xuong':   le_hien_xuong,
        'le_ba_ngoi':      le_ba_ngoi,
        'le_minh_mau':     le_minh_mau,
        'cn_i_mua_vong':   cn_i_mua_vong,
        'cn_vii_ps':       cn_vii_ps,
    }


def get_dd(year: int) -> dict[str, date]:
    return calc_movable_feasts(year)


# ── Liturgical year ───────────────────────────────────────────────────

def nam_phung_vu(ngay: date) -> int:
    """NamPV = năm kết thúc. E.g. 2025-2026 → 2026."""
    y = ngay.year
    dd = get_dd(y)
    return y + 1 if ngay >= dd['cn_i_mua_vong'] else y


def nam_abc(nam_pv: int) -> str:
    r = nam_pv % 3
    return 'A' if r == 1 else ('B' if r == 2 else 'C')


# ── Liturgical season ─────────────────────────────────────────────────

def xac_dinh_mua(ngay: date) -> str:
    y = ngay.year
    dd = get_dd(y)
    ps         = dd['phuc_sinh']
    ttlt       = dd['thu_tu_le_tro']
    hx         = dd['le_hien_xuong']
    cn_mv      = dd['cn_i_mua_vong']
    gs         = date(y, 12, 25)
    cpr_vn     = le_cpr_vn(y)

    if ngay >= gs:            return 'Mùa Giáng Sinh'
    if ngay >= cn_mv:         return 'Mùa Vọng'
    if ngay > hx:             return 'Mùa Thường Niên'
    if ngay >= ps:            return 'Mùa Phục Sinh'
    if ngay >= ttlt:          return 'Mùa Chay'
    if ngay > cpr_vn:         return 'Mùa Thường Niên'
    gs_truoc = date(y - 1, 12, 25)
    if ngay >= gs_truoc:      return 'Mùa Giáng Sinh'
    return 'Mùa Thường Niên'


# ── Week rank (for saint override logic) ──────────────────────────────

def bac_ngay_npvrm(ngay: date, dd: dict[str, date]) -> int:
    """
    1 = Tam Nhật Vượt Qua
    2 = Lễ Trọng di động / Chúa Nhật đặc biệt
    6 = Chúa Nhật TN / Mùa Giáng Sinh
    9 = Ngày thường MC / MV / PS
    13 = Ngày thường TN / GS thấp
    """
    ps   = dd['phuc_sinh']
    ttlt = dd['thu_tu_le_tro']
    hx   = dd['le_hien_xuong']
    cn_mv = dd['cn_i_mua_vong']
    thu5 = dd['thu5_tuan_thanh']
    cn_ll = dd['cn_le_la']
    le_mm = dd['le_minh_mau']
    le_ba_ngoi = dd['le_ba_ngoi']
    cn_vii_ps  = dd['cn_vii_ps']

    # Bậc 1: Tam Nhật Vượt Qua
    if thu5 <= ngay <= ps:
        return 1

    # Bậc 2: Bát Nhật PS
    if ps < ngay <= ps + timedelta(days=7):
        return 2
    # Bậc 2: Giáng Sinh
    if ngay.month == 12 and ngay.day == 25:
        return 2
    # Bậc 2: Tuần Thánh
    if cn_ll <= ngay < thu5:
        return 2
    # Bậc 2: Lễ Trọng di động sau HX
    if ngay in (le_ba_ngoi, le_mm, le_mm + timedelta(days=5),
                cn_mv - timedelta(days=7), cn_vii_ps):
        return 2

    if ngay.weekday() == 6:   # Sunday
        if ngay >= cn_mv:                         return 2   # CN MV
        if ttlt <= ngay < ps:                     return 2   # CN MC
        if ps < ngay <= hx:                       return 2   # CN PS
        return 6                                             # CN TN/GS

    # Bậc 9
    if ttlt <= ngay < cn_ll:  return 9
    if ngay >= cn_mv:         return 9
    if ps < ngay < hx:        return 9

    return 13


# ── id_mua computation ────────────────────────────────────────────────

_ANCHOR_YEAR = 2016


@lru_cache(maxsize=8)
def _cn_tn_truoc_chay(year: int) -> int:
    dd = get_dd(year)
    cpr = le_cpr_vn(year)
    cn_ii = cpr + timedelta(days=1)
    while cn_ii.weekday() != 6:
        cn_ii += timedelta(days=1)
    n, cn = 0, cn_ii
    while cn < dd['thu_tu_le_tro']:
        n += 1
        cn += timedelta(days=7)
    return n


_n_anchor: int | None = None


def _get_n_anchor() -> int:
    global _n_anchor
    if _n_anchor is None:
        _n_anchor = _cn_tn_truoc_chay(_ANCHOR_YEAR)
    return _n_anchor


def tinh_id_mua(ngay: date) -> int:
    y = ngay.year
    dd = get_dd(y)
    ps    = dd['phuc_sinh']
    ttlt  = dd['thu_tu_le_tro']
    hx    = dd['le_hien_xuong']
    cn_mv = dd['cn_i_mua_vong']
    mm    = dd['le_minh_mau']
    hien_linh = le_hien_linh_vn(y)
    cpr       = le_cpr_vn(y)
    w = 0 if ngay.weekday() == 6 else ngay.weekday() + 1  # Sun=0, Mon=1..Sat=6

    # GS Dec 25-31
    if ngay.month == 12 and ngay.day >= 25:
        return 29 + (ngay.day - 25)

    # Jan 1
    if ngay.month == 1 and ngay.day == 1:
        return 36

    # Jan 2 → day before Hiển Linh VN
    if ngay.month == 1 and date(y, 1, 2) <= ngay < hien_linh:
        return 39 + (ngay.weekday())   # Mon=0→39, Tue=1→40 … Sat=5→44

    if ngay == hien_linh: return 45
    if ngay == cpr:       return 53

    # Mùa Vọng
    if cn_mv <= ngay < date(y, 12, 25):
        tuan = min(4, (ngay - cn_mv).days // 7 + 1)
        return 1 + (tuan - 1) * 7 + w

    # Mùa Chay
    if ttlt <= ngay < ps:
        if ngay == ttlt: return 291
        cn_i_mc = ttlt + timedelta(days=1)
        while cn_i_mc.weekday() != 6:
            cn_i_mc += timedelta(days=1)
        if ngay < cn_i_mc:
            return 291 + (ngay - ttlt).days
        tuan = (ngay - cn_i_mc).days // 7 + 1
        return 295 + (tuan - 1) * 7 + w

    # Mùa Phục Sinh
    if ps <= ngay <= hx:
        return 337 + (ngay - ps).days

    # TN trước Chay
    cpr_vn = le_cpr_vn(y)
    cn_ii_tn = cpr_vn + timedelta(days=1)
    while cn_ii_tn.weekday() != 6:
        cn_ii_tn += timedelta(days=1)
    if cn_ii_tn <= ngay < ttlt:
        tuan = (ngay - cn_ii_tn).days // 7 + 2
        return 60 + (tuan - 2) * 7 + w

    # Khoảng giữa CPR và CN II TN
    if cpr_vn < ngay < cn_ii_tn:
        days_to_cn = (cn_ii_tn - ngay).days
        return 60 - days_to_cn

    # TN sau HX
    if ngay > hx:
        cn_tn_sau_mm = mm + timedelta(days=7)
        if ngay < cn_tn_sau_mm:
            return 0   # Ba Ngôi / Mình Máu / Thánh Tâm
        offset = _cn_tn_truoc_chay(y) - _get_n_anchor()
        tuan_dau = 10 + offset
        tuan = tuan_dau + (ngay - cn_tn_sau_mm).days // 7
        return 60 + (tuan - 2) * 7 + w

    return 0


# ── Season label ──────────────────────────────────────────────────────

_TEN_TUAN_TN = [
    'I', 'II', 'III', 'IV', 'V', 'VI', 'VII', 'VIII', 'IX', 'X',
    'XI', 'XII', 'XIII', 'XIV', 'XV', 'XVI', 'XVII', 'XVIII', 'XIX', 'XX',
    'XXI', 'XXII', 'XXIII', 'XXIV', 'XXV', 'XXVI', 'XXVII', 'XXVIII',
    'XXIX', 'XXX', 'XXXI', 'XXXII', 'XXXIII', 'XXXIV',
]

_THU_TEN = ['Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy', 'Chúa Nhật']


def thu_name(ngay: date) -> str:
    return _THU_TEN[ngay.weekday()]


def tinh_ten_tuan(ngay: date) -> str:
    y = ngay.year
    dd = get_dd(y)
    ps    = dd['phuc_sinh']
    ttlt  = dd['thu_tu_le_tro']
    hx    = dd['le_hien_xuong']
    cn_mv = dd['cn_i_mua_vong']

    if cn_mv <= ngay < date(y, 12, 25):
        tuan = min(4, (ngay - cn_mv).days // 7 + 1)
        return f'Tuần {_TEN_TUAN_TN[tuan - 1]} Mùa Vọng'

    mua = xac_dinh_mua(ngay)
    if mua == 'Mùa Giáng Sinh':
        return 'Mùa Giáng Sinh'

    if ttlt <= ngay < ps:
        if ngay == ttlt: return 'Thứ Tư Lễ Tro'
        cn_i_mc = ttlt + timedelta(days=1)
        while cn_i_mc.weekday() != 6:
            cn_i_mc += timedelta(days=1)
        tuan = min(5, (ngay - cn_i_mc).days // 7 + 1)
        return f'Tuần {_TEN_TUAN_TN[tuan - 1]} Mùa Chay'

    if ps <= ngay <= hx:
        tuan_ps = (ngay - ps).days // 7 + 1
        return f'Tuần {_TEN_TUAN_TN[min(tuan_ps, 8) - 1]} Phục Sinh'

    if ngay > hx:
        mm = dd['le_minh_mau']
        cn_tn_sau_mm = mm + timedelta(days=7)
        if ngay < cn_tn_sau_mm:
            return 'Mùa Thường Niên'
        offset = _cn_tn_truoc_chay(y) - _get_n_anchor()
        tuan_dau = 10 + offset
        tuan = tuan_dau + (ngay - cn_tn_sau_mm).days // 7
        return f'Tuần {_TEN_TUAN_TN[min(tuan, 34) - 1]} Thường Niên'

    cpr_vn = le_cpr_vn(y)
    cn_ii_tn = cpr_vn + timedelta(days=1)
    while cn_ii_tn.weekday() != 6:
        cn_ii_tn += timedelta(days=1)
    if cn_ii_tn <= ngay < ttlt:
        tuan = (ngay - cn_ii_tn).days // 7 + 2
        return f'Tuần {_TEN_TUAN_TN[min(tuan, 34) - 1]} Thường Niên'

    return 'Mùa Thường Niên'
