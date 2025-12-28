import XCTest

final class HangulCharacterTests: XCTestCase {

    // MARK: - Chosung Tests

    func testChosungRawValues() {
        // 현대 한글 초성 유니코드 범위: 0x1100 ~ 0x1112
        XCTAssertEqual(Chosung.Giyuk.rawValue, 0x1100)
        XCTAssertEqual(Chosung.SsGiyuk.rawValue, 0x1101)
        XCTAssertEqual(Chosung.Nien.rawValue, 0x1102)
        XCTAssertEqual(Chosung.Digek.rawValue, 0x1103)
        XCTAssertEqual(Chosung.SsDigek.rawValue, 0x1104)
        XCTAssertEqual(Chosung.Riel.rawValue, 0x1105)
        XCTAssertEqual(Chosung.Miem.rawValue, 0x1106)
        XCTAssertEqual(Chosung.Biep.rawValue, 0x1107)
        XCTAssertEqual(Chosung.SsBiep.rawValue, 0x1108)
        XCTAssertEqual(Chosung.Siot.rawValue, 0x1109)
        XCTAssertEqual(Chosung.SsSiot.rawValue, 0x110a)
        XCTAssertEqual(Chosung.Yieng.rawValue, 0x110b)
        XCTAssertEqual(Chosung.Jiek.rawValue, 0x110c)
        XCTAssertEqual(Chosung.SsJiek.rawValue, 0x110d)
        XCTAssertEqual(Chosung.Chiek.rawValue, 0x110e)
        XCTAssertEqual(Chosung.Kiyuk.rawValue, 0x110f)
        XCTAssertEqual(Chosung.Tigek.rawValue, 0x1110)
        XCTAssertEqual(Chosung.Piep.rawValue, 0x1111)
        XCTAssertEqual(Chosung.Hiek.rawValue, 0x1112)
    }

    // MARK: - Jungsung Tests

    func testJungsungRawValues() {
        // 현대 한글 중성 유니코드 범위: 0x1161 ~ 0x1175
        XCTAssertEqual(Jungsung.A.rawValue, 0x1161)
        XCTAssertEqual(Jungsung.Ae.rawValue, 0x1162)
        XCTAssertEqual(Jungsung.Ya.rawValue, 0x1163)
        XCTAssertEqual(Jungsung.Yae.rawValue, 0x1164)
        XCTAssertEqual(Jungsung.Eo.rawValue, 0x1165)
        XCTAssertEqual(Jungsung.E.rawValue, 0x1166)
        XCTAssertEqual(Jungsung.Yeo.rawValue, 0x1167)
        XCTAssertEqual(Jungsung.Ye.rawValue, 0x1168)
        XCTAssertEqual(Jungsung.O.rawValue, 0x1169)
        XCTAssertEqual(Jungsung.Wa.rawValue, 0x116a)
        XCTAssertEqual(Jungsung.Wae.rawValue, 0x116b)
        XCTAssertEqual(Jungsung.Oe.rawValue, 0x116c)
        XCTAssertEqual(Jungsung.Yo.rawValue, 0x116d)
        XCTAssertEqual(Jungsung.U.rawValue, 0x116e)
        XCTAssertEqual(Jungsung.Weo.rawValue, 0x116f)
        XCTAssertEqual(Jungsung.We.rawValue, 0x1170)
        XCTAssertEqual(Jungsung.Wi.rawValue, 0x1171)
        XCTAssertEqual(Jungsung.Yu.rawValue, 0x1172)
        XCTAssertEqual(Jungsung.Eu.rawValue, 0x1173)
        XCTAssertEqual(Jungsung.Yi.rawValue, 0x1174)
        XCTAssertEqual(Jungsung.I.rawValue, 0x1175)
    }

    // MARK: - Jongsung Tests

