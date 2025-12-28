import Foundation

// MARK: - Automata

struct Automata {
    var keyboard: KeyboardType
    var current: [String] = []

    init(_ keyboard: KeyboardType) {
        self.keyboard = keyboard
    }

    mutating func consume(_ comp: Composition) {
        for _ in 0..<comp.size {
            current.removeFirst()
        }
        keyboard.timingManager.consumeInputTimes(comp.size)
    }

    func composite(current: [String], nobreak: Bool = false) -> Composition {
        var comp = Composition()
        for (i, ch) in current.enumerated() {
            if keyboard.chosungProc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                comp.chosung += ch
            } else if keyboard.jungsungProc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                comp.jungsung += ch
            } else if keyboard.jongsungProc(comp: &comp, nobreak: nobreak, current: current, i: i) {
                comp.jongsung += ch
            } else {
                keyboard.fallbackProc(comp: &comp, current: current, i: i)
            }
            if comp.done { break }
        }
        return comp
    }

    mutating func run(nobreak: Bool = false) -> Composition {
        let comp = composite(current: current, nobreak: nobreak)
        if comp.done { consume(comp) }
        return comp
    }
}
