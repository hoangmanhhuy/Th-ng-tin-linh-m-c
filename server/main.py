"""
main.py — FastAPI server: Lịch phụng vụ Công giáo
Endpoint: GET /api/v1/liturgical/info?date=YYYY-MM-DD&lang=vi|en

Chạy local:
    pip install -r requirements.txt
    uvicorn main:app --reload --port 8000

Môi trường sản xuất:
    uvicorn main:app --host 0.0.0.0 --port 8000 --workers 4
"""

from __future__ import annotations

import json
import os
import re
from datetime import date, timedelta
from pathlib import Path
from functools import lru_cache
from typing import Optional

from fastapi import FastAPI, Query, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from liturgical_engine import (
    calc_easter, calc_movable_feasts, get_dd,
    le_hien_linh_vn, le_cpr_vn, le_tgt, le_vong_hien_xuong,
    nam_phung_vu, nam_abc,
    xac_dinh_mua, bac_ngay_npvrm, tinh_id_mua, tinh_ten_tuan,
    thu_name,
    _cn_tn_truoc_chay, _get_n_anchor,
)

# ── App ───────────────────────────────────────────────────────────────

app = FastAPI(
    title="TTLM Liturgical Calendar API",
    description="Lịch phụng vụ Công giáo — Giáo phận Phú Cường",
    version="1.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET"],
    allow_headers=["*"],
)

# ── Data paths ────────────────────────────────────────────────────────

# Thư mục assets liturgical (cùng cấp hoặc override qua env)
_ASSETS_DIR = Path(
    os.environ.get(
        "LITURGICAL_ASSETS",
        str(Path(__file__).parent.parent / "flutter_app" / "assets" / "liturgical"),
    )
)


@lru_cache(maxsize=1)
def _load_data() -> dict:
    """Load và cache toàn bộ JSON assets."""
    def _read(name: str) -> dict | list:
        p = _ASSETS_DIR / name
        if not p.exists():
            raise RuntimeError(f"Missing asset: {p}")
        with open(p, encoding="utf-8") as f:
            return json.load(f)

    readings_raw = _read("readings.json")
    readings: dict[str, dict] = {
        str(k): v for k, v in readings_raw.items()
    } if isinstance(readings_raw, dict) else {}

    saints_raw = _read("saints.json")
    saints: dict[str, list] = saints_raw if isinstance(saints_raw, dict) else {}

    cfg: dict = _read("ten_le_config.json")   # type: ignore

    lich_map_raw = _read("lich_map.json")
    lich_map: dict[str, dict] = lich_map_raw if isinstance(lich_map_raw, dict) else {}

    ten_le_list: list = _read("ten_le.json")   # type: ignore
    ten_le_by_id: dict[int, dict] = {
        rec["ID"]: rec for rec in ten_le_list if isinstance(rec, dict) and rec.get("ID")
    }

    return {
        "readings":    readings,
        "saints":      saints,
        "cfg":         cfg,
        "lich_map":    lich_map,
        "ten_le":      ten_le_by_id,
    }


# ── Response schema ───────────────────────────────────────────────────

class LiturgicalResponse(BaseModel):
    dateString: str
    season:     str
    feast:      str
    mauLe:      str
    bd1:        str
    bd2:        str
    tinMung:    str
    ghiChu:     str
    # Lễ Vọng
    hasLeVong:  bool   = False
    tenLeVong:  str    = ""
    bd1Vong:    str    = ""
    bd2Vong:    str    = ""
    tmVong:     str    = ""
    mauLeVong:  str    = ""
    ghiChuVong: str    = ""


# ── Main computation ──────────────────────────────────────────────────

