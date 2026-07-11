import AppKit

func rangeDesc(_ r: NSRange) -> String {
    let loc = r.location == NSNotFound ? "NotFound" : String(r.location)
    let len = r.length == NSNotFound ? "NotFound" : String(r.length)
    return "(\(loc),\(len))"
}

func emit(_ s: String) {
    print(s)
    FileHandle.standardOutput.synchronizeFile()
    fflush(stdout)
}

final class LoggingTextView: NSTextView {
    override func setMarkedText(_ string: Any, selectedRange: NSRange, replacementRange: NSRange) {
        var desc: String
        if let att = string as? NSAttributedString {
            var attrs = ""
            att.enumerateAttributes(in: NSRange(location: 0, length: att.length)) { a, r, _ in
                let pairs = a.map { "\($0.key.rawValue)=\($0.value)" }.joined(separator: ", ")
                attrs += " attrs@\(rangeDesc(r)){\(pairs)}"
            }
            desc = "AttributedString(\"\(att.string)\")\(attrs)"
        } else {
            desc = "String(\"\(string)\")"
        }
        emit("setMarkedText \(desc) selectedRange=\(rangeDesc(selectedRange)) replacementRange=\(rangeDesc(replacementRange))")
        super.setMarkedText(string, selectedRange: selectedRange, replacementRange: replacementRange)
        emit("  -> after: selectedRange()=\(rangeDesc(self.selectedRange())) markedRange()=\(rangeDesc(self.markedRange()))")
    }

    override func insertText(_ string: Any, replacementRange: NSRange) {
        let text = (string as? NSAttributedString)?.string ?? "\(string)"
        emit("insertText \"\(text)\" replacementRange=\(rangeDesc(replacementRange))")
        super.insertText(string, replacementRange: replacementRange)
        emit("  -> after: selectedRange()=\(rangeDesc(self.selectedRange()))")
    }

    override func unmarkText() {
        emit("unmarkText")
        super.unmarkText()
    }

    override func doCommand(by selector: Selector) {
        emit("doCommand \(selector)")
        super.doCommand(by: selector)
    }

    override func keyDown(with event: NSEvent) {
        emit("keyDown keyCode=\(event.keyCode) chars=\(event.characters.map { "\"\($0)\"" } ?? "nil")")
        super.keyDown(with: event)
    }
}

let app = NSApplication.shared
app.setActivationPolicy(.regular)
let win = NSWindow(
    contentRect: NSRect(x: 300, y: 400, width: 480, height: 160),
    styleMask: [.titled, .closable], backing: .buffered, defer: false
)
win.title = "IME logger"
let tv = LoggingTextView(frame: win.contentView!.bounds)
tv.autoresizingMask = [.width, .height]
tv.font = NSFont.systemFont(ofSize: 18)
tv.string = " "
tv.setSelectedRange(NSRange(location: 0, length: 0))
win.contentView?.addSubview(tv)
win.makeKeyAndOrderFront(nil)
win.makeFirstResponder(tv)
app.activate(ignoringOtherApps: true)
emit("ready: 커서가 공백 1개 앞에 있음. 가 + space 입력 후 입력기 전환해서 반복")
app.run()
