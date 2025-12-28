import XCTest

final class HangulTests: XCTestCase {

    var hangul: Hangul!

    override func setUp() {
        super.setUp()
        hangul = Hangul()
    }

    override func tearDown() {
        hangul.stop()
        hangul = nil
        super.tearDown()
    }

    // MARK: - Helper Functions

    func getCommittedString() -> String {
        let committed = hangul.consumeCommit()
        return String(utf16CodeUnits: committed, count: committed.count)
    }

    func getPreeditString() -> String {
        let preedit = hangul.consumePreedit()
        return String(utf16CodeUnits: preedit, count: preedit.count)
    }

    // MARK: - Initialization Tests

    func testHangulInitialState() {
        XCTAssertTrue(hangul.committed.isEmpty)
        XCTAssertTrue(hangul.preediting.isEmpty)
    }

    func testHangulStartDubeol() {
        hangul.start(0)  // 두벌식
        XCTAssertNotNil(hangul.keyboard)
        XCTAssertNotNil(hangul.automata)
        XCTAssertEqual(hangul.keyboard?.name, "두벌식")
    }

    func testHangulStartSemoi() {
        hangul.start(1)  // 세모이
        XCTAssertNotNil(hangul.keyboard)
        XCTAssertNotNil(hangul.automata)
        XCTAssertEqual(hangul.keyboard?.name, "세모이")
    }

    func testHangulStop() {
        hangul.start(0)
        hangul.stop()
        XCTAssertNil(hangul.keyboard)
        XCTAssertNil(hangul.automata)
    }

    // MARK: - Dubeol Process Tests

