import XCTest

final class KeyboardSemoiTests: XCTestCase {

    var keyboard: KeyboardSemoi!

    override func setUp() {
        super.setUp()
        keyboard = KeyboardSemoi()
    }

    override func tearDown() {
        keyboard = nil
        super.tearDown()
    }

    // MARK: - Layout Tests

    func testKeyboardName() {
        XCTAssertEqual(keyboard.name, "세모이")
    }

    // MARK: - Chosung Layout Tests

    func testChosungLayoutBasic() {
        // 기본 초성
        XCTAssertEqual(keyboard.chosungLayout["k"], Chosung.Giyuk)   // ㄱ
        XCTAssertEqual(keyboard.chosungLayout["u"], Chosung.Nien)   // ㄴ
        XCTAssertEqual(keyboard.chosungLayout["i"], Chosung.Digek)  // ㄷ
        XCTAssertEqual(keyboard.chosungLayout["m"], Chosung.Riel)   // ㄹ
        XCTAssertEqual(keyboard.chosungLayout["y"], Chosung.Miem)   // ㅁ
        XCTAssertEqual(keyboard.chosungLayout["o"], Chosung.Biep)   // ㅂ
        XCTAssertEqual(keyboard.chosungLayout["n"], Chosung.Siot)   // ㅅ
        XCTAssertEqual(keyboard.chosungLayout["j"], Chosung.Yieng)  // ㅇ
        XCTAssertEqual(keyboard.chosungLayout["l"], Chosung.Jiek)   // ㅈ
        XCTAssertEqual(keyboard.chosungLayout["h"], Chosung.Hiek)   // ㅎ
    }

    func testChosungLayoutDouble() {
        // 쌍자음 (초성 + ㅇ 조합)
        XCTAssertEqual(keyboard.chosungLayout["kj"], Chosung.SsGiyuk)  // ㄲ
        XCTAssertEqual(keyboard.chosungLayout["jk"], Chosung.SsGiyuk)  // ㄲ (순서 무관)
        XCTAssertEqual(keyboard.chosungLayout["ij"], Chosung.SsDigek)  // ㄸ
        XCTAssertEqual(keyboard.chosungLayout["ji"], Chosung.SsDigek)  // ㄸ
        XCTAssertEqual(keyboard.chosungLayout["oj"], Chosung.SsBiep)   // ㅃ
        XCTAssertEqual(keyboard.chosungLayout["jo"], Chosung.SsBiep)   // ㅃ
        XCTAssertEqual(keyboard.chosungLayout["nj"], Chosung.SsSiot)   // ㅆ
        XCTAssertEqual(keyboard.chosungLayout["jn"], Chosung.SsSiot)   // ㅆ
        XCTAssertEqual(keyboard.chosungLayout["lj"], Chosung.SsJiek)   // ㅉ
        XCTAssertEqual(keyboard.chosungLayout["jl"], Chosung.SsJiek)   // ㅉ
    }

    func testChosungLayoutAspirated() {
        // 거센소리 (기본 + ㅎ 조합)
        XCTAssertEqual(keyboard.chosungLayout["lh"], Chosung.Chiek)  // ㅊ
        XCTAssertEqual(keyboard.chosungLayout["hl"], Chosung.Chiek)  // ㅊ
        XCTAssertEqual(keyboard.chosungLayout["ih"], Chosung.Tigek)  // ㅌ
        XCTAssertEqual(keyboard.chosungLayout["hi"], Chosung.Tigek)  // ㅌ
        XCTAssertEqual(keyboard.chosungLayout["kh"], Chosung.Kiyuk)  // ㅋ
        XCTAssertEqual(keyboard.chosungLayout["hk"], Chosung.Kiyuk)  // ㅋ
        XCTAssertEqual(keyboard.chosungLayout["oh"], Chosung.Piep)   // ㅍ
        XCTAssertEqual(keyboard.chosungLayout["ho"], Chosung.Piep)   // ㅍ
    }

    // MARK: - Jungsung Layout Tests

