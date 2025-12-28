import Foundation

// MARK: - KeyboardSemoi

final class KeyboardSemoi: Keyboard {
    override init() {
        super.init()
        name = "세모이"
        chosungLayout = SemoiLayout.chosungLayout
        jungsungLayout = SemoiLayout.jungsungLayout
        jongsungLayout = SemoiLayout.jongsungLayout
        etcLayout = SemoiLayout.etcLayout
        abbreviations = SemoiAbbreviations.abbreviations
    }

    // MARK: - Composition Processing

    override func chosungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] chosungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        let choKey = comp.chosung + current[i]
        let isChosung = chosungLayout[choKey] != nil

        // 마지막 낱자가 초성일 때만 타이밍 체크
        if i == current.count - 1 && isChosung {
            timingManager.updateCategoryDelta(.chosung)
            if !nobreak && !comp.chosung.isEmpty && timingManager.isCategoryDeltaOver(.chosung) {
                comp.done = true
                return false
            }
        }

        return isChosung
    }

    override func jungsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jungsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        let jungKey = comp.jungsung + current[i]
        let isJungsung = jungsungLayout[jungKey] != nil

        if i == current.count - 1 && isJungsung {
            timingManager.updateCategoryDelta(.jungsung)
            if !nobreak && !comp.jungsung.isEmpty && timingManager.isCategoryDeltaOver(.jungsung) {
                comp.done = true
                return false
            }
        }

        return isJungsung
    }

    override func jongsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jongsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        let jongKey = comp.jongsung + current[i]
        let isJongsung = jongsungLayout[jongKey] != nil

        if i == current.count - 1 && isJongsung {
            timingManager.updateCategoryDelta(.jongsung)
            if !nobreak && !comp.jongsung.isEmpty && timingManager.isCategoryDeltaOver(.jongsung) {
                comp.done = true
                return false
            }
        }

        return isJongsung
    }

    override func fallbackProc(comp: inout Composition, current: [String], i: Int) {
        handleMoachigiJongsungOverflow(comp: &comp, current: current, i: i)
        super.fallbackProc(comp: &comp, current: current, i: i)
    }

    // MARK: - Private

    /// 모아치기 종성 넘김 처리
    /// "서울" 입력 시 "설우"가 되는 현상 방지
    private func handleMoachigiJongsungOverflow(comp: inout Composition, current: [String], i: Int) {
        guard !comp.jongsung.isEmpty, !timingManager.isInputDeltaOver() else { return }

        let prefix = current.prefix(i)
        let prefixReversed = prefix.reversed()
        let jongsung = Array(comp.jongsung)
        let jongsungReversed = jongsung.reversed()

        var overflowCount = 0
        for (prefixChar, jongChar) in zip(prefixReversed, jongsungReversed) {
            if prefixChar == String(jongChar) {
                overflowCount += 1
            } else {
                break
            }
        }

        if overflowCount > 0 {
            let overflowJongsung = String(jongsung.suffix(overflowCount))
            Log.shared.debug("[Automata] 종성 넘김: '\(overflowJongsung)' (\(overflowCount))")
            comp.jongsung.removeLast(overflowCount)
        }

        // 무한루프 방지
        timingManager.clearInputDelta()
    }
}
