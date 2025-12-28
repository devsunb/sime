import Foundation

// MARK: - KeyboardFactory

enum KeyboardFactory {
    private static var cache: [KeyboardKind: Keyboard] = [:]

    static func create(_ kind: KeyboardKind) -> Keyboard {
        if let cached = cache[kind] {
            return cached
        }

        let keyboard: Keyboard
        switch kind {
        case .dubeol:
            keyboard = KeyboardDubeol()
        case .semoi:
            keyboard = KeyboardSemoi()
        }

        cache[kind] = keyboard
        return keyboard
    }

    static func getDubeolKeyboard() -> KeyboardDubeol? {
        cache[.dubeol] as? KeyboardDubeol
    }

    static func clearCache() {
        cache.removeAll()
    }
}