def compute(ngay: date, lang: str = "vi") -> LiturgicalResponse:
    data   = _load_data()
    reads  = data["readings"]
    saints = data["saints"]
    cfg    = data["cfg"]
    lich   = data["lich_map"]
    ten_le = data["ten_le"]

    y       = ngay.year
    dd      = get_dd(y)
    dd_prev = get_dd(y - 1)
    ps      = dd["phuc_sinh"]
    ttlt    = dd["thu_tu_le_tro"]
    hx      = dd["le_hien_xuong"]
    cn_mv   = dd["cn_i_mua_vong"]
    thu5    = dd["thu5_tuan_thanh"]
    thu6    = dd["thu6_tuan_thanh"]
    thu7    = dd["thu7_tuan_thanh"]
    le_tt   = dd["le_trang_thien"]
    le_mm   = dd["le_minh_mau"]
    le_bn   = dd["le_ba_ngoi"]
    cn_vii  = dd["cn_vii_ps"]
    le_vua  = cn_mv - timedelta(days=7)
    hien_linh = le_hien_linh_vn(y)
    cpr_vn    = le_cpr_vn(y)

    mua   = xac_dinh_mua(ngay)
    npv   = nam_phung_vu(ngay)
    nam   = nam_abc(npv)
    la_cn = ngay.weekday() == 6

    # ── Date string ──────────────────────────────────────────────────
    thu_names_vi = ['Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy','Chúa Nhật']
    thu_names_en = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday']
    thu_names    = thu_names_en if lang == "en" else thu_names_vi
    thu          = thu_names[ngay.weekday()]
    if lang == "en":
        date_str = f"{thu}, {ngay.strftime('%B')} {ngay.day}"
    else:
        date_str = f"{thu}, {ngay.day} Tháng {ngay.month}"

    # ── Season badge ─────────────────────────────────────────────────
    season = _build_season(ngay, dd, lang)

    # ── Feast name ───────────────────────────────────────────────────
    feast  = ""
    mau_le = _default_color(mua, ngay, dd)

    # Priority 1: moveable
    mv = _get_moveable_feast(ngay, dd, nam, lang)
    if mv:
        feast = mv

    # Priority 2: saints
    if not feast:
        sk = f"{ngay.month:02d}-{ngay.day:02d}"
        bac = bac_ngay_npvrm(ngay, dd)
        for f in (saints.get(sk) or []):
            if not isinstance(f, dict): continue
            bac_t = int(f.get("bac_le", 99))
            ten_t = f.get("ten_le", "")
            if bac_t < bac or (bac_t == 10 and bac >= 13):
                feast = _maybe_translate(ten_t, lang)
                mau_t = f.get("mau_le")
                if mau_t:
                    mau_le = mau_t
                break

    # Priority 3: week position
    if not feast:
        ten_t = tinh_ten_tuan(ngay)
        feast = _translate_season(ten_t, lang) if not la_cn else _translate_season(ten_t, lang)
        if not la_cn:
            feast = f"{_translate_thu(ngay, lang)}. {feast}"

    # ── Readings ─────────────────────────────────────────────────────
    rd = _get_readings(ngay, dd, nam, mua, la_cn, reads, cfg, lich, ten_le, y)

    # ── Lễ Vọng ──────────────────────────────────────────────────────
    vong = _get_le_vong(ngay, dd, cfg)
    has_vong = vong is not None

    return LiturgicalResponse(
        dateString = date_str,
        season     = season,
        feast      = feast,
        mauLe      = mau_le,
        bd1        = rd.get("bd1", ""),
        bd2        = rd.get("bd2", ""),
        tinMung    = rd.get("tm", ""),
        ghiChu     = rd.get("ghi_chu", ""),
        hasLeVong  = has_vong,
        tenLeVong  = vong.get("ten_le_vong", "") if has_vong else "",
        bd1Vong    = vong.get("bd1", "")           if has_vong else "",
        bd2Vong    = vong.get("bd2", "")           if has_vong else "",
        tmVong     = vong.get("tm", "")            if has_vong else "",
        mauLeVong  = vong.get("mau_le", "")        if has_vong else "",
        ghiChuVong = vong.get("ghi_chu", "")       if has_vong else "",
    )


# ── Helpers ───────────────────────────────────────────────────────────

