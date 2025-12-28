import XCTest

final class KeyboardDubeolTests: XCTestCase {

    var keyboard: KeyboardDubeol!

    override func setUp() {
        super.setUp()
        keyboard = KeyboardDubeol()
    }

    override func tearDown() {
        keyboard = nil
        super.tearDown()
    }

    // MARK: - Layout Tests

    func testKeyboardName() {
        XCTAssertEqual(keyboard.name, "두벌식")
    }

    func testChosungLayout() {
        // 기본 초성
        XCTAssertEqual(keyboard.chosungLayout["r"], Chosung.Giyuk)
        XCTAssertEqual(keyboard.chosungLayout["s"], Chosung.Nien)
        XCTAssertEqual(keyboard.chosungLayout["e"], Chosung.Digek)
        XCTAssertEqual(keyboard.chosungLayout["f"], Chosung.Riel)
        XCTAssertEqual(keyboard.chosungLayout["a"], Chosung.Miem)
        XCTAssertEqual(keyboard.chosungLayout["q"], Chosung.Biep)
        XCTAssertEqual(keyboard.chosungLayout["t"], Chosung.Siot)
        XCTAssertEqual(keyboard.chosungLayout["d"], Chosung.Yieng)
        XCTAssertEqual(keyboard.chosungLayout["w"], Chosung.Jiek)
        XCTAssertEqual(keyboard.chosungLayout["c"], Chosung.Chiek)
        XCTAssertEqual(keyboard.chosungLayout["z"], Chosung.Kiyuk)
        XCTAssertEqual(keyboard.chosungLayout["x"], Chosung.Tigek)
        XCTAssertEqual(keyboard.chosungLayout["v"], Chosung.Piep)
        XCTAssertEqual(keyboard.chosungLayout["g"], Chosung.Hiek)

        // 쌍자음 (Shift)
        XCTAssertEqual(keyboard.chosungLayout["R"], Chosung.SsGiyuk)
        XCTAssertEqual(keyboard.chosungLayout["E"], Chosung.SsDigek)
        XCTAssertEqual(keyboard.chosungLayout["Q"], Chosung.SsBiep)
        XCTAssertEqual(keyboard.chosungLayout["T"], Chosung.SsSiot)
        XCTAssertEqual(keyboard.chosungLayout["W"], Chosung.SsJiek)
    }

    func testJungsungLayout() {
        // 단모음
        XCTAssertEqual(keyboard.jungsungLayout["k"], Jungsung.A)
        XCTAssertEqual(keyboard.jungsungLayout["j"], Jungsung.Eo)
        XCTAssertEqual(keyboard.jungsungLayout["h"], Jungsung.O)
        XCTAssertEqual(keyboard.jungsungLayout["n"], Jungsung.U)
        XCTAssertEqual(keyboard.jungsungLayout["m"], Jungsung.Eu)
        XCTAssertEqual(keyboard.jungsungLayout["l"], Jungsung.I)
        XCTAssertEqual(keyboard.jungsungLayout["o"], Jungsung.Ae)
        XCTAssertEqual(keyboard.jungsungLayout["p"], Jungsung.E)

        // 이중모음 (야, 여, 요, 유)
        XCTAssertEqual(keyboard.jungsungLayout["i"], Jungsung.Ya)
        XCTAssertEqual(keyboard.jungsungLayout["u"], Jungsung.Yeo)
        XCTAssertEqual(keyboard.jungsungLayout["y"], Jungsung.Yo)
        XCTAssertEqual(keyboard.jungsungLayout["b"], Jungsung.Yu)

        // 복합 모음 (ㅘ, ㅙ, ㅚ, ㅝ, ㅞ, ㅟ, ㅢ)
        XCTAssertEqual(keyboard.jungsungLayout["hk"], Jungsung.Wa)
        XCTAssertEqual(keyboard.jungsungLayout["ho"], Jungsung.Wae)
        XCTAssertEqual(keyboard.jungsungLayout["hl"], Jungsung.Oe)
        XCTAssertEqual(keyboard.jungsungLayout["nj"], Jungsung.Weo)
        XCTAssertEqual(keyboard.jungsungLayout["np"], Jungsung.We)
        XCTAssertEqual(keyboard.jungsungLayout["nl"], Jungsung.Wi)
        XCTAssertEqual(keyboard.jungsungLayout["ml"], Jungsung.Yi)

        // Shift 모음 (ㅒ, ㅖ)
        XCTAssertEqual(keyboard.jungsungLayout["O"], Jungsung.Yae)
        XCTAssertEqual(keyboard.jungsungLayout["P"], Jungsung.Ye)
    }

