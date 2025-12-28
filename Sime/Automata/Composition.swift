import Foundation

// MARK: - Composition

struct Composition: CustomDebugStringConvertible {
    var chosung: String = ""
    var jungsung: String = ""
    var jongsung: String = ""
    var done: Bool = false

    var size: UInt {
        UInt(chosung.count + jungsung.count + jongsung.count)
    }

    var debugDescription: String {
        "[\(chosung)] [\(jungsung)] [\(jongsung)]"
    }
}