def _build_season(ngay: date, dd: dict, lang: str) -> str:
    ps   = dd["phuc_sinh"]
    le_mm = dd["le_minh_mau"]
    hx   = dd["le_hien_xuong"]
    le_bn = dd["le_ba_ngoi"]
    cn_mv = dd["cn_i_mua_vong"]
    cn_vii = dd["cn_vii_ps"]
    hien_linh = le_hien_linh_vn(ngay.year)
    cpr_vn    = le_cpr_vn(ngay.year)

    labels = {
        ps:                         {"vi": "Chúa Nhật Phục Sinh",              "en": "Easter Sunday"},
        ps + timedelta(days=7):     {"vi": "CN II Phục Sinh - Lòng Thương Xót","en": "Divine Mercy Sunday"},
        cn_vii:                     {"vi": "Lễ Thăng Thiên",                   "en": "Ascension"},
        hx:                         {"vi": "Lễ Hiện Xuống",                    "en": "Pentecost"},
        le_bn:                      {"vi": "Lễ Chúa Ba Ngôi",                  "en": "Holy Trinity"},
        le_mm:                      {"vi": "Lễ Mình Máu Thánh",                "en": "Corpus Christi"},
        le_mm + timedelta(days=5):  {"vi": "Lễ Thánh Tâm",                    "en": "Sacred Heart"},
        cn_mv - timedelta(days=7):  {"vi": "Lễ Chúa Kitô Vua",                "en": "Christ the King"},
        hien_linh:                  {"vi": "Lễ Hiển Linh",                     "en": "Epiphany"},
        cpr_vn:                     {"vi": "Lễ Chúa Giêsu Chịu Phép Rửa",     "en": "Baptism of the Lord"},
        date(ngay.year, 12, 25):    {"vi": "Lễ Giáng Sinh",                    "en": "Christmas"},
    }
    if ngay in labels:
        return labels[ngay][lang]
    return _translate_season(tinh_ten_tuan(ngay), lang)


def _default_color(mua: str, ngay: date, dd: dict) -> str:
    le_mm = dd["le_minh_mau"]
    le_bn = dd["le_ba_ngoi"]
    hx    = dd["le_hien_xuong"]
    le_tt = dd["le_trang_thien"]
    cn_vii = dd["cn_vii_ps"]
    cn_mv  = dd["cn_i_mua_vong"]

    if ngay == hx:                              return "Đ"
    if ngay == le_bn:                           return "Tr"
    if ngay == le_mm:                           return "Tr"
    if ngay == le_mm + timedelta(days=5):       return "Đ"
    if ngay == cn_vii:                          return "Tr"
    if ngay == cn_mv - timedelta(days=7):       return "Tr"

    color_map = {
        "Mùa Vọng":        "Tm",
        "Mùa Chay":        "Tm",
        "Mùa Phục Sinh":   "Tr",
        "Mùa Giáng Sinh":  "Tr",
    }
    return color_map.get(mua, "X")