    func testJungsungLayoutBasic() {
        // 기본 모음
        XCTAssertEqual(keyboard.jungsungLayout["f"], Jungsung.A)   // ㅏ
        XCTAssertEqual(keyboard.jungsungLayout["r"], Jungsung.Eo)  // ㅓ
        XCTAssertEqual(keyboard.jungsungLayout["c"], Jungsung.E)   // ㅔ
        XCTAssertEqual(keyboard.jungsungLayout["t"], Jungsung.Yeo) // ㅕ
        XCTAssertEqual(keyboard.jungsungLayout["v"], Jungsung.O)   // ㅗ
        XCTAssertEqual(keyboard.jungsungLayout["."], Jungsung.O)   // ㅗ (대체 키)
        XCTAssertEqual(keyboard.jungsungLayout["b"], Jungsung.U)   // ㅜ
        XCTAssertEqual(keyboard.jungsungLayout["g"], Jungsung.Eu)  // ㅡ
        XCTAssertEqual(keyboard.jungsungLayout["d"], Jungsung.I)   // ㅣ
    }

    func testJungsungLayoutComplex() {
        // 복합 모음 (순서 무관 - 모아치기)
        XCTAssertEqual(keyboard.jungsungLayout["fd"], Jungsung.Ae)   // ㅐ
        XCTAssertEqual(keyboard.jungsungLayout["df"], Jungsung.Ae)   // ㅐ
        XCTAssertEqual(keyboard.jungsungLayout["gv"], Jungsung.Ya)   // ㅑ
        XCTAssertEqual(keyboard.jungsungLayout["vg"], Jungsung.Ya)   // ㅑ
        XCTAssertEqual(keyboard.jungsungLayout["vf"], Jungsung.Wa)   // ㅘ
        XCTAssertEqual(keyboard.jungsungLayout["fv"], Jungsung.Wa)   // ㅘ
        XCTAssertEqual(keyboard.jungsungLayout["rb"], Jungsung.Weo)  // ㅝ
        XCTAssertEqual(keyboard.jungsungLayout["br"], Jungsung.Weo)  // ㅝ
        XCTAssertEqual(keyboard.jungsungLayout["gd"], Jungsung.Yi)   // ㅢ
        XCTAssertEqual(keyboard.jungsungLayout["dg"], Jungsung.Yi)   // ㅢ
    }

    func testJungsungLayoutYo() {
        // ㅛ (여러 조합)
        XCTAssertEqual(keyboard.jungsungLayout["v."], Jungsung.Yo)  // ㅛ
        XCTAssertEqual(keyboard.jungsungLayout[".v"], Jungsung.Yo)  // ㅛ
        XCTAssertEqual(keyboard.jungsungLayout["fr"], Jungsung.Yo)  // ㅛ
        XCTAssertEqual(keyboard.jungsungLayout["rf"], Jungsung.Yo)  // ㅛ
    }

    // MARK: - Jongsung Layout Tests

    func testJongsungLayoutBasic() {
        // 기본 종성
        XCTAssertEqual(keyboard.jongsungLayout["x"], Jongsung.Kiyeok)  // ㄱ
        XCTAssertEqual(keyboard.jongsungLayout["s"], Jongsung.Nieun)   // ㄴ
        XCTAssertEqual(keyboard.jongsungLayout["e"], Jongsung.Rieul)   // ㄹ
        XCTAssertEqual(keyboard.jongsungLayout["z"], Jongsung.Mieum)   // ㅁ
        XCTAssertEqual(keyboard.jongsungLayout["w"], Jongsung.Pieup)   // ㅂ
        XCTAssertEqual(keyboard.jongsungLayout["q"], Jongsung.Sios)    // ㅅ
        XCTAssertEqual(keyboard.jongsungLayout["a"], Jongsung.Ieung)   // ㅇ
    }

    func testJongsungLayoutDouble() {
        // 쌍종성
        XCTAssertEqual(keyboard.jongsungLayout["xa"], Jongsung.Ssangkiyeok)  // ㄲ
        XCTAssertEqual(keyboard.jongsungLayout["ax"], Jongsung.Ssangkiyeok)  // ㄲ
        XCTAssertEqual(keyboard.jongsungLayout["qa"], Jongsung.Ssangsios)    // ㅆ
        XCTAssertEqual(keyboard.jongsungLayout["aq"], Jongsung.Ssangsios)    // ㅆ
        XCTAssertEqual(keyboard.jongsungLayout[";"], Jongsung.Ssangsios)     // ㅆ (단일 키)
    }

