import Foundation

// MARK: - KeyboardKind

enum KeyboardKind: Int {
    case dubeol = 0
    case semoi = 1
}

// MARK: - KeyboardType

protocol KeyboardType: AnyObject {
    var name: String { get }
    var chosungLayout: [String: Chosung] { get set }
    var jungsungLayout: [String: Jungsung] { get }
    var jongsungLayout: [String: Jongsung] { get }
    var etcLayout: [String: String] { get }
    var abbreviations: [String: String] { get }
    var timingManager: InputTimingManager { get }

    func chosungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool
    func jungsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool
    func jongsungProc(comp: inout Composition, nobreak: Bool, current: [String], i: Int) -> Bool
    func fallbackProc(comp: inout Composition, current: [String], i: Int)
    func isHangul(_ ascii: String) -> Bool
    func nfd(_ comp: Composition) -> [unichar]
    func normalization(_ comp: Composition) -> [unichar]
}

// MARK: - KeyboardType Default Implementation

extension KeyboardType {
    func isHangul(_ ascii: String) -> Bool {
        chosungLayout[ascii] != nil ||
        jungsungLayout[ascii] != nil ||
        jongsungLayout[ascii] != nil
    }

    func nfd(_ comp: Composition) -> [unichar] {
        guard comp.size > 0 else { return [] }

        var result: [unichar] = []

        if let cho = chosungLayout[comp.chosung] {
            let value = ChosungHohwanMap[cho]?.rawValue ?? cho.rawValue
            result.append(value)
        }

        if let jung = jungsungLayout[comp.jungsung] {
            let value = JungsungHohwanMap[jung]?.rawValue ?? jung.rawValue
            result.append(value)
        }

        if let jong = jongsungLayout[comp.jongsung] {
            let value = JongsungHohwanMap[jong]?.rawValue ?? jong.rawValue
            result.append(value)
        }

        return result
    }

    func normalization(_ comp: Composition) -> [unichar] {
        let choBase = Chosung.Giyuk.rawValue
        let jungBase = Jungsung.A.rawValue
        let jongBase = Jongsung.Kiyeok.rawValue - 1

        guard let cho = chosungLayout[comp.chosung],
              let jung = jungsungLayout[comp.jungsung] else {
            return nfd(comp)
        }

        let choIdx = Int(cho.rawValue - choBase)
        let jungIdx = Int(jung.rawValue - jungBase)
        var jongIdx = 0

        if let jong = jongsungLayout[comp.jongsung] {
            jongIdx = Int(jong.rawValue - jongBase)
        }

        // NFC: ((초성인덱스 * 588) + (중성인덱스 * 28) + 종성인덱스) + 0xAC00
        let unicode = (choIdx * 588) + (jungIdx * 28) + jongIdx + 0xAC00
        return [unichar(unicode)]
    }
}