def _get_moveable_feast(ngay: date, dd: dict, nam: str, lang: str) -> str | None:
    ps   = dd["phuc_sinh"]
    ttlt = dd["thu_tu_le_tro"]
    cn_ll = dd["cn_le_la"]
    thu5 = dd["thu5_tuan_thanh"]
    thu6 = dd["thu6_tuan_thanh"]
    thu7 = dd["thu7_tuan_thanh"]
    le_tt = dd["le_trang_thien"]
    hx   = dd["le_hien_xuong"]
    le_bn = dd["le_ba_ngoi"]
    le_mm = dd["le_minh_mau"]
    cn_mv = dd["cn_i_mua_vong"]
    cn_vii = dd["cn_vii_ps"]
    le_vua = cn_mv - timedelta(days=7)
    hien_linh = le_hien_linh_vn(ngay.year)
    cpr_vn    = le_cpr_vn(ngay.year)
    y = ngay.year

    _f = {
        ttlt:  {"vi": "Thứ Tư Lễ Tro",                              "en": "Ash Wednesday"},
        cn_ll: {"vi": "Chúa Nhật Lễ Lá - Cuộc Thương Khó",         "en": "Palm Sunday - Passion of the Lord"},
        thu5:  {"vi": "Thứ Năm Tuần Thánh - Lễ Tiệc Ly",           "en": "Holy Thursday - Mass of the Lord's Supper"},
        thu6:  {"vi": "Thứ Sáu Tuần Thánh - Cuộc Khổ Nạn",        "en": "Good Friday - Passion of the Lord"},
        thu7:  {"vi": "Thứ Bảy Tuần Thánh — Không có Thánh lễ ban ngày",
                "en": "Holy Saturday — No daytime Mass"},
        ps:    {"vi": "Chúa Nhật Phục Sinh",                        "en": "Easter Sunday"},
        cn_vii:{"vi": "Lễ Thăng Thiên",                             "en": "Ascension of the Lord"},
        hx:    {"vi": "Lễ Chúa Thánh Thần Hiện Xuống",             "en": "Pentecost Sunday"},
        le_bn: {"vi": "Lễ Chúa Ba Ngôi",                            "en": "Holy Trinity"},
        le_mm: {"vi": "Lễ Mình Máu Thánh Chúa Kitô",               "en": "Corpus Christi"},
        le_mm + timedelta(days=5): {"vi": "Lễ Thánh Tâm Chúa Giêsu","en": "Sacred Heart of Jesus"},
        le_vua: {"vi": "Lễ Chúa Giêsu Kitô, Vua Vũ Trụ",          "en": "Christ the King"},
        hien_linh: {"vi": "Lễ Hiển Linh",                           "en": "Epiphany of the Lord"},
        cpr_vn:    {"vi": "Lễ Chúa Giêsu Chịu Phép Rửa",           "en": "Baptism of the Lord"},
    }
    if ngay in _f:
        return _f[ngay][lang]

    # Bát Nhật Phục Sinh
    diff_ps = (ngay - ps).days
    if 1 <= diff_ps <= 7:
        if diff_ps == 7:
            return ("CN II Phục Sinh - Lòng Thương Xót Chúa"
                    if lang == "vi" else "Divine Mercy Sunday")
        roman = ["II","III","IV","V","VI","VII","VIII"]
        if lang == "vi":
            return f"Ngày {roman[diff_ps - 1]} Bát Nhật Phục Sinh"
        return f"Day {roman[diff_ps - 1]} of the Easter Octave"

    # Giáng Sinh 25/12
    if ngay.month == 12 and ngay.day == 25:
        return "Lễ Giáng Sinh" if lang == "vi" else "Christmas Day"

    # Thánh Gia Thất
    if ngay.month == 12 and 26 <= ngay.day <= 31 and ngay == le_tgt(y):
        return "Lễ Thánh Gia Thất" if lang == "vi" else "Holy Family"

    # Các CN Mùa Vọng
    if ngay >= cn_mv and ngay.weekday() == 6:
        so_cn = (ngay - cn_mv).days // 7 + 1
        if 1 <= so_cn <= 4:
            roman = ["I","II","III","IV"]
            return (f"Chúa Nhật {roman[so_cn-1]} Mùa Vọng"
                    if lang == "vi" else f"Advent Sunday {roman[so_cn-1]}")

    # Các CN Mùa Chay
    if ttlt <= ngay < cn_ll and ngay.weekday() == 6:
        cn_i_mc = ttlt + timedelta(days=1)
        while cn_i_mc.weekday() != 6:
            cn_i_mc += timedelta(days=1)
        if ngay >= cn_i_mc:
            so_cn = (ngay - cn_i_mc).days // 7 + 1
            if 1 <= so_cn <= 5:
                roman = ["I","II","III","IV","V"]
                return (f"Chúa Nhật {roman[so_cn-1]} Mùa Chay"
                        if lang == "vi" else f"Lent Sunday {roman[so_cn-1]}")

    # Các CN Mùa Phục Sinh III–VII
    diff_hx = (ngay - ps).days
    if diff_hx >= 14 and ngay <= hx and ngay.weekday() == 6:
        so_cn = diff_hx // 7 + 1
        if 3 <= so_cn <= 7:
            roman = ["III","IV","V","VI","VII"]
            return (f"Chúa Nhật {roman[so_cn-3]} Phục Sinh"
                    if lang == "vi" else f"Easter Sunday {roman[so_cn-3]}")

    return None


