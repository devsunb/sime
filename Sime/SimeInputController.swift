import InputMethodKit

// MARK: - KeyCode Constants

private enum KeyCode {
    static let enter: UInt16 = 0x24
    static let tab: UInt16 = 0x30
    static let backspace: UInt16 = 0x33
}

// MARK: - SimeInputController

@objc(SimeInputController)
open class SimeInputController: IMKInputController {

    // MARK: - Constants

    private let asciiMap = "asdfhgzxcv\tbqweryt123465=97-80]ou[ip\tlj'k;\\,/nm.\t `"
    private let shiftAsciiMap = "ASDFHGZXCV\tBQWERYT!@#$^%+(&_*)}OU{IP\tLJ\"K:|<?NM>\t ~"
    private let keyUpDeltaThreshold: TimeInterval = 150

    // MARK: - Properties

    private var hangul = Hangul()
    private var keyDownEvents: [NSEvent] = []
    private var prevKeyUpTime: TimeInterval = Date().timeIntervalSince1970
    private var keyUpDelta: TimeInterval = 0
    private var keyUpMonitor: Any?

    // MARK: - Initialization

    override init!(server: IMKServer!, delegate: Any!, client inputClient: Any!) {
        super.init(server: server, delegate: delegate, client: inputClient)
        setupNotificationObservers()
        setupKeyUpMonitorIfNeeded()
    }

