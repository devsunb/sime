import InputMethodKit

// MARK: - KeyCode Constants

private enum KeyCode {
    static let enter: UInt16 = 0x24
    static let keypadEnter: UInt16 = 0x4C
    static let tab: UInt16 = 0x30
    static let backspace: UInt16 = 0x33
    static let forwardDelete: UInt16 = 0x75
    static let escape: UInt16 = 0x35
    static let home: UInt16 = 0x73
    static let end: UInt16 = 0x77
    static let pageUp: UInt16 = 0x74
    static let pageDown: UInt16 = 0x79
    static let leftArrow: UInt16 = 0x7B
    static let rightArrow: UInt16 = 0x7C
    static let downArrow: UInt16 = 0x7D
    static let upArrow: UInt16 = 0x7E
    static let f1: UInt16 = 0x7A
    static let f2: UInt16 = 0x78
    static let f3: UInt16 = 0x63
    static let f4: UInt16 = 0x76
    static let f5: UInt16 = 0x60
    static let f6: UInt16 = 0x61
    static let f7: UInt16 = 0x62
    static let f8: UInt16 = 0x64
    static let f9: UInt16 = 0x65
    static let f10: UInt16 = 0x6D
    static let f11: UInt16 = 0x67
    static let f12: UInt16 = 0x6F

    static let compositionKeys: Set<UInt16> = [
        escape, forwardDelete,
        leftArrow, rightArrow, downArrow, upArrow,
        home, end, pageUp, pageDown,
        f1, f2, f3, f4, f5, f6, f7, f8, f9, f10, f11, f12
    ]
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
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?

    // MARK: - Initialization

    override init!(server: IMKServer!, delegate: Any!, client inputClient: Any!) {
        super.init(server: server, delegate: delegate, client: inputClient)
        setupNotificationObservers()
        setupKeyUpMonitorIfNeeded()
        setupEventTap()
    }

    deinit {
        removeKeyUpMonitor()
        removeEventTap()
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
    }

    private func removeKeyUpMonitor() {
        guard let monitor = keyUpMonitor else { return }
        NSEvent.removeMonitor(monitor)
        keyUpMonitor = nil
    }

    private func setupEventTap() {
        guard eventTap == nil else { return }

        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true] as CFDictionary
        guard AXIsProcessTrustedWithOptions(options) else {
            Log.shared.error("[Input] CGEventTap 권한 없음")
            return
        }

        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue)

        // Note: CGEventTap callback에서 self를 참조하기 위해 pointer 사용
        let refcon = Unmanaged.passUnretained(self).toOpaque()

        guard let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: eventMask,
            callback: { _, _, event, refcon -> Unmanaged<CGEvent>? in
                guard let refcon = refcon else { return Unmanaged.passUnretained(event) }
                let controller = Unmanaged<SimeInputController>.fromOpaque(refcon).takeUnretainedValue()
                controller.handleEventTapKeyDown(event)
                return Unmanaged.passUnretained(event)
            },
            userInfo: refcon
        ) else {
            Log.shared.error("[Input] CGEventTap 생성 실패")
            return
        }

        eventTap = tap
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, tap, 0)

        if let source = runLoopSource {
            CFRunLoopAddSource(CFRunLoopGetCurrent(), source, .commonModes)
            CGEvent.tapEnable(tap: tap, enable: true)
        }
    }

    private func removeEventTap() {
        if let tap = eventTap {
            CGEvent.tapEnable(tap: tap, enable: false)
        }
        if let source = runLoopSource {
            CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, .commonModes)
        }
        eventTap = nil
        runLoopSource = nil
    }

    private func handleEventTapKeyDown(_ event: CGEvent) {
        let keyCode = UInt16(event.getIntegerValueField(.keyboardEventKeycode))
        let flags = event.flags

        // Escape, 방향키, Home/End, Page Up/Down, Function 키: modifier 무관하게 항상 Composition
        if KeyCode.compositionKeys.contains(keyCode) {
            commitComposition(client())
            return
        }

        // Cmd/Ctrl/Opt 조합: 모든 키에 대해 Composition
        if flags.contains(.maskCommand) || flags.contains(.maskAlternate) || flags.contains(.maskControl) {
            commitComposition(client())
        }
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
        Log.shared.debug("[Input] activateServer")
        super.activateServer(sender)
        hangul = Hangul()
        hangul.start(OptHandler.shared.keyboardTag)
    }

    override open func deactivateServer(_ sender: Any!) {
        super.deactivateServer(sender)
        hangul.flush()
        updateDisplay(sender)
        hangul.stop()
        Log.shared.debug("[Input] deactivateServer")
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
            .keyDown,
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
            return false
        }

        if keyCode == KeyCode.enter || keyCode == KeyCode.keypadEnter || keyCode == KeyCode.tab {
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
            return
        }
        let flags = keyDownEvent.event.modifierFlags
        guard let client = self.client() else {
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