def _get_le_vong(ngay: date, dd: dict, cfg: dict) -> dict | None:
    # 24/12 — Lễ Vọng Giáng Sinh
    if ngay.month == 12 and ngay.day == 24:
        return {
            "ten_le_vong": "Lễ Vọng Giáng Sinh",
            "ten_le_chinh": "Lễ Giáng Sinh (25/12)",
            "mau_le": "Tr",
            "bd1": "Is 62,1-5",
            "bd2": "Cv 13,16-17.22-25",
            "tm":  "Mt 1,1-25",
            "ghi_chu": "Lễ Vọng Giáng Sinh — Tối nay cử hành Lễ Vọng",
        }
    # Thứ Bảy trước Hiện Xuống
    vong_hx = le_vong_hien_xuong(ngay.year)
    if ngay == vong_hx:
        return cfg.get("le_vong_hien_xuong")
    # Cố định: 23/6, 28/6, 14/8
    sk = f"{ngay.month:02d}-{ngay.day:02d}"
    vong_cd = (cfg.get("le_vong_co_dinh") or {}).get(sk)
    if isinstance(vong_cd, dict):
        return vong_cd
    return None


def _get_readings(
    ngay: date, dd: dict, nam: str, mua: str, la_cn: bool,
    reads: dict, cfg: dict, lich: dict, ten_le: dict, y: int
) -> dict:
    ps   = dd["phuc_sinh"]
    thu5 = dd["thu5_tuan_thanh"]
    thu6 = dd["thu6_tuan_thanh"]
    thu7 = dd["thu7_tuan_thanh"]
    le_mm = dd["le_minh_mau"]
    le_tt = dd["le_trang_thien"]
    cn_vii = dd["cn_vii_ps"]
    hien_linh = le_hien_linh_vn(y)
    cpr_vn    = le_cpr_vn(y)

    def r(id_: int | str) -> dict:
        return reads.get(str(id_)) or {}

    def cfg_map(section: str, key: str) -> dict:
        v = (cfg.get(section) or {}).get(key)
        return dict(v) if isinstance(v, dict) else {}

    # Triduum
    if ngay == thu5: return cfg_map("triduum", "thu_5")
    if ngay == thu6: return cfg_map("triduum", "thu_6")
    if ngay == thu7: return cfg_map("triduum", "thu_7")
    if ngay == ps:   return cfg_map("triduum", f"ps_{nam}")

    # Thăng Thiên (CN VII PS)
    if ngay == cn_vii:
        r379 = r(379)
        bd   = (r379.get(f"CN_{nam}") or r379.get("CN_A") or {})
        tang_tm = (cfg.get("tang_thien_tin_mung") or {}).get(nam) or bd.get("tm", "")
        return {"bd1": bd.get("bd1",""), "bd2": bd.get("bd2",""), "tm": tang_tm,
                "ghi_chu": f"Lễ Thăng Thiên Năm {nam} (dời vào CN VII PS)"}

    # Hiển Linh VN
    if ngay == hien_linh:
        return dict(cfg.get("bai_doc_hien_linh") or {})

    # CPR VN
    if ngay == cpr_vn:
        r53 = r(53)
        bd  = r53.get(f"CN_{nam}") or r53.get("CN_A") or {}
        return {"bd1": bd.get("bd1",""), "bd2": bd.get("bd2",""), "tm": bd.get("tm",""),
                "ghi_chu": f"Lễ Chúa Giêsu Chịu Phép Rửa Năm {nam}"}

    # Giáng Sinh 25/12
    if ngay.month == 12 and ngay.day == 25:
        r29 = r(29)
        return {"bd1": r29.get("nam_le",""), "bd2": r29.get("nam_chan",""),
                "tm": r29.get("tin_mung",""), "ghi_chu": "Lễ Giáng Sinh"}

    # Thánh Gia Thất
    if ngay.month == 12 and 26 <= ngay.day <= 31 and ngay == le_tgt(y):
        bdt = (cfg.get("bai_doc_thanh_gia_that") or {}).get(nam) or {}
        return {"bd1": bdt.get("bd1",""), "bd2": bdt.get("bd2",""), "tm": bdt.get("tm",""),
                "ghi_chu": f"Lễ Thánh Gia Thất Năm {nam}"}

    # Lễ Thánh Tâm
    if ngay == le_mm + timedelta(days=5):
        r389 = r(389)
        bd   = r389.get(f"CN_{nam}") or r389.get("CN_A") or {}
        return {"bd1": bd.get("bd1",""), "bd2": bd.get("bd2",""), "tm": bd.get("tm",""),
                "ghi_chu": f"Lễ Thánh Tâm Chúa Giêsu Năm {nam}"}

    # Cuối Mùa Vọng 17-24/12 ngày thường
    if ngay.month == 12 and 17 <= ngay.day <= 24 and not la_cn:
        sk = f"12-{ngay.day:02d}"
        cv = (cfg.get("bai_doc_cuoi_vong") or {}).get(sk)
        if isinstance(cv, dict):
            return dict(cv)

    # Lễ Cầu Hồn 2/11
    if ngay.month == 11 and ngay.day == 2:
        return dict(cfg.get("bai_doc_cau_hon") or {})

    # ── id_mua ───────────────────────────────────────────────────────
    id_mua = tinh_id_mua(ngay)

    if id_mua == 0:
        ps_2016 = date(2016, 3, 27)
        npv2 = nam_phung_vu(ngay)
        ps2  = calc_easter(npv2 if npv2 <= y else y)
        delta = (ngay - ps2).days
        equiv = ps_2016 + timedelta(days=delta)
        equiv_str = equiv.strftime("%Y-%m-%d")
        info  = lich.get(equiv_str) or {}
        id_mua = int(info.get("id_mua", 0)) if info else 0

        if mua == "Mùa Thường Niên" and id_mua > 0:
            rec = ten_le.get(id_mua)
            if rec:
                bac1 = int(rec.get("BacLe1") or 0)
                ten  = rec.get("TenLe", "")
                if bac1 in (6, 13) and "Thường Niên" in ten:
                    offset = _cn_tn_truoc_chay(y) - _get_n_anchor()
                    id_mua += offset * 7

    base_id = id_mua % 1000 if id_mua >= 1000 else id_mua
    rv = r(base_id)

    # Lễ Kính Chúa cố định thắng CN TN
    if la_cn:
        sk0 = f"{ngay.month:02d}-{ngay.day:02d}"
        lk_thang = list(cfg.get("le_kinh_chua_thang_cn") or [])
        from liturgical_engine import bac_ngay_npvrm as _bac
        if sk0 in lk_thang and _bac(ngay, dd) == 6:
            for f in (saints.get(sk0) or []):   # type: ignore
                if not isinstance(f, dict): continue
                fid  = int(f.get("id", 0))
                r2   = r(fid)
                bd   = r2.get(f"CN_{nam}") or r2.get("CN_A") or {}
                return {"bd1": bd.get("bd1", r2.get("nam_le","")) ,
                        "bd2": bd.get("bd2", r2.get("nam_chan","")),
                        "tm":  bd.get("tm",  r2.get("tin_mung","")),
                        "ghi_chu": f"Lễ Kính — {f.get('ten_le','')}"}

        bd = rv.get(f"CN_{nam}") or rv.get("CN_B") or rv.get("CN_A") or {}
        return {"bd1": bd.get("bd1",""), "bd2": bd.get("bd2",""),
                "tm": bd.get("tm",""), "ghi_chu": f"Chúa Nhật Năm {nam}"}

    # Weekday
    if mua == "Mùa Thường Niên":
        bd1 = rv.get("nam_le","") if y % 2 == 1 else rv.get("nam_chan","")
        ghi_chu = f"Năm {'I lẻ' if y % 2 == 1 else 'II chẵn'}"
    else:
        bd1 = rv.get("nam_le","")
        ghi_chu = mua

    # Lễ Kính Chúa cố định (weekday)
    sk = f"{ngay.month:02d}-{ngay.day:02d}"
    lk_cd = cfg.get("le_kinh_chua_co_dinh") or {}
    if sk in lk_cd:
        v = lk_cd[sk]
        return {"bd1": v.get("bd1",""), "bd2": v.get("bd2",""),
                "tm": v.get("tm",""), "ghi_chu": "Lễ Kính — Lễ Cố Định"}

    # Saints override
    data_ref = _load_data()
    saints_ref = data_ref["saints"]
    bac_ngay = bac_ngay_npvrm(ngay, dd)
    for f in (saints_ref.get(sk) or []):
        if not isinstance(f, dict): continue
        bac_t = int(f.get("bac_le", 99))
        fid   = int(f.get("id", 0))
        r2    = r(fid)
        if bac_t < bac_ngay:
            if bac_t == 7:
                return {"bd1": r2.get("nam_le",""), "bd2": "",
                        "tm": r2.get("tin_mung",""),
                        "ghi_chu": f"Lễ Kính — {f.get('ten_le','')}"}
            elif bac_t <= 5:
                bd = r2.get("CN_A") or {}
                return {"bd1": bd.get("bd1", r2.get("nam_le","")),
                        "bd2": bd.get("bd2", r2.get("nam_chan","")),
                        "tm":  bd.get("tm",  r2.get("tin_mung","")),
                        "ghi_chu": f"Lễ Trọng — {f.get('ten_le','')}"}
        break

    return {"bd1": bd1, "bd2": "", "tm": rv.get("tin_mung",""), "ghi_chu": ghi_chu}


