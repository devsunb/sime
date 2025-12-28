import Foundation

/// 두벌식 키보드 레이아웃 데이터
enum DubeolLayout {
    /// Shift 키로 쌍자음 입력하는 초성 레이아웃
    static let shiftChosungLayout: [String: Chosung] = [
        "Q": Chosung.SsBiep,
        "W": Chosung.SsJiek,
        "E": Chosung.SsDigek,
        "R": Chosung.SsGiyuk,
        "T": Chosung.SsSiot,

        "q": Chosung.Biep,
        "w": Chosung.Jiek,
        "e": Chosung.Digek,
        "r": Chosung.Giyuk,
        "t": Chosung.Siot,

        "a": Chosung.Miem, "A": Chosung.Miem,
        "s": Chosung.Nien, "S": Chosung.Nien,
        "d": Chosung.Yieng, "D": Chosung.Yieng,
        "f": Chosung.Riel, "F": Chosung.Riel,
        "g": Chosung.Hiek, "G": Chosung.Hiek,

        "z": Chosung.Kiyuk, "Z": Chosung.Kiyuk,
        "x": Chosung.Tigek, "X": Chosung.Tigek,
        "c": Chosung.Chiek, "C": Chosung.Chiek,
        "v": Chosung.Piep, "V": Chosung.Piep,
    ]

    /// 연타로 쌍자음 입력하는 초성 레이아웃
    static let noShiftChosungLayout: [String: Chosung] = [
        "Q": Chosung.SsBiep, "qq": Chosung.SsBiep,
        "W": Chosung.SsJiek, "ww": Chosung.SsJiek,
        "E": Chosung.SsDigek, "ee": Chosung.SsDigek,
        "R": Chosung.SsGiyuk, "rr": Chosung.SsGiyuk,
        "T": Chosung.SsSiot, "tt": Chosung.SsSiot,

        "q": Chosung.Biep,
        "w": Chosung.Jiek,
        "e": Chosung.Digek,
        "r": Chosung.Giyuk,
        "t": Chosung.Siot,

        "a": Chosung.Miem, "A": Chosung.Miem,
        "s": Chosung.Nien, "S": Chosung.Nien,
        "d": Chosung.Yieng, "D": Chosung.Yieng,
        "f": Chosung.Riel, "F": Chosung.Riel,
        "g": Chosung.Hiek, "G": Chosung.Hiek,

        "z": Chosung.Kiyuk, "Z": Chosung.Kiyuk,
        "x": Chosung.Tigek, "X": Chosung.Tigek,
        "c": Chosung.Chiek, "C": Chosung.Chiek,
        "v": Chosung.Piep, "V": Chosung.Piep,
    ]

    /// 중성 레이아웃
    static let jungsungLayout: [String: Jungsung] = [
        "O": Jungsung.Yae, "oo": Jungsung.Yae,
        "P": Jungsung.Ye, "pp": Jungsung.Ye,

        "y": Jungsung.Yo, "Y": Jungsung.Yo,
        "u": Jungsung.Yeo, "U": Jungsung.Yeo,
        "i": Jungsung.Ya, "I": Jungsung.Ya,
        "o": Jungsung.Ae,
        "p": Jungsung.E,

        "h": Jungsung.O, "H": Jungsung.O,
        "j": Jungsung.Eo, "J": Jungsung.Eo,
        "k": Jungsung.A, "K": Jungsung.A,
        "l": Jungsung.I, "L": Jungsung.I,

        "b": Jungsung.Yu, "B": Jungsung.Yu,
        "n": Jungsung.U, "N": Jungsung.U,
        "m": Jungsung.Eu, "M": Jungsung.Eu,

        "hk": Jungsung.Wa, "Hk": Jungsung.Wa, "HK": Jungsung.Wa,
        "ho": Jungsung.Wae, "Ho": Jungsung.Wae, "HO": Jungsung.Wae,
        "nj": Jungsung.Weo, "Nj": Jungsung.Weo, "NJ": Jungsung.Weo,
        "np": Jungsung.We, "Np": Jungsung.We, "NP": Jungsung.We,
        "hl": Jungsung.Oe, "Hl": Jungsung.Oe, "HL": Jungsung.Oe,
        "nl": Jungsung.Wi, "Nl": Jungsung.Wi, "NL": Jungsung.Wi,
        "ml": Jungsung.Yi, "Ml": Jungsung.Yi, "ML": Jungsung.Yi,
    ]

    /// 종성 레이아웃: 연타로 쌍자음 가능
    static let jongsungLayout: [String: Jongsung] = [
        "r": Jongsung.Kiyeok,
        "R": Jongsung.Ssangkiyeok, "rr": Jongsung.Ssangkiyeok,
        "rt": Jongsung.Kiyeoksios,
        "s": Jongsung.Nieun, "S": Jongsung.Nieun,
        "sw": Jongsung.Nieuncieuc, "Sw": Jongsung.Nieuncieuc, "SW": Jongsung.Nieuncieuc,
        "sg": Jongsung.Nieunhieuh, "Sg": Jongsung.Nieunhieuh, "SG": Jongsung.Nieunhieuh,
        "e": Jongsung.Tikeut, "E": Jongsung.Tikeut,
        "f": Jongsung.Rieul, "F": Jongsung.Rieul,
        "fr": Jongsung.Rieulkiyeok, "Fr": Jongsung.Rieulkiyeok, "FR": Jongsung.Rieulkiyeok,
        "fa": Jongsung.Rieulmieum, "Fa": Jongsung.Rieulmieum, "FA": Jongsung.Rieulmieum,
        "fq": Jongsung.Rieulpieup, "Fq": Jongsung.Rieulpieup, "FQ": Jongsung.Rieulpieup,
        "ft": Jongsung.Rieulsios, "Ft": Jongsung.Rieulsios, "FT": Jongsung.Rieulsios,
        "fx": Jongsung.Rieulthieuth, "Fx": Jongsung.Rieulthieuth, "FX": Jongsung.Rieulthieuth,
        "fv": Jongsung.Rieulphieuph, "Fv": Jongsung.Rieulphieuph, "FV": Jongsung.Rieulphieuph,
        "fg": Jongsung.Rieulhieuh, "Fg": Jongsung.Rieulhieuh, "FG": Jongsung.Rieulhieuh,
        "a": Jongsung.Mieum, "A": Jongsung.Mieum,
        "q": Jongsung.Pieup, "Q": Jongsung.Pieup,
        "qt": Jongsung.Pieupsios, "Qt": Jongsung.Pieupsios, "QT": Jongsung.Pieupsios,
        "t": Jongsung.Sios,
        "T": Jongsung.Ssangsios, "tt": Jongsung.Ssangsios,
        "d": Jongsung.Ieung, "D": Jongsung.Ieung,
        "w": Jongsung.Cieuc, "W": Jongsung.Cieuc,
        "c": Jongsung.Chieuch, "C": Jongsung.Chieuch,
        "z": Jongsung.Khieukh, "Z": Jongsung.Khieukh,
        "x": Jongsung.Thieuth, "X": Jongsung.Thieuth,
        "v": Jongsung.Phieuph, "V": Jongsung.Phieuph,
        "g": Jongsung.Hieuh, "G": Jongsung.Hieuh,
    ]

    /// 연타로 종성 쌍자음을 입력할 수 있는 키
    static let doubleConsonantKeys: Set<String> = ["r", "t"]

    /// 종성 쌍자음 키
    static let doubleConsonantJongsungKeys: Set<String> = ["rr", "tt"]
}
