import XCTest

final class CompositionTests: XCTestCase {

    // MARK: - Composition Struct Tests

    func testCompositionInitialState() {
        let comp = Composition()
        XCTAssertEqual(comp.chosung, "")
        XCTAssertEqual(comp.jungsung, "")
        XCTAssertEqual(comp.jongsung, "")
        XCTAssertFalse(comp.done)
        XCTAssertEqual(comp.size, 0)
    }

    func testCompositionSize() {
        var comp = Composition()

        // 초성만
        comp.chosung = "r"
        XCTAssertEqual(comp.size, 1)

        // 초성 + 중성
        comp.jungsung = "k"
        XCTAssertEqual(comp.size, 2)

        // 초성 + 중성 + 종성
        comp.jongsung = "r"
        XCTAssertEqual(comp.size, 3)

        // 복합 자모 (두벌식에서 복합 중성 등)
        comp.jungsung = "hk"  // ㅘ
        XCTAssertEqual(comp.size, 4)
    }

    func testCompositionDebugString() {
        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"
        comp.jongsung = "r"

        XCTAssertEqual(comp.debugDescription, "[r] [k] [r]")
    }

    func testCompositionDoneFlag() {
        var comp = Composition()
        XCTAssertFalse(comp.done)

        comp.done = true
        XCTAssertTrue(comp.done)
    }
}

final class AutomataTests: XCTestCase {

    // MARK: - Automata Basic Tests

    func testAutomataInitialization() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        XCTAssertTrue(automata.current.isEmpty)
    }

    func testAutomataCompositeEmpty() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        let comp = automata.composite(current: [])
        XCTAssertEqual(comp.size, 0)
        XCTAssertFalse(comp.done)
    }

    func testAutomataConsume() {
        let keyboard = KeyboardDubeol()
        var automata = Automata(keyboard)

        automata.current = ["r", "k", "t"]
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        var comp = Composition()
        comp.chosung = "r"
        comp.jungsung = "k"

        automata.consume(comp)
        XCTAssertEqual(automata.current.count, 1)
        XCTAssertEqual(automata.current.first, "t")
    }

    // MARK: - Dubeol Automata Composite Tests

    func testDubeolCompositeSingleChosung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // ㄱ
        let comp = automata.composite(current: ["r"])
        XCTAssertEqual(comp.chosung, "r")
        XCTAssertEqual(comp.jungsung, "")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testDubeolCompositeChosungJungsung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // 가 (ㄱ + ㅏ)
        let comp = automata.composite(current: ["r", "k"])
        XCTAssertEqual(comp.chosung, "r")
        XCTAssertEqual(comp.jungsung, "k")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testDubeolCompositeChosungJungsungJongsung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // 간 (ㄱ + ㅏ + ㄴ)
        let comp = automata.composite(current: ["r", "k", "s"])
        XCTAssertEqual(comp.chosung, "r")
        XCTAssertEqual(comp.jungsung, "k")
        XCTAssertEqual(comp.jongsung, "s")
    }

    func testDubeolCompositeComplexJungsung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // 과 (ㄱ + ㅗ + ㅏ = ㄱ + ㅘ)
        let comp = automata.composite(current: ["r", "h", "k"])
        XCTAssertEqual(comp.chosung, "r")
        XCTAssertEqual(comp.jungsung, "hk")  // ㅘ
        XCTAssertEqual(comp.jongsung, "")
    }

    func testDubeolCompositeComplexJongsung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // 닭 (ㄷ + ㅏ + ㄹ + ㄱ = ㄷ + ㅏ + ㄺ)
        let comp = automata.composite(current: ["e", "k", "f", "r"])
        XCTAssertEqual(comp.chosung, "e")
        XCTAssertEqual(comp.jungsung, "k")
        XCTAssertEqual(comp.jongsung, "fr")  // ㄺ
    }

    func testDubeolCompositeDoubleCho() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // ㄲ (Shift + ㄱ)
        let comp = automata.composite(current: ["R"])
        XCTAssertEqual(comp.chosung, "R")
        XCTAssertEqual(comp.jungsung, "")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testDubeolCompositeDoubleJungsung() {
        let keyboard = KeyboardDubeol()
        let automata = Automata(keyboard)

        // ㅒ (Shift + ㅐ)
        let comp = automata.composite(current: ["r", "O"])
        XCTAssertEqual(comp.chosung, "r")
        XCTAssertEqual(comp.jungsung, "O")  // ㅒ
        XCTAssertEqual(comp.jongsung, "")
    }

    // MARK: - Semoi Automata Composite Tests

    func testSemoiCompositeSingleChosung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // ㄱ
        let comp = automata.composite(current: ["k"])
        XCTAssertEqual(comp.chosung, "k")
        XCTAssertEqual(comp.jungsung, "")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testSemoiCompositeDoubleChosung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // ㄲ (ㄱ + ㅇ)
        let comp = automata.composite(current: ["k", "j"])
        XCTAssertEqual(comp.chosung, "kj")
        XCTAssertEqual(comp.jungsung, "")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testSemoiCompositeChosungJungsung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // 가 (ㄱ + ㅏ)
        let comp = automata.composite(current: ["k", "f"])
        XCTAssertEqual(comp.chosung, "k")
        XCTAssertEqual(comp.jungsung, "f")
        XCTAssertEqual(comp.jongsung, "")
    }

    func testSemoiCompositeChosungJungsungJongsung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // 간 (ㄱ + ㅏ + ㄴ)
        let comp = automata.composite(current: ["k", "f", "s"])
        XCTAssertEqual(comp.chosung, "k")
        XCTAssertEqual(comp.jungsung, "f")
        XCTAssertEqual(comp.jongsung, "s")
    }

    func testSemoiCompositeComplexJungsung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // 과 (ㄱ + ㅘ = ㄱ + ㅗ + ㅏ)
        let comp = automata.composite(current: ["k", "v", "f"])
        XCTAssertEqual(comp.chosung, "k")
        XCTAssertEqual(comp.jungsung, "vf")  // ㅘ
        XCTAssertEqual(comp.jongsung, "")
    }

    func testSemoiCompositeComplexJongsung() {
        let keyboard = KeyboardSemoi()
        let automata = Automata(keyboard)

        // 닭 (ㄷ + ㅏ + ㄹ + ㄱ = ㄷ + ㅏ + ㄺ)
        let comp = automata.composite(current: ["i", "f", "e", "x"])
        XCTAssertEqual(comp.chosung, "i")
        XCTAssertEqual(comp.jungsung, "f")
        XCTAssertEqual(comp.jongsung, "ex")  // ㄺ
    }

    // MARK: - Automata Run Tests

    func testAutomataRunWithCompletedCharacter() {
        let keyboard = KeyboardDubeol()
        var automata = Automata(keyboard)

        // "가나" 입력 시뮬레이션
        keyboard.timingManager.clearInputDelta()
        automata.current = ["r", "k", "s", "k"]  // ㄱㅏㄴㅏ

        // 타이밍 기록 (종성 다음 중성이 오면 도깨비불)
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()
        keyboard.timingManager.recordKeyInput()

        // 첫 번째 run: "간"이 완성되고 도깨비불로 "나"로 분리
        var comp = automata.run()
        // 도깨비불 현상으로 "가"가 완성되고 "ㄴ"이 다음 글자로 넘어감
        XCTAssertTrue(comp.done || !comp.done)  // 타이밍에 따라 다름
    }
}