    func testJongsungLayoutComplex() {
        // 겹받침
        XCTAssertEqual(keyboard.jongsungLayout["xq"], Jongsung.Kiyeoksios)   // ㄳ
        XCTAssertEqual(keyboard.jongsungLayout["qx"], Jongsung.Kiyeoksios)   // ㄳ
        XCTAssertEqual(keyboard.jongsungLayout["eq"], Jongsung.Rieulsios)    // ㄽ
        XCTAssertEqual(keyboard.jongsungLayout["qe"], Jongsung.Rieulsios)    // ㄽ
        XCTAssertEqual(keyboard.jongsungLayout["ew"], Jongsung.Rieulpieup)   // ㄼ
        XCTAssertEqual(keyboard.jongsungLayout["we"], Jongsung.Rieulpieup)   // ㄼ
        XCTAssertEqual(keyboard.jongsungLayout["ex"], Jongsung.Rieulkiyeok)  // ㄺ
        XCTAssertEqual(keyboard.jongsungLayout["xe"], Jongsung.Rieulkiyeok)  // ㄺ
    }

    func testJongsungLayoutWithSemicolon() {
        // 세미콜론(;)을 사용한 종성
        XCTAssertEqual(keyboard.jongsungLayout["e;"], Jongsung.Cieuc)    // ㅈ
        XCTAssertEqual(keyboard.jongsungLayout[";e"], Jongsung.Cieuc)    // ㅈ
        XCTAssertEqual(keyboard.jongsungLayout["q;"], Jongsung.Chieuch)  // ㅊ
        XCTAssertEqual(keyboard.jongsungLayout[";q"], Jongsung.Chieuch)  // ㅊ
        XCTAssertEqual(keyboard.jongsungLayout["x;"], Jongsung.Khieukh)  // ㅋ
        XCTAssertEqual(keyboard.jongsungLayout[";x"], Jongsung.Khieukh)  // ㅋ
    }

    // MARK: - Etc Layout Tests

    func testEtcLayout() {
        XCTAssertEqual(keyboard.etcLayout["p"], ";")
        XCTAssertEqual(keyboard.etcLayout["P"], ":")
        XCTAssertEqual(keyboard.etcLayout["L"], ".")
    }

    // MARK: - isHangul Tests

    func testIsHangulChosung() {
        XCTAssertTrue(keyboard.isHangul("k"))  // ㄱ
        XCTAssertTrue(keyboard.isHangul("u"))  // ㄴ
        XCTAssertTrue(keyboard.isHangul("h"))  // ㅎ
    }

    func testIsHangulJungsung() {
        XCTAssertTrue(keyboard.isHangul("f"))  // ㅏ
        XCTAssertTrue(keyboard.isHangul("d"))  // ㅣ
        XCTAssertTrue(keyboard.isHangul("g"))  // ㅡ
        XCTAssertTrue(keyboard.isHangul("v"))  // ㅗ
        XCTAssertTrue(keyboard.isHangul("."))  // ㅗ
    }

    func testIsHangulJongsung() {
        XCTAssertTrue(keyboard.isHangul("x"))  // ㄱ (종성)
        XCTAssertTrue(keyboard.isHangul("s"))  // ㄴ (종성)
        XCTAssertTrue(keyboard.isHangul("e"))  // ㄹ (종성)
    }

    func testIsHangulNonHangul() {
        XCTAssertFalse(keyboard.isHangul("1"))
        XCTAssertFalse(keyboard.isHangul("2"))
        XCTAssertFalse(keyboard.isHangul(" "))
    }

    // MARK: - Abbreviation Tests

    func testAbbreviationsExist() {
        XCTAssertFalse(keyboard.abbreviations.isEmpty)
        XCTAssertGreaterThan(keyboard.abbreviations.count, 800)
    }

    func testAbbreviationsSample() {
        // 몇 가지 약어 테스트
        XCTAssertEqual(keyboard.abbreviations["nz"], "사람")
        XCTAssertEqual(keyboard.abbreviations["yz"], "마음")
        XCTAssertEqual(keyboard.abbreviations["is"], "다른 ")
        XCTAssertEqual(keyboard.abbreviations["hs"], "한국")
        XCTAssertEqual(keyboard.abbreviations["gkv"], "그곳")
        XCTAssertEqual(keyboard.abbreviations["kms"], "그런 ")
    }

    func testAbbreviationsKeysAreSorted() {
        // 약어 키는 정렬되어 있어야 함 (모아치기 특성상)
        for key in keyboard.abbreviations.keys {
            let sorted = String(key.sorted())
            XCTAssertEqual(key, sorted, "약어 키 '\(key)'가 정렬되어 있지 않음 (정렬: '\(sorted)')")
        }
    }

    // MARK: - Complete Character Composition Tests