    func testJongsungRawValues() {
        // 현대 한글 종성 유니코드 범위: 0x11a8 ~ 0x11c2
        XCTAssertEqual(Jongsung.Kiyeok.rawValue, 0x11a8)
        XCTAssertEqual(Jongsung.Ssangkiyeok.rawValue, 0x11a9)
        XCTAssertEqual(Jongsung.Kiyeoksios.rawValue, 0x11aa)
        XCTAssertEqual(Jongsung.Nieun.rawValue, 0x11ab)
        XCTAssertEqual(Jongsung.Nieuncieuc.rawValue, 0x11ac)
        XCTAssertEqual(Jongsung.Nieunhieuh.rawValue, 0x11ad)
        XCTAssertEqual(Jongsung.Tikeut.rawValue, 0x11ae)
        XCTAssertEqual(Jongsung.Rieul.rawValue, 0x11af)
        XCTAssertEqual(Jongsung.Rieulkiyeok.rawValue, 0x11b0)
        XCTAssertEqual(Jongsung.Rieulmieum.rawValue, 0x11b1)
        XCTAssertEqual(Jongsung.Rieulpieup.rawValue, 0x11b2)
        XCTAssertEqual(Jongsung.Rieulsios.rawValue, 0x11b3)
        XCTAssertEqual(Jongsung.Rieulthieuth.rawValue, 0x11b4)
        XCTAssertEqual(Jongsung.Rieulphieuph.rawValue, 0x11b5)
        XCTAssertEqual(Jongsung.Rieulhieuh.rawValue, 0x11b6)
        XCTAssertEqual(Jongsung.Mieum.rawValue, 0x11b7)
        XCTAssertEqual(Jongsung.Pieup.rawValue, 0x11b8)
        XCTAssertEqual(Jongsung.Pieupsios.rawValue, 0x11b9)
        XCTAssertEqual(Jongsung.Sios.rawValue, 0x11ba)
        XCTAssertEqual(Jongsung.Ssangsios.rawValue, 0x11bb)
        XCTAssertEqual(Jongsung.Ieung.rawValue, 0x11bc)
        XCTAssertEqual(Jongsung.Cieuc.rawValue, 0x11bd)
        XCTAssertEqual(Jongsung.Chieuch.rawValue, 0x11be)
        XCTAssertEqual(Jongsung.Khieukh.rawValue, 0x11bf)
        XCTAssertEqual(Jongsung.Thieuth.rawValue, 0x11c0)
        XCTAssertEqual(Jongsung.Phieuph.rawValue, 0x11c1)
        XCTAssertEqual(Jongsung.Hieuh.rawValue, 0x11c2)
    }

    // MARK: - Hohwan Mapping Tests