# ── Translation helpers ───────────────────────────────────────────────

def _translate_season(label: str, lang: str) -> str:
    if lang != "en":
        return label
    table = {
        "Mùa Vọng":        "Advent",
        "Mùa Giáng Sinh":  "Christmas Season",
        "Mùa Chay":        "Lent",
        "Mùa Phục Sinh":   "Easter Season",
        "Mùa Thường Niên": "Ordinary Time",
        "Thứ Tư Lễ Tro":  "Ash Wednesday",
    }
    for vi, en in table.items():
        label = label.replace(vi, en)
    # Tuần → Week
    label = re.sub(r"Tuần ([IVXLC]+) (.+)", r"Week \1 of \2", label)
    return label


def _translate_thu(ngay: date, lang: str) -> str:
    thu_vi = ["Thứ Hai","Thứ Ba","Thứ Tư","Thứ Năm","Thứ Sáu","Thứ Bảy","Chúa Nhật"]
    thu_en = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    return thu_en[ngay.weekday()] if lang == "en" else thu_vi[ngay.weekday()]


def _maybe_translate(text: str, lang: str) -> str:
    # Saint names: minimal translation, leave mostly as-is for vi
    return text


# ── Route ─────────────────────────────────────────────────────────────

@app.get("/api/v1/liturgical/info", response_model=LiturgicalResponse)
def liturgical_info(
    date_str: str = Query(..., alias="date", description="YYYY-MM-DD"),
    lang: str = Query("vi", description="vi | en"),
) -> LiturgicalResponse:
    """
    Trả về thông tin phụng vụ cho một ngày.
    - date: YYYY-MM-DD  (bắt buộc)
    - lang: vi (mặc định) | en
    """
    try:
        ngay = date.fromisoformat(date_str)
    except ValueError:
        raise HTTPException(status_code=400, detail="Sai định dạng date. Dùng YYYY-MM-DD.")
    if ngay.year < 1900 or ngay.year > 2100:
        raise HTTPException(status_code=400, detail="Năm ngoài phạm vi hỗ trợ (1900–2100).")
    try:
        return compute(ngay, lang=lang)
    except Exception as exc:
        raise HTTPException(status_code=500, detail=str(exc))