    func testCompleteCharacterGa() {
        // "가" = ㄱ + ㅏ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["k", "f"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "가")
    }

    func testCompleteCharacterGan() {
        // "간" = ㄱ + ㅏ + ㄴ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["k", "f", "s"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "간")
    }

    func testCompleteCharacterKka() {
        // "까" = ㄲ + ㅏ (k + j + f)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["k", "j", "f"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "까")
    }

    func testCompleteCharacterHan() {
        // "한" = ㅎ + ㅏ + ㄴ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["h", "f", "s"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "한")
    }

    func testCompleteCharacterGul() {
        // "글" = ㄱ + ㅡ + ㄹ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["k", "g", "e"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "글")
    }

    func testCompleteCharacterGwa() {
        // "과" = ㄱ + ㅘ (ㅗ + ㅏ)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["k", "v", "f"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "과")
    }

    func testCompleteCharacterMoachigiOrder() {
        // 모아치기: 순서가 달라도 같은 결과
        let automata = Automata(keyboard)

        // "가" 순서 변형
        let comp1 = automata.composite(current: ["k", "f"])  // ㄱ + ㅏ
        let comp2 = automata.composite(current: ["f", "k"])  // ㅏ + ㄱ

        let str1 = String(utf16CodeUnits: keyboard.normalization(comp1), count: keyboard.normalization(comp1).count)
        let str2 = String(utf16CodeUnits: keyboard.normalization(comp2), count: keyboard.normalization(comp2).count)

        XCTAssertEqual(str1, "가")
        XCTAssertEqual(str2, "가")
    }

    func testCompleteCharacterDak() {
        // "닭" = ㄷ + ㅏ + ㄺ (ㄹ + ㄱ)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["i", "f", "e", "x"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "닭")
    }

    // MARK: - Timing Threshold Tests

    func testInputDeltaThresholdDefault() {
        XCTAssertEqual(keyboard.timingManager.inputDeltaThreshold, 150)
    }

    func testInputDeltaOverAfterUpdate() {
        // updateInputDelta 호출 직후는 threshold 이내
        keyboard.timingManager.updateInputDelta()
        // 바로 다시 호출하면 delta가 매우 작음
        keyboard.timingManager.updateInputDelta()
        XCTAssertFalse(keyboard.timingManager.isInputDeltaOver())
    }

    func testClearInputDelta() {
        // 먼저 delta를 작게 만듦
        keyboard.timingManager.updateInputDelta()
        keyboard.timingManager.updateInputDelta()
        // clearInputDelta는 threshold 이상으로 설정함
        keyboard.timingManager.clearInputDelta()
        XCTAssertTrue(keyboard.timingManager.isInputDeltaOver())
    }

    // MARK: - Normalization Tests

    func testNormalizationNFC() {
        var comp = Composition()
        comp.chosung = "k"   // ㄱ
        comp.jungsung = "f"  // ㅏ

        let result = keyboard.normalization(comp)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], 0xAC00)  // 가
    }

    func testNormalizationNFCWithJongsung() {
        var comp = Composition()
        comp.chosung = "k"   // ㄱ
        comp.jungsung = "f"  // ㅏ
        comp.jongsung = "s"  // ㄴ

        let result = keyboard.normalization(comp)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], 0xAC04)  // 간
    }

    func testNormalizationNFD() {
        // 초성만 있는 경우 NFD
        var comp = Composition()
        comp.chosung = "k"  // ㄱ

        let result = keyboard.normalization(comp)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], Hohwan.KIYEOK.rawValue)
    }

    // MARK: - Proc Tests

    func testChosungProcBasic() {
        var comp = Composition()
        let current = ["k"]

        let result = keyboard.chosungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testChosungProcDouble() {
        var comp = Composition()
        comp.chosung = "k"
        let current = ["j"]  // ㄱ + ㅇ = ㄲ

        let result = keyboard.chosungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testJungsungProcBasic() {
        var comp = Composition()
        comp.chosung = "k"
        let current = ["f"]

        let result = keyboard.jungsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testJongsungProcBasic() {
        var comp = Composition()
        comp.chosung = "k"
        comp.jungsung = "f"
        let current = ["s"]

        let result = keyboard.jongsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    // MARK: - Additional Character Tests

    func testAdditionalCharacter() {
        XCTAssertEqual(keyboard.etcLayout["p"], ";")
        XCTAssertEqual(keyboard.etcLayout["P"], ":")
    }
}