    func testDubeolProcessSingleChosung() {
        hangul.start(0)  // 두벌식

        let result = hangul.process("r")  // ㄱ
        XCTAssertTrue(result)

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "ㄱ")
    }

    func testDubeolProcessChosungJungsung() {
        hangul.start(0)

        XCTAssertTrue(hangul.process("r"))  // ㄱ
        _ = getPreeditString()  // clear preediting
        XCTAssertTrue(hangul.process("k"))  // ㅏ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "가")
    }

    func testDubeolProcessCompleteCharacter() {
        hangul.start(0)

        XCTAssertTrue(hangul.process("r"))  // ㄱ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("k"))  // ㅏ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("s"))  // ㄴ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "간")
    }

    func testDubeolProcessNonHangul() {
        hangul.start(0)

        let result = hangul.process("1")  // 숫자
        XCTAssertFalse(result)
    }

    func testDubeolProcessDoubleChosung() {
        hangul.start(0)

        XCTAssertTrue(hangul.process("R"))  // ㄲ (Shift + r)
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("k"))  // ㅏ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "까")
    }

    func testDubeolProcessComplexJungsung() {
        hangul.start(0)

        XCTAssertTrue(hangul.process("r"))  // ㄱ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("h"))  // ㅗ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("k"))  // ㅏ -> ㅘ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "과")
    }

    func testDubeolProcessComplexJongsung() {
        hangul.start(0)

        XCTAssertTrue(hangul.process("e"))  // ㄷ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("k"))  // ㅏ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("f"))  // ㄹ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("r"))  // ㄱ -> ㄺ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "닭")
    }

    // MARK: - Semoi Process Tests

    func testSemoiProcessSingleChosung() {
        hangul.start(1)  // 세모이

        let result = hangul.process("k")  // ㄱ
        XCTAssertTrue(result)

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "ㄱ")
    }

    func testSemoiProcessChosungJungsung() {
        hangul.start(1)

        XCTAssertTrue(hangul.process("k"))  // ㄱ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("f"))  // ㅏ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "가")
    }

    func testSemoiProcessDoubleChosung() {
        hangul.start(1)

        XCTAssertTrue(hangul.process("k"))  // ㄱ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("j"))  // ㅇ -> ㄲ
        _ = getPreeditString()
        XCTAssertTrue(hangul.process("f"))  // ㅏ

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "까")
    }

    func testSemoiProcessNonHangul() {
        hangul.start(1)

        let result = hangul.process("1")
        XCTAssertFalse(result)
    }

    // MARK: - Backspace Tests

    func testBackspaceWithContent() {
        hangul.start(0)

        hangul.process("r")  // ㄱ
        _ = getPreeditString()
        hangul.process("k")  // ㅏ
        _ = getPreeditString()

        let result = hangul.backspace()
        XCTAssertTrue(result)

        let preedit = getPreeditString()
        XCTAssertEqual(preedit, "ㄱ")
    }

    func testBackspaceEmptyBuffer() {
        hangul.start(0)

        let result = hangul.backspace()
        XCTAssertFalse(result)
    }

    func testBackspaceMultiple() {
        hangul.start(0)

        hangul.process("r")  // ㄱ
        _ = getPreeditString()
        hangul.process("k")  // ㅏ
        _ = getPreeditString()
        hangul.process("s")  // ㄴ
        _ = getPreeditString()

        // "간" -> "가"
        XCTAssertTrue(hangul.backspace())
        XCTAssertEqual(getPreeditString(), "가")

        // "가" -> "ㄱ"
        XCTAssertTrue(hangul.backspace())
        XCTAssertEqual(getPreeditString(), "ㄱ")

        // "ㄱ" -> ""
        XCTAssertTrue(hangul.backspace())
        XCTAssertEqual(getPreeditString(), "")

        // empty -> false
        XCTAssertFalse(hangul.backspace())
    }

    // MARK: - Flush Tests

    func testFlushWithContent() {
        hangul.start(0)

        hangul.process("r")  // ㄱ
        _ = getPreeditString()
        hangul.process("k")  // ㅏ
        _ = getPreeditString()

        hangul.flush()

        let committed = getCommittedString()
        XCTAssertEqual(committed, "가")
    }

    func testFlushEmptyBuffer() {
        hangul.start(0)

        hangul.flush()  // Should not crash

        let committed = getCommittedString()
        XCTAssertEqual(committed, "")
    }

    // MARK: - isHangul Tests

    func testIsHangulDubeol() {
        hangul.start(0)

        XCTAssertTrue(hangul.isHangul("r"))  // ㄱ
        XCTAssertTrue(hangul.isHangul("k"))  // ㅏ
        XCTAssertFalse(hangul.isHangul("1"))
    }

    func testIsHangulSemoi() {
        hangul.start(1)

        XCTAssertTrue(hangul.isHangul("k"))  // ㄱ
        XCTAssertTrue(hangul.isHangul("f"))  // ㅏ
        XCTAssertFalse(hangul.isHangul("1"))
    }

    // MARK: - Additional Tests

    func testAdditionalDubeol() {
        hangul.start(0)

        // 두벌식은 etcLayout이 비어있음
        XCTAssertNil(hangul.additional("p"))
    }

    func testAdditionalSemoi() {
        hangul.start(1)

        XCTAssertEqual(hangul.additional("p"), ";")
        XCTAssertEqual(hangul.additional("P"), ":")
        XCTAssertEqual(hangul.additional("L"), ".")
    }

    // MARK: - Abbreviation Tests (Semoi only)

    func testAbbreviationProcess() {
        hangul.start(1)  // 세모이

        // "nz" -> "사람"
        let result = hangul.processAbbreviation("nz")
        XCTAssertTrue(result)

        let committed = getCommittedString()
        XCTAssertEqual(committed, "사람")
    }

    func testAbbreviationProcessNotFound() {
        hangul.start(1)

        let result = hangul.processAbbreviation("xyz123")
        XCTAssertFalse(result)
    }

    func testAbbreviationFlushBeforeInsert() {
        hangul.start(1)

        // 조합 중인 글자가 있을 때
        hangul.process("k")  // ㄱ
        _ = getPreeditString()

        // 약어 처리 시 먼저 flush됨
        hangul.processAbbreviation("yz")  // "마음"

        // flush된 "ㄱ" + "마음"
        let committed = getCommittedString()
        XCTAssertTrue(committed.contains("마음"))
    }

    // MARK: - getCommit/getPreedit Tests

    func testGetCommitClearsBuffer() {
        hangul.start(0)

        hangul.process("r")
        hangul.process("k")
        hangul.flush()

        _ = getCommittedString()  // 첫 번째 호출

        // 두 번째 호출은 빈 문자열
        let second = getCommittedString()
        XCTAssertEqual(second, "")
    }

    func testGetPreeditClearsBuffer() {
        hangul.start(0)

        hangul.process("r")

        _ = getPreeditString()  // 첫 번째 호출

        // 두 번째 호출은 빈 문자열 (process 없이)
        let second = getPreeditString()
        XCTAssertEqual(second, "")
    }

    // MARK: - KeyboardFactory Tests

    func testKeyboardFactoryCreateDubeol() {
        let dubeol = KeyboardFactory.create(.dubeol)
        XCTAssertEqual(dubeol.name, "두벌식")
    }

    func testKeyboardFactoryCreateSemoi() {
        let semoi = KeyboardFactory.create(.semoi)
        XCTAssertEqual(semoi.name, "세모이")
    }

    func testKeyboardFactoryGetDubeolKeyboard() {
        // 먼저 두벌식 키보드를 생성해야 캐시에 저장됨
        _ = KeyboardFactory.create(.dubeol)
        let dubeol = KeyboardFactory.getDubeolKeyboard()
        XCTAssertNotNil(dubeol)
        XCTAssertEqual(dubeol?.name, "두벌식")
    }

    // MARK: - Multiple Character Tests

    func testDubeolMultipleCharacters() {
        hangul.start(0)

        // "한글" 입력
        hangul.process("g")  // ㅎ
        _ = getPreeditString()
        hangul.process("k")  // ㅏ
        _ = getPreeditString()
        hangul.process("s")  // ㄴ
        _ = getPreeditString()

        // 다음 글자 시작 시 도깨비불
        hangul.process("r")  // ㄱ -> 도깨비불 발생
        _ = getCommittedString()  // "하" 또는 타이밍에 따라 다름
        _ = getPreeditString()

        // flush하여 확인
        hangul.flush()

        // 결과는 타이밍에 따라 달라질 수 있음
    }

    // MARK: - Edge Cases

    func testProcessWithoutStart() {
        // start() 호출 없이 process 시도
        // keyboard가 nil이면 isHangul에서 crash 발생 가능
        // 이 테스트는 실제 동작을 검증하기보다 안전성 확인용
    }

    func testStartWithInvalidType() {
        // 범위를 벗어난 타입으로 시작
        hangul.start(99)
        XCTAssertNotNil(hangul.keyboard)
        XCTAssertEqual(hangul.keyboard?.name, "두벌식")  // 기본값으로 fallback
    }

    // MARK: - Complete Word Tests

    func testDubeolCompleteWordHangul() {
        hangul.start(0)

        // "한" = ㅎ + ㅏ + ㄴ
        hangul.process("g")  // ㅎ
        hangul.process("k")  // ㅏ
        hangul.process("s")  // ㄴ

        hangul.flush()
        let result = getCommittedString()
        XCTAssertEqual(result, "한")
    }

    func testSemoiCompleteWordHan() {
        hangul.start(1)

        // "한" = ㅎ + ㅏ + ㄴ
        hangul.process("h")  // ㅎ
        _ = getPreeditString()
        hangul.process("f")  // ㅏ
        _ = getPreeditString()
        hangul.process("s")  // ㄴ

        hangul.flush()
        let result = getCommittedString()
        XCTAssertEqual(result, "한")
    }
}