    func testJongsungLayout() {
        // 단자음 종성
        XCTAssertEqual(keyboard.jongsungLayout["r"], Jongsung.Kiyeok)
        XCTAssertEqual(keyboard.jongsungLayout["s"], Jongsung.Nieun)
        XCTAssertEqual(keyboard.jongsungLayout["e"], Jongsung.Tikeut)
        XCTAssertEqual(keyboard.jongsungLayout["f"], Jongsung.Rieul)
        XCTAssertEqual(keyboard.jongsungLayout["a"], Jongsung.Mieum)
        XCTAssertEqual(keyboard.jongsungLayout["q"], Jongsung.Pieup)
        XCTAssertEqual(keyboard.jongsungLayout["t"], Jongsung.Sios)
        XCTAssertEqual(keyboard.jongsungLayout["d"], Jongsung.Ieung)
        XCTAssertEqual(keyboard.jongsungLayout["w"], Jongsung.Cieuc)
        XCTAssertEqual(keyboard.jongsungLayout["c"], Jongsung.Chieuch)
        XCTAssertEqual(keyboard.jongsungLayout["z"], Jongsung.Khieukh)
        XCTAssertEqual(keyboard.jongsungLayout["x"], Jongsung.Thieuth)
        XCTAssertEqual(keyboard.jongsungLayout["v"], Jongsung.Phieuph)
        XCTAssertEqual(keyboard.jongsungLayout["g"], Jongsung.Hieuh)

        // 쌍자음 종성
        XCTAssertEqual(keyboard.jongsungLayout["R"], Jongsung.Ssangkiyeok)
        XCTAssertEqual(keyboard.jongsungLayout["T"], Jongsung.Ssangsios)

        // 겹받침
        XCTAssertEqual(keyboard.jongsungLayout["rt"], Jongsung.Kiyeoksios)
        XCTAssertEqual(keyboard.jongsungLayout["sw"], Jongsung.Nieuncieuc)
        XCTAssertEqual(keyboard.jongsungLayout["sg"], Jongsung.Nieunhieuh)
        XCTAssertEqual(keyboard.jongsungLayout["fr"], Jongsung.Rieulkiyeok)
        XCTAssertEqual(keyboard.jongsungLayout["fa"], Jongsung.Rieulmieum)
        XCTAssertEqual(keyboard.jongsungLayout["fq"], Jongsung.Rieulpieup)
        XCTAssertEqual(keyboard.jongsungLayout["ft"], Jongsung.Rieulsios)
        XCTAssertEqual(keyboard.jongsungLayout["fx"], Jongsung.Rieulthieuth)
        XCTAssertEqual(keyboard.jongsungLayout["fv"], Jongsung.Rieulphieuph)
        XCTAssertEqual(keyboard.jongsungLayout["fg"], Jongsung.Rieulhieuh)
        XCTAssertEqual(keyboard.jongsungLayout["qt"], Jongsung.Pieupsios)
    }

    // MARK: - isHangul Tests

    func testIsHangulChosung() {
        XCTAssertTrue(keyboard.isHangul("r"))  // ㄱ
        XCTAssertTrue(keyboard.isHangul("R"))  // ㄲ
        XCTAssertTrue(keyboard.isHangul("s"))  // ㄴ
        XCTAssertTrue(keyboard.isHangul("g"))  // ㅎ
    }

    func testIsHangulJungsung() {
        XCTAssertTrue(keyboard.isHangul("k"))  // ㅏ
        XCTAssertTrue(keyboard.isHangul("l"))  // ㅣ
        XCTAssertTrue(keyboard.isHangul("m"))  // ㅡ
    }

    func testIsHangulNonHangul() {
        XCTAssertFalse(keyboard.isHangul("1"))
        XCTAssertFalse(keyboard.isHangul("2"))
        XCTAssertFalse(keyboard.isHangul("."))
        XCTAssertFalse(keyboard.isHangul(","))
        XCTAssertFalse(keyboard.isHangul(" "))
    }

    // MARK: - Proc Tests

    func testChosungProc() {
        var comp = Composition()
        let current = ["r"]

        let result = keyboard.chosungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testChosungProcAfterJungsung() {
        // 중성이 있으면 초성 추가 불가 (다음 글자로)
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"
        let current = ["s"]

        let result = keyboard.chosungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertFalse(result)
    }

    func testJungsungProc() {
        var comp = Composition()
        comp.chosung = "r"
        let current = ["k"]

        let result = keyboard.jungsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testJungsungProcComplexVowel() {
        // 복합 모음 ㅘ (ㅗ + ㅏ)
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "h"
        let current = ["k"]

        let result = keyboard.jungsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testJongsungProc() {
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"
        let current = ["s"]

        let result = keyboard.jongsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    func testJongsungProcWithoutJungsung() {
        // 중성 없이 종성 불가
        var comp = Composition()
        comp.chosung = "r"
        let current = ["s"]

        let result = keyboard.jongsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertFalse(result)
    }

    func testJongsungProcComplexJongsung() {
        // 겹받침 ㄺ (ㄹ + ㄱ)
        var comp = Composition()
        comp.chosung = "e"
        comp.jungsung = "k"
        comp.jongsung = "f"
        let current = ["r"]

        let result = keyboard.jongsungProc(comp: &comp, nobreak: false, current: current, i: 0)
        XCTAssertTrue(result)
    }

    // MARK: - Normalization Tests

    func testNormalizationNFC() {
        // NFC 정규화 테스트: 가 (0xAC00)
        var comp = Composition()
        comp.chosung = "r"   // ㄱ
        comp.jungsung = "k"  // ㅏ

        let result = keyboard.normalization(comp)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], 0xAC00)  // 가
    }

    func testNormalizationNFCWithJongsung() {
        // NFC 정규화 테스트: 간 (0xAC04)
        var comp = Composition()
        comp.chosung = "r"   // ㄱ
        comp.jungsung = "k"  // ㅏ
        comp.jongsung = "s"  // ㄴ

        let result = keyboard.normalization(comp)
        XCTAssertEqual(result.count, 1)
        // 간 = ((0 * 588) + (0 * 28) + 4) + 0xAC00 = 0xAC04
        // 초성 ㄱ = 인덱스 0, 중성 ㅏ = 인덱스 0, 종성 ㄴ = 인덱스 4
        XCTAssertEqual(result[0], 0xAC04)  // 간
    }

    func testNormalizationNFD() {
        // NFD 정규화 테스트: 초성만 있는 경우
        var comp = Composition()
        comp.chosung = "r"  // ㄱ

        let result = keyboard.normalization(comp)
        // 초성만 있으면 NFD로 호환 자모 반환
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], Hohwan.KIYEOK.rawValue)  // ㄱ (0x3131)
    }

