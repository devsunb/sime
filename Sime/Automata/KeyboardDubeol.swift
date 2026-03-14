import Foundation

// MARK: - KeyboardDubeol

final class KeyboardDubeol: Keyboard {
    private var doubleConsonant: Bool = false

    override init() {
        super.init()
        name = "두벌식"
        doubleConsonant = OptHandler.shared.dubeolDouble > 0
        chosungLayout = doubleConsonant ? DubeolLayout.noShiftChosungLayout : DubeolLayout.shiftChosungLayout
        jungsungLayout = DubeolLayout.jungsungLayout
        jongsungLayout = DubeolLayout.jongsungLayout
        setupDubeolNotifications()
    }

    private func setupDubeolNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleDubeolDoubleChange(_:)),
            name: .dubeolDoubleDidChange,
            object: nil
        )
    }

    @objc private func handleDubeolDoubleChange(_ notification: Notification) {
        guard let value = notification.userInfo?["value"] as? Int else { return }
        setDoubleConsonant(value > 0)
        if value > 0 {
            timingManager.doubleKeyThreshold = TimeInterval(value)
        }
    }

    func setDoubleConsonant(_ enabled: Bool) {
        doubleConsonant = enabled
        chosungLayout = enabled ? DubeolLayout.noShiftChosungLayout : DubeolLayout.shiftChosungLayout
    }

    // MARK: - Composition Processing

    override func chosungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] chosungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        guard comp.chosung.isEmpty || comp.jungsung.isEmpty else { return false }
        return chosungLayout[comp.chosung + current[i]] != nil
    }

    override func jungsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jungsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        guard jungsungLayout[current[i]] != nil else { return false }

        if !comp.jongsung.isEmpty {
            if DubeolLayout.doubleConsonantJongsungKeys.contains(comp.jongsung) {
                // 종성 쌍자음(ㄲ, ㅆ)은 전체를 다음 글자 초성으로 분리
                comp.jongsung = ""
                comp.done = true
                return false
            }

            // 겹받침: 마지막 글자만 분리 (도깨비불)
            var jongArr = Array(comp.jongsung)
            let lastJong = jongArr.removeLast()
            if chosungLayout[String(lastJong)] != nil {
                comp.jongsung = String(jongArr)
                comp.done = true
                return false
            }
        }

        return jungsungLayout[comp.jungsung + current[i]] != nil
    }

    override func jongsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jongsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        guard !comp.jungsung.isEmpty else { return false }

        let key = current[i]

        // ㅃ, ㅉ, ㄸ는 종성으로 올 수 없으므로 현재 글자를 완성하고 초성으로 시작
        if DubeolLayout.noJongsungKeys.contains(key) {
            comp.done = true
            return false
        }

        let jongKey = comp.jongsung + key

        // doubleConsonant가 false면 종성에서 쌍자음 조합 금지
        if !doubleConsonant && DubeolLayout.doubleConsonantJongsungKeys.contains(jongKey) {
            comp.done = true
            return false
        }

        // 연타 쌍자음 타이밍 확인
        if doubleConsonant && DubeolLayout.doubleConsonantKeys.contains(key) {
            if comp.jongsung == key && i == current.count - 1 {
                if !timingManager.isDoubleKeyInputFast(at: i) {
                    comp.done = true
                    return false
                }
            }
        }

        return jongsungLayout[jongKey] != nil
    }

    override func fallbackProc(comp: inout Composition, current: [String], i: Int) {
        // 겹받침에서 연타 쌍자음 처리
        // 예: "말끼" 입력 시 종성 ㄺ 상태에서 ㄱ 연타가 빠르면 ㄱ을 빼고 ㄲ으로 시작
        if doubleConsonant {
            handleDoubleConsonantOverflow(comp: &comp, current: current, i: i)
        }
        super.fallbackProc(comp: &comp, current: current, i: i)
    }

    // MARK: - Private

    /// 겹받침에서 연타 쌍자음 처리
    private func handleDoubleConsonantOverflow(comp: inout Composition, current: [String], i: Int) {
        guard i > 0, i < current.count else { return }
        guard !comp.jongsung.isEmpty else { return }

        let key = current[i]
        let prevKey = current[i - 1]

        // 같은 연타 가능 키가 연속으로 입력되었는지 확인
        guard key == prevKey, DubeolLayout.doubleConsonantKeys.contains(key) else { return }

        // 종성의 마지막 문자가 해당 키인지 확인
        guard comp.jongsung.hasSuffix(key) else { return }

        // 연타가 빠른지 확인
        guard timingManager.isDoubleKeyInputFast(at: i) else { return }

        // 종성에서 마지막 키 제거 (ㄺ → ㄹ)
        comp.jongsung.removeLast()
        Log.shared.debug("[Automata] 겹받침 연타 쌍자음: '\(key)' 제거 → 종성 '\(comp.jongsung)'")
    }
}
