import Foundation

// MARK: - TimeProvider

protocol TimeProvider {
    func now() -> TimeInterval
}

struct SystemTimeProvider: TimeProvider {
    func now() -> TimeInterval {
        Date().timeIntervalSince1970
    }
}

// MARK: - TimingCategory

enum TimingCategory {
    case chosung
    case jungsung
    case jongsung
}

// MARK: - InputTimingManager

final class InputTimingManager {

    // MARK: - Properties

    private let timeProvider: TimeProvider
    private var prevInputTime: TimeInterval
    private var inputDelta: TimeInterval = 0
    private var categoryPrevTimes: [TimingCategory: TimeInterval]
    private var categoryDeltas: [TimingCategory: TimeInterval]
    private(set) var inputTimes: [TimeInterval] = []

    let inputDeltaThreshold: TimeInterval
    let doubleKeyThreshold: TimeInterval

    // MARK: - Initialization

    init(
        inputDeltaThreshold: TimeInterval = 150,
        doubleKeyThreshold: TimeInterval = 150,
        timeProvider: TimeProvider = SystemTimeProvider()
    ) {
        self.inputDeltaThreshold = inputDeltaThreshold
        self.doubleKeyThreshold = doubleKeyThreshold
        self.timeProvider = timeProvider

        let now = timeProvider.now()
        self.prevInputTime = now
        self.categoryPrevTimes = [
            .chosung: now,
            .jungsung: now,
            .jongsung: now
        ]
        self.categoryDeltas = [
            .chosung: 0,
            .jungsung: 0,
            .jongsung: 0
        ]
    }

    // MARK: - General Input Timing

    func updateInputDelta() {
        let now = timeProvider.now()
        inputDelta = (now - prevInputTime) * 1000
        prevInputTime = now
    }

    func isInputDeltaOver() -> Bool {
        inputDelta > inputDeltaThreshold
    }

    func clearInputDelta() {
        inputDelta = inputDeltaThreshold + 1
    }

    // MARK: - Category Input Timing

    func updateCategoryDelta(_ category: TimingCategory) {
        let now = timeProvider.now()
        if let prevTime = categoryPrevTimes[category] {
            categoryDeltas[category] = (now - prevTime) * 1000
        }
        categoryPrevTimes[category] = now
    }

    func isCategoryDeltaOver(_ category: TimingCategory) -> Bool {
        guard let delta = categoryDeltas[category] else { return true }
        return delta > inputDeltaThreshold
    }

    func getCategoryDelta(_ category: TimingCategory) -> TimeInterval {
        categoryDeltas[category] ?? 0
    }

    // MARK: - Input History

    func recordKeyInput() {
        inputTimes.append(timeProvider.now())
    }

    func isDoubleKeyInputFast(at index: Int) -> Bool {
        guard index > 0, index < inputTimes.count else {
            return false
        }

        let delta = (inputTimes[index] - inputTimes[index - 1]) * 1000
        let isFast = delta < doubleKeyThreshold
        Log.shared.debug("[Timing] doubleKey delta=\(String(format: "%.1f", delta))ms → \(isFast ? "쌍자음" : "완성")")
        return isFast
    }

    func consumeInputTimes(_ count: UInt) {
        let removeCount = min(Int(count), inputTimes.count)
        inputTimes.removeFirst(removeCount)
    }

    func removeLastInputTime() {
        guard !inputTimes.isEmpty else { return }
        inputTimes.removeLast()
    }

    func clearInputTimes() {
        inputTimes.removeAll()
    }
}