    // MARK: - Double Consonant Mode Tests

    func testSetDoubleConsonantEnabled() {
        keyboard.setDoubleConsonant(true)

        // 연타 모드에서는 rr -> ㄲ
        XCTAssertEqual(keyboard.chosungLayout["rr"], Chosung.SsGiyuk)
        XCTAssertEqual(keyboard.chosungLayout["tt"], Chosung.SsSiot)
    }

    func testSetDoubleConsonantDisabled() {
        keyboard.setDoubleConsonant(false)

        // Shift 모드에서는 R -> ㄲ
        XCTAssertEqual(keyboard.chosungLayout["R"], Chosung.SsGiyuk)
        XCTAssertEqual(keyboard.chosungLayout["T"], Chosung.SsSiot)
    }

    // MARK: - Timing Tests

    func testInputTimingRecording() {
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        XCTAssertEqual(keyboard.timingManager.inputTimes.count, 3)
    }

    func testConsumeInputTimes() {
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        keyboard.timingManager.consumeInputTimes(2)
        XCTAssertEqual(keyboard.timingManager.inputTimes.count, 1)
    }

    func testClearInputTimes() {
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        keyboard.timingManager.clearInputTimes()
        XCTAssertTrue(keyboard.timingManager.inputTimes.isEmpty)
    }

    func testRemoveLastInputTime() {
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        keyboard.timingManager.removeLastInputTime()
        XCTAssertEqual(keyboard.timingManager.inputTimes.count, 1)
    }

    // MARK: - NFD Output Tests

    func testNfdChosungOnly() {
        var comp = Composition()
        comp.chosung = "r"

        let result = keyboard.nfd(comp)
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result[0], Hohwan.KIYEOK.rawValue)
    }

    func testNfdChosungJungsung() {
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"

        let result = keyboard.nfd(comp)
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0], Hohwan.KIYEOK.rawValue)
        XCTAssertEqual(result[1], Hohwan.A.rawValue)
    }

    func testNfdChosungJungsungJongsung() {
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"
        comp.jongsung = "s"

        let result = keyboard.nfd(comp)
        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result[0], Hohwan.KIYEOK.rawValue)
        XCTAssertEqual(result[1], Hohwan.A.rawValue)
        XCTAssertEqual(result[2], Hohwan.NIEUN.rawValue)
    }

    // MARK: - Complete Character Composition Tests

    func testCompleteCharacterGa() {
        // "가" = ㄱ + ㅏ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["r", "k"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "가")
    }

    func testCompleteCharacterGan() {
        // "간" = ㄱ + ㅏ + ㄴ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["r", "k", "s"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "간")
    }

    func testCompleteCharacterGwa() {
        // "과" = ㄱ + ㅘ (ㅗ + ㅏ)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["r", "h", "k"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "과")
    }

    func testCompleteCharacterDak() {
        // "닭" = ㄷ + ㅏ + ㄺ (ㄹ + ㄱ)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["e", "k", "f", "r"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "닭")
    }

    func testCompleteCharacterKka() {
        // "까" = ㄲ + ㅏ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["R", "k"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "까")
    }

    func testCompleteCharacterHan() {
        // "한" = ㅎ + ㅏ + ㄴ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["g", "k", "s"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "한")
    }

    func testCompleteCharacterGul() {
        // "글" = ㄱ + ㅡ + ㄹ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["r", "m", "f"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "글")
    }

    func testCompleteCharacterSsal() {
        // "쌀" = ㅆ + ㅏ + ㄹ
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["T", "k", "f"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "쌀")
    }

    func testCompleteCharacterIss() {
        // "있" = ㅇ + ㅣ + ㅆ (종성 쌍시옷)
        let automata = Automata(keyboard)
        let comp = automata.composite(current: ["d", "l", "T"])

        let normalized = keyboard.normalization(comp)
        let str = String(utf16CodeUnits: normalized, count: normalized.count)
        XCTAssertEqual(str, "있")
    }
}