    deinit {
        removeKeyUpMonitor()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Setup

    private func setupNotificationObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardDidChange(_:)),
            name: .keyboardDidChange,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(processOnKeyUpDidChange(_:)),
            name: .processOnKeyUpDidChange,
            object: nil
        )
    }

    private func setupKeyUpMonitorIfNeeded() {
        if OptHandler.shared.processOnKeyUp != 0 {
            setupKeyUpMonitor(prompt: true)
        }
    }

    private func setupKeyUpMonitor(prompt: Bool) {
        guard keyUpMonitor == nil else { return }

        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: prompt] as CFDictionary
        guard AXIsProcessTrustedWithOptions(options) else {
            Log.shared.error("[Input] keyUp 모니터 권한 없음")
            return
        }

        keyUpMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyUp) { [weak self] event in
            self?.handleKeyUp(event)
        }
        Log.shared.debug("[Input] keyUp 모니터 설정됨")
    }

    private func removeKeyUpMonitor() {
        guard let monitor = keyUpMonitor else { return }
        NSEvent.removeMonitor(monitor)
        keyUpMonitor = nil
        Log.shared.debug("[Input] keyUp 모니터 해제됨")
    }

    // MARK: - Notification Handlers

    @objc private func keyboardDidChange(_ notification: Notification) {
        guard let tag = notification.userInfo?["tag"] as? Int else { return }
        hangul.flush()
        hangul.stop()
        hangul.start(tag)
    }

    @objc private func processOnKeyUpDidChange(_ notification: Notification) {
        guard let enabled = notification.userInfo?["enabled"] as? Bool else { return }
        if enabled {
            setupKeyUpMonitor(prompt: true)
        } else {
            removeKeyUpMonitor()
        }
    }

    // MARK: - IMKInputController Overrides

    override open func activateServer(_ sender: Any!) {
        Log.shared.info("[Input] activateServer")
        super.activateServer(sender)
        hangul = Hangul()
        hangul.start(OptHandler.shared.keyboardTag)
    }

    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        hangul.flush()
        updateDisplay(sender)
        hangul.stop()
        Log.shared.info("[Input] deactivateServer")
    }

    override open func handle(_ event: NSEvent!, client sender: Any!) -> Bool {
        switch event.type {
        case .keyDown:
            let eaten = handleKeyDown(event, sender)
            if !eaten { commitComposition(sender) }
            return eaten
        case .leftMouseDown, .leftMouseUp, .leftMouseDragged,
             .rightMouseDown, .rightMouseUp, .rightMouseDragged:
            commitComposition(sender)
            return false
        default:
            return false
        }
    }

    override open func commitComposition(_ sender: Any!) {
        hangul.flush()
        updateDisplay(sender)
    }

    override open func recognizedEvents(_ sender: Any!) -> Int {
        Int(NSEvent.EventTypeMask(arrayLiteral:
            .keyDown, .flagsChanged,
            .leftMouseUp, .rightMouseUp, .leftMouseDown, .rightMouseDown,
            .leftMouseDragged, .rightMouseDragged,
            .appKitDefined, .applicationDefined, .systemDefined
        ).rawValue)
    }

    override open func mouseDown(
        onCharacterIndex index: Int,
        coordinate point: NSPoint,
        withModifier flags: Int,
        continueTracking keepTracking: UnsafeMutablePointer<ObjCBool>!,
        client sender: Any!
    ) -> Bool {
        commitComposition(sender)
        return false
    }

    override open func menu() -> NSMenu! { nil }

    // MARK: - Key Event Handling

    private func handleKeyDown(_ event: NSEvent, _ client: Any!) -> Bool {
        let keyCode = event.keyCode
        let flags = event.modifierFlags

        if flags.contains(.command) || flags.contains(.option) || flags.contains(.control) {
            Log.shared.debug("[Input] modifier key: \(keyCode)")
            flushKeyDownEvents()
            hangul.flush()
            updateDisplay(client)
            return false
        }

        if keyCode == KeyCode.enter || keyCode == KeyCode.tab {
            Log.shared.debug("[Input] enter/tab")
            flushKeyDownEvents()
            hangul.flush()
            updateDisplay(client)
            return false
        }

        if keyCode == KeyCode.backspace {
            Log.shared.debug("[Input] backspace")
            flushKeyDownEvents()
            let remain = hangul.backspace()
            if remain { updateDisplay(client, backspace: true) }
            return remain
        }

        guard let ascii = toAscii(keyCode, flags) else {
            Log.shared.debug("[Input] bypass keyCode=\(keyCode)")
            flushKeyDownEvents()
            hangul.flush()
            updateDisplay(client)
            return false
        }

        if OptHandler.shared.processOnKeyUp == 1 {
            if !hangul.isHangul(ascii) {
                let extra = hangul.additional(ascii) ?? ascii
                Log.shared.debug("[Input] non-hangul '\(ascii)' → '\(extra)'")
                flushKeyDownEvents()
                hangul.flush()
                updateDisplay(client, additional: extra)
                return true
            }

            if event.isARepeat { return true }
            keyDownEvents.append(event)
            Log.shared.debug("[Input] keyDown queued '\(ascii)'")
            return true
        }

        Log.shared.debug("[Input] process '\(ascii)'")
        process(client, ascii)
        return true
    }

    private func handleKeyUp(_ event: NSEvent) {
        let keyCode = event.keyCode
        guard let keyDownEvent = getKeyDownEvent(keyCode) else {
            Log.shared.debug("[Input] keyUp ignored: no matching keyDown for keyCode=\(keyCode)")
            return
        }
        let flags = keyDownEvent.event.modifierFlags
        guard let client = self.client() else {
            Log.shared.debug("[Input] keyUp ignored: client unavailable")
            return
        }

        updateKeyUpDelta()

        if keyUpDelta > keyUpDeltaThreshold {
            let asciis = keyDownEvents.compactMap { toAscii($0.keyCode, $0.modifierFlags) }
            if hangul.processAbbreviation(asciis.sorted().joined()) {
                keyDownEvents.removeAll()
                updateDisplay(client)
                return
            }
        }

        keyDownEvents.remove(at: keyDownEvent.index)

        guard let ascii = toAscii(keyCode, flags) else {
            Log.shared.debug("[Input] keyUp ignored: toAscii failed for keyCode=\(keyCode)")
            return
        }
        process(client, ascii)
    }

    // MARK: - Helper Methods

    private func toAscii(_ keyCode: UInt16, _ flags: NSEvent.ModifierFlags) -> String? {
        guard keyCode < asciiMap.count else { return nil }
        let index = asciiMap.index(asciiMap.startIndex, offsetBy: Int(keyCode))
        return flags.contains(.shift) ? String(shiftAsciiMap[index]) : String(asciiMap[index])
    }

    private func process(_ client: Any!, _ ascii: String) {
        if hangul.process(ascii) {
            updateDisplay(client)
        } else {
            let extra = hangul.additional(ascii) ?? ascii
            Log.shared.debug("[Input] non-hangul '\(ascii)' → '\(extra)'")
            hangul.flush()
            updateDisplay(client, additional: extra)
        }
    }

    private func getKeyDownEvent(_ keyCode: UInt16) -> (index: Int, event: NSEvent)? {
        for (index, event) in keyDownEvents.enumerated() {
            if event.keyCode == keyCode { return (index, event) }
        }
        return nil
    }

    private func flushKeyDownEvents() {
        for event in keyDownEvents { handleKeyUp(event) }
        keyDownEvents.removeAll()
    }

    private func updateKeyUpDelta() {
        let now = Date().timeIntervalSince1970
        keyUpDelta = (now - prevKeyUpTime) * 1000
        prevKeyUpTime = now
    }

    private func updateDisplay(_ client: Any!, backspace: Bool = false, additional: String = "") {
        let committedArray = hangul.consumeCommit()
        let preeditingArray = hangul.consumePreedit()
        guard let display = client as? IMKTextInput else { return }

        let committed = String(utf16CodeUnits: committedArray, count: committedArray.count) + additional
        let preediting = String(utf16CodeUnits: preeditingArray, count: preeditingArray.count)

        if !committed.isEmpty || !preediting.isEmpty {
            Log.shared.debug("[Input] commit='\(committed)' preedit='\(preediting)'")
        }

        if !committed.isEmpty {
            display.insertText(committed, replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
        }

        if !preediting.isEmpty || backspace {
            display.setMarkedText(
                preediting,
                selectionRange: NSRange(location: 0, length: preediting.count),
                replacementRange: NSRange(location: NSNotFound, length: NSNotFound)
            )
        }
    }
}
