import Foundation

/// 세모이 키보드 레이아웃 데이터
enum SemoiLayout {
    /// 초성 레이아웃
    static let chosungLayout: [String: Chosung] = [
        "k": Chosung.Giyuk,
        "kj": Chosung.SsGiyuk, "jk": Chosung.SsGiyuk,
        "u": Chosung.Nien,
        "i": Chosung.Digek,
        "ij": Chosung.SsDigek, "ji": Chosung.SsDigek,
        "m": Chosung.Riel,
        "y": Chosung.Miem,
        "o": Chosung.Biep,
        "oj": Chosung.SsBiep, "jo": Chosung.SsBiep,
        "n": Chosung.Siot,
        "nj": Chosung.SsSiot, "jn": Chosung.SsSiot,
        "j": Chosung.Yieng,
        "l": Chosung.Jiek,
        "lj": Chosung.SsJiek, "jl": Chosung.SsJiek,
        "lh": Chosung.Chiek, "hl": Chosung.Chiek,
        "ih": Chosung.Tigek, "hi": Chosung.Tigek,
        "kh": Chosung.Kiyuk, "hk": Chosung.Kiyuk,
        "oh": Chosung.Piep, "ho": Chosung.Piep,
        "h": Chosung.Hiek,
    ]

    /// 중성 레이아웃
    static let jungsungLayout: [String: Jungsung] = [
        "f": Jungsung.A,
        "fd": Jungsung.Ae, "df": Jungsung.Ae,
        "gv": Jungsung.Ya, "vg": Jungsung.Ya, "g.": Jungsung.Ya, ".g": Jungsung.Ya,
        "tv": Jungsung.Yae, "vt": Jungsung.Yae, "t.": Jungsung.Yae, ".t": Jungsung.Yae,
        "r": Jungsung.Eo,
        "c": Jungsung.E,
        "t": Jungsung.Yeo,
        "cv": Jungsung.Ye, "vc": Jungsung.Ye, "c.": Jungsung.Ye, ".c": Jungsung.Ye,
        "v": Jungsung.O, ".": Jungsung.O,
        "vf": Jungsung.Wa, "fv": Jungsung.Wa, ".f": Jungsung.Wa, "f.": Jungsung.Wa,
        "vfd": Jungsung.Wae, "vdf": Jungsung.Wae, "fvd": Jungsung.Wae, "fdv": Jungsung.Wae,
        "dvf": Jungsung.Wae, "dfv": Jungsung.Wae, ".fd": Jungsung.Wae, ".df": Jungsung.Wae,
        "f.d": Jungsung.Wae, "fd.": Jungsung.Wae, "d.f": Jungsung.Wae, "df.": Jungsung.Wae,
        "vd": Jungsung.Oe, "dv": Jungsung.Oe, ".d": Jungsung.Oe, "d.": Jungsung.Oe,
        "v.": Jungsung.Yo, ".v": Jungsung.Yo, "fr": Jungsung.Yo, "rf": Jungsung.Yo,
        "b": Jungsung.U,
        "rb": Jungsung.Weo, "br": Jungsung.Weo, "rv": Jungsung.Weo, "vr": Jungsung.Weo,
        "r.": Jungsung.Weo, ".r": Jungsung.Weo,
        "bc": Jungsung.We, "cb": Jungsung.We,
        "bd": Jungsung.Wi, "db": Jungsung.Wi,
        "bv": Jungsung.Yu, "vb": Jungsung.Yu, "b.": Jungsung.Yu, ".b": Jungsung.Yu,
        "g": Jungsung.Eu,
        "gd": Jungsung.Yi, "dg": Jungsung.Yi,
        "d": Jungsung.I,
    ]

    /// 종성 레이아웃
    static let jongsungLayout: [String: Jongsung] = [
        "x": Jongsung.Kiyeok,
        "xa": Jongsung.Ssangkiyeok, "ax": Jongsung.Ssangkiyeok,
        "xq": Jongsung.Kiyeoksios, "qx": Jongsung.Kiyeoksios,
        "s": Jongsung.Nieun,
        "sa": Jongsung.Nieunhieuh, "as": Jongsung.Nieunhieuh,
        "se": Jongsung.Nieuncieuc, "es": Jongsung.Nieuncieuc,
        "sz": Jongsung.Thieuth, "zs": Jongsung.Thieuth,
        "e": Jongsung.Rieul,
        "eq": Jongsung.Rieulsios, "qe": Jongsung.Rieulsios,
        "ew": Jongsung.Rieulpieup, "we": Jongsung.Rieulpieup,
        "ex": Jongsung.Rieulkiyeok, "xe": Jongsung.Rieulkiyeok,
        "ez": Jongsung.Rieulmieum, "ze": Jongsung.Rieulmieum,
        "az": Jongsung.Rieulthieuth, "za": Jongsung.Rieulthieuth,
        "aw": Jongsung.Rieulphieuph, "wa": Jongsung.Rieulphieuph,
        "a;": Jongsung.Rieulhieuh, ";a": Jongsung.Rieulhieuh,
        "z": Jongsung.Mieum,
        "w": Jongsung.Pieup,
        "wq": Jongsung.Pieupsios, "qw": Jongsung.Pieupsios,
        "q": Jongsung.Sios,
        "qa": Jongsung.Ssangsios, "aq": Jongsung.Ssangsios, ";": Jongsung.Ssangsios,
        "a": Jongsung.Ieung,
        "e;": Jongsung.Cieuc, ";e": Jongsung.Cieuc,
        "q;": Jongsung.Chieuch, ";q": Jongsung.Chieuch,
        "x;": Jongsung.Khieukh, ";x": Jongsung.Khieukh,
        "z;": Jongsung.Tikeut, ";z": Jongsung.Tikeut,
        "w;": Jongsung.Phieuph, ";w": Jongsung.Phieuph,
        "s;": Jongsung.Hieuh, ";s": Jongsung.Hieuh,
    ]

    /// 기타 기호, 숫자 레이아웃
    static let etcLayout: [String: String] = [
        "p": ";",
        "P": ":",
        "L": ".",
    ]
}