@app.get("/api/v1/liturgical/range", response_model=list[LiturgicalResponse])
def liturgical_range(
    start: str = Query(..., description="YYYY-MM-DD"),
    end:   str = Query(..., description="YYYY-MM-DD"),
    lang:  str = Query("vi", description="vi | en"),
) -> list[LiturgicalResponse]:
    """Trả về danh sách ngày từ start đến end (tối đa 366 ngày)."""
    try:
        d_start = date.fromisoformat(start)
        d_end   = date.fromisoformat(end)
    except ValueError:
        raise HTTPException(status_code=400, detail="Sai định dạng date. Dùng YYYY-MM-DD.")
    if (d_end - d_start).days > 366:
        raise HTTPException(status_code=400, detail="Khoảng ngày tối đa 366 ngày.")
    if d_end < d_start:
        raise HTTPException(status_code=400, detail="end phải >= start.")
    result = []
    cur = d_start
    while cur <= d_end:
        result.append(compute(cur, lang=lang))
        cur += timedelta(days=1)
    return result


@app.get("/health")
def health() -> dict:
    return {"status": "ok", "version": app.version}


# ── Dev entrypoint ────────────────────────────────────────────────────

if __name__ == "__main__":
    import uvicorn
    uvicorn.run("main:app", host="0.0.0.0", port=8000, reload=True)
