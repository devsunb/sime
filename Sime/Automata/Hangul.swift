import Foundation

// MARK: - Hangul

final class Hangul {
    private(set) var automata: Automata?
    private(set) var keyboard: KeyboardType?
    private(set) var committed: [unichar] = []
    private(set) var preediting: [unichar] = []

    // MARK: - Lifecycle

    func start(_ type: Int) {
        let kind = KeyboardKind(rawValue: type) ?? .dubeol
        let kbd = KeyboardFactory.create(kind)
        keyboard = kbd
        automata = Automata(kbd)
    }

    func stop() {
        keyboard = nil
        automata = nil
    }

    // MARK: - Query

    func isHangul(_ ascii: String) -> Bool {
        keyboard?.isHangul(ascii) ?? false
    }

    func additional(_ ascii: String) -> String? {
        keyboard?.etcLayout[ascii]
    }

    // MARK: - Processing

    func process(_ ascii: String) -> Bool {
        guard let keyboard = keyboard, var automata = automata else {
            Log.shared.error("[Automata] process failed: keyboard not initialized")
            return false
        }
        guard isHangul(ascii) else {
            return false
        }

        keyboard.timingManager.updateInputDelta()
        keyboard.timingManager.recordKeyInput()
        automata.current.append(ascii)
        self.automata = automata

        processComposition()
        return true
    }

    func processAbbreviation(_ key: String) -> Bool {
        guard let keyboard = keyboard else {
            Log.shared.error("[Automata] processAbbreviation failed: keyboard not initialized")
            return false
        }

        guard let abbreviation = keyboard.abbreviations[key] else {
            Log.shared.debug("[Automata] abbreviation not found: '\(key)'")
            return false
        }

        Log.shared.debug("[Automata] abbreviation '\(key)' → '\(abbreviation)'")
        flush()
        committed += abbreviation.utf16
        return true
    }

    func backspace() -> Bool {
        guard var automata = automata, let keyboard = keyboard else {
            Log.shared.error("[Automata] backspace failed: keyboard not initialized")
            return false
        }
        guard !automata.current.isEmpty else {
            return false
        }

        automata.current.removeLast()
        self.automata = automata
        keyboard.timingManager.removeLastInputTime()

        processComposition(nobreak: true)
        return true
    }

    func flush() {
        guard var automata = automata, let keyboard = keyboard else {
            // flush는 start() 전에 호출될 수 있으므로 debug 레벨로 기록
            if self.keyboard == nil {
                Log.shared.debug("[Automata] flush skipped: keyboard not initialized")
            }
            return
        }
        guard !automata.current.isEmpty else {
            return
        }

        var comp = automata.run(nobreak: true)
        while comp.done {
            setCommit(comp)
            comp = automata.run()
        }
        setCommit(comp)

        automata.current.removeAll()
        self.automata = automata
        keyboard.timingManager.clearInputTimes()
    }

    // MARK: - Output

    func consumeCommit() -> [unichar] {
        defer { committed.removeAll() }
        return committed
    }

    func consumePreedit() -> [unichar] {
        defer { preediting.removeAll() }
        return preediting
    }

    // MARK: - Private

    private func processComposition(nobreak: Bool = false) {
        guard var automata = automata else { return }

        var comp = automata.run(nobreak: nobreak)
        while comp.done {
            setCommit(comp)
            comp = automata.run()
        }
        setPreedit(comp)
        self.automata = automata
    }

    private func setCommit(_ comp: Composition) {
        guard let keyboard = keyboard, comp.size > 0 else { return }
        Log.shared.debug("[Automata] commit \(comp.debugDescription)")
        committed += keyboard.normalization(comp)
    }

    private func setPreedit(_ comp: Composition) {
        guard let keyboard = keyboard, comp.size > 0 else { return }
        Log.shared.debug("[Automata] preedit \(comp.debugDescription)")
        preediting += keyboard.normalization(comp)
    }
}
