import Foundation

// MARK: - KeyboardDubeol

final class KeyboardDubeol: Keyboard {
    private var doubleConsonant: Bool = false

    override init() {
        super.init()
        name = "두벌식"
        doubleConsonant = OptHandler.shared.dubeolDouble == 1
        chosungLayout = doubleConsonant ? DubeolLayout.noShiftChosungLayout : DubeolLayout.shiftChosungLayout
        jungsungLayout = DubeolLayout.jungsungLayout
        jongsungLayout = DubeolLayout.jongsungLayout
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
}
