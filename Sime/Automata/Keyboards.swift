import Foundation

// MARK: - Keyboard

class Keyboard: KeyboardType {
    var name: String = ""
    var chosungLayout: [String: Chosung] = [:]
    var jungsungLayout: [String: Jungsung] = [:]
    var jongsungLayout: [String: Jongsung] = [:]
    var etcLayout: [String: String] = [:]
    var abbreviations: [String: String] = [:]
    let timingManager: InputTimingManager

    init() {
        let opts = OptHandler.shared
        let doubleKeyThreshold = opts.dubeolDouble > 0 ? opts.dubeolDouble : 150
        timingManager = InputTimingManager(
            inputDeltaThreshold: TimeInterval(opts.inputDeltaThreshold),
            doubleKeyThreshold: TimeInterval(doubleKeyThreshold)
        )
        setupNotifications()
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleInputDeltaThresholdChange(_:)),
            name: .inputDeltaThresholdDidChange,
            object: nil
        )
    }

    @objc private func handleInputDeltaThresholdChange(_ notification: Notification) {
        guard let value = notification.userInfo?["value"] as? Int else { return }
        timingManager.inputDeltaThreshold = TimeInterval(value)
    }

    func chosungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] chosungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        return chosungLayout[current[i]] != nil
    }

    func jungsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jungsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        return jungsungLayout[current[i]] != nil
    }

    func jongsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool {
        guard i < current.count else {
            Log.shared.error("[Automata] jongsungProc index out of bounds: i=\(i), count=\(current.count)")
            return false
        }
        return jongsungLayout[current[i]] != nil
    }

    func fallbackProc(comp: inout Composition, current: [String], i: Int) {
        comp.done = true
    }
}