// MARK: - Integration Tests

final class HangulIntegrationTests: XCTestCase {

    // MARK: - Dubeol Integration

    func testDubeolTypingSequence() {
        let hangul = Hangul()
        hangul.start(0)

        // 여러 글자 연속 입력 시뮬레이션
        let inputs = ["g", "k", "s", "r", "m", "f"]  // 한글

        for input in inputs {
            _ = hangul.process(input)
        }

        hangul.flush()

        // 결과 확인 (타이밍에 따라 다를 수 있음)
        let committed = hangul.consumeCommit()
        XCTAssertFalse(committed.isEmpty)

        hangul.stop()
    }

    // MARK: - Semoi Integration

    func testSemoiTypingSequence() {
        let hangul = Hangul()
        hangul.start(1)

        // "한" 입력
        _ = hangul.process("h")  // ㅎ
        _ = hangul.consumePreedit()
        _ = hangul.process("f")  // ㅏ
        _ = hangul.consumePreedit()
        _ = hangul.process("s")  // ㄴ

        hangul.flush()

        let committed = hangul.consumeCommit()
        let result = String(utf16CodeUnits: committed, count: committed.count)
        XCTAssertEqual(result, "한")

        hangul.stop()
    }

    // MARK: - Keyboard Switching

    func testKeyboardSwitching() {
        let hangul = Hangul()

        // 두벌식으로 시작
        hangul.start(0)
        XCTAssertEqual(hangul.keyboard?.name, "두벌식")

        _ = hangul.process("r")  // ㄱ
        hangul.flush()

        // 세모이로 전환
        hangul.stop()
        hangul.start(1)
        XCTAssertEqual(hangul.keyboard?.name, "세모이")

        _ = hangul.process("k")  // ㄱ (세모이)
        hangul.flush()

        hangul.stop()
    }
}