    func testChosungHohwanMapping() {
        // 초성 -> 호환 자모 매핑 테스트
        XCTAssertEqual(ChosungHohwanMap[Chosung.Giyuk], Hohwan.KIYEOK)
        XCTAssertEqual(ChosungHohwanMap[Chosung.SsGiyuk], Hohwan.SSANGKIYEOK)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Nien], Hohwan.NIEUN)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Digek], Hohwan.TIKEUT)
        XCTAssertEqual(ChosungHohwanMap[Chosung.SsDigek], Hohwan.SSANGTIKEUT)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Riel], Hohwan.RIEUL)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Miem], Hohwan.MIEUM)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Biep], Hohwan.PIEUP)
        XCTAssertEqual(ChosungHohwanMap[Chosung.SsBiep], Hohwan.SSANGPIEUP)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Siot], Hohwan.SIOS)
        XCTAssertEqual(ChosungHohwanMap[Chosung.SsSiot], Hohwan.SSANGSIOS)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Yieng], Hohwan.IEUNG)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Jiek], Hohwan.CIEUC)
        XCTAssertEqual(ChosungHohwanMap[Chosung.SsJiek], Hohwan.SSANGCIEUC)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Chiek], Hohwan.CHIEUCH)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Kiyuk], Hohwan.KHIEUKH)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Tigek], Hohwan.THIEUTH)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Piep], Hohwan.PHIEUPH)
        XCTAssertEqual(ChosungHohwanMap[Chosung.Hiek], Hohwan.HIEUH)
    }

    func testJungsungHohwanMapping() {
        // 중성 -> 호환 자모 매핑 테스트
        XCTAssertEqual(JungsungHohwanMap[Jungsung.A], Hohwan.A)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Ae], Hohwan.AE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Ya], Hohwan.YA)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Yae], Hohwan.YAE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Eo], Hohwan.EO)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.E], Hohwan.E)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Yeo], Hohwan.YEO)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Ye], Hohwan.YE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.O], Hohwan.O)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Wa], Hohwan.WA)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Wae], Hohwan.WAE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Oe], Hohwan.OE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Yo], Hohwan.YO)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.U], Hohwan.U)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Weo], Hohwan.WEO)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.We], Hohwan.WE)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Wi], Hohwan.WI)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Yu], Hohwan.YU)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Eu], Hohwan.EU)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.Yi], Hohwan.YI)
        XCTAssertEqual(JungsungHohwanMap[Jungsung.I], Hohwan.I)
    }

    func testJongsungHohwanMapping() {
        // 종성 -> 호환 자모 매핑 테스트
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Kiyeok], Hohwan.KIYEOK)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Ssangkiyeok], Hohwan.SSANGKIYEOK)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Kiyeoksios], Hohwan.KIYEOK_SIOS)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Nieun], Hohwan.NIEUN)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Nieuncieuc], Hohwan.NIEUN_CIEUC)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Nieunhieuh], Hohwan.NIEUN_HIEUH)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Tikeut], Hohwan.TIKEUT)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Rieul], Hohwan.RIEUL)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Mieum], Hohwan.MIEUM)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Pieup], Hohwan.PIEUP)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Pieupsios], Hohwan.PIEUP_SIOS)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Sios], Hohwan.SIOS)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Ssangsios], Hohwan.SSANGSIOS)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Ieung], Hohwan.IEUNG)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Cieuc], Hohwan.CIEUC)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Chieuch], Hohwan.CHIEUCH)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Khieukh], Hohwan.KHIEUKH)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Thieuth], Hohwan.THIEUTH)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Phieuph], Hohwan.PHIEUPH)
        XCTAssertEqual(JongsungHohwanMap[Jongsung.Hieuh], Hohwan.HIEUH)
    }

    // MARK: - Hohwan Raw Value Tests

    func testHohwanConsonantRawValues() {
        // 한글 호환 자모 자음 범위: 0x3131 ~ 0x314E
        XCTAssertEqual(Hohwan.KIYEOK.rawValue, 0x3131)
        XCTAssertEqual(Hohwan.SSANGKIYEOK.rawValue, 0x3132)
        XCTAssertEqual(Hohwan.NIEUN.rawValue, 0x3134)
        XCTAssertEqual(Hohwan.TIKEUT.rawValue, 0x3137)
        XCTAssertEqual(Hohwan.SSANGTIKEUT.rawValue, 0x3138)
        XCTAssertEqual(Hohwan.RIEUL.rawValue, 0x3139)
        XCTAssertEqual(Hohwan.MIEUM.rawValue, 0x3141)
        XCTAssertEqual(Hohwan.PIEUP.rawValue, 0x3142)
        XCTAssertEqual(Hohwan.SSANGPIEUP.rawValue, 0x3143)
        XCTAssertEqual(Hohwan.SIOS.rawValue, 0x3145)
        XCTAssertEqual(Hohwan.SSANGSIOS.rawValue, 0x3146)
        XCTAssertEqual(Hohwan.IEUNG.rawValue, 0x3147)
        XCTAssertEqual(Hohwan.CIEUC.rawValue, 0x3148)
        XCTAssertEqual(Hohwan.SSANGCIEUC.rawValue, 0x3149)
        XCTAssertEqual(Hohwan.CHIEUCH.rawValue, 0x314a)
        XCTAssertEqual(Hohwan.KHIEUKH.rawValue, 0x314b)
        XCTAssertEqual(Hohwan.THIEUTH.rawValue, 0x314c)
        XCTAssertEqual(Hohwan.PHIEUPH.rawValue, 0x314d)
        XCTAssertEqual(Hohwan.HIEUH.rawValue, 0x314e)
    }

    func testHohwanVowelRawValues() {
        // 한글 호환 자모 모음 범위: 0x314F ~ 0x3163
        XCTAssertEqual(Hohwan.A.rawValue, 0x314f)
        XCTAssertEqual(Hohwan.AE.rawValue, 0x3150)
        XCTAssertEqual(Hohwan.YA.rawValue, 0x3151)
        XCTAssertEqual(Hohwan.YAE.rawValue, 0x3152)
        XCTAssertEqual(Hohwan.EO.rawValue, 0x3153)
        XCTAssertEqual(Hohwan.E.rawValue, 0x3154)
        XCTAssertEqual(Hohwan.YEO.rawValue, 0x3155)
        XCTAssertEqual(Hohwan.YE.rawValue, 0x3156)
        XCTAssertEqual(Hohwan.O.rawValue, 0x3157)
        XCTAssertEqual(Hohwan.WA.rawValue, 0x3158)
        XCTAssertEqual(Hohwan.WAE.rawValue, 0x3159)
        XCTAssertEqual(Hohwan.OE.rawValue, 0x315a)
        XCTAssertEqual(Hohwan.YO.rawValue, 0x315b)
        XCTAssertEqual(Hohwan.U.rawValue, 0x315c)
        XCTAssertEqual(Hohwan.WEO.rawValue, 0x315d)
        XCTAssertEqual(Hohwan.WE.rawValue, 0x315e)
        XCTAssertEqual(Hohwan.WI.rawValue, 0x315f)
        XCTAssertEqual(Hohwan.YU.rawValue, 0x3160)
        XCTAssertEqual(Hohwan.EU.rawValue, 0x3161)
        XCTAssertEqual(Hohwan.YI.rawValue, 0x3162)
        XCTAssertEqual(Hohwan.I.rawValue, 0x3163)
    }
}
