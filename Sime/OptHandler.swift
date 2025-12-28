import Cocoa

// MARK: - Notification Names

extension Notification.Name {
    static let keyboardDidChange = Notification.Name("KeyboardDidChangeNotification")
    static let processOnKeyUpDidChange = Notification.Name("ProcessOnKeyUpDidChangeNotification")
}

// MARK: - OptHandler

final class OptHandler: NSObject {
    static let shared = OptHandler()

    // MARK: - Constants

    private static let suiteName = "dev.sunb.inputmethod.sime"

    private enum Keys {
        static let keyboard = "keyboard"
        static let processOnKeyUp = "processOnKeyUp"
        static let dubeolDouble = "dubeolDouble"
    }

    // MARK: - Properties

    private let defaults: UserDefaults

    @objc dynamic var keyboardTag = 0
    @objc dynamic var processOnKeyUp = 0
    @objc dynamic var dubeolDouble = 0

    // MARK: - Initialization

    private override init() {
        defaults = UserDefaults(suiteName: OptHandler.suiteName) ?? UserDefaults.standard
        super.init()

        registerDefaults()
        loadSettings()
        setupKVO()
    }

    deinit {
        defaults.removeObserver(self, forKeyPath: Keys.keyboard)
        defaults.removeObserver(self, forKeyPath: Keys.processOnKeyUp)
        defaults.removeObserver(self, forKeyPath: Keys.dubeolDouble)
    }

    // MARK: - Setup

    private func registerDefaults() {
        defaults.register(defaults: [
            Keys.keyboard: 0,
            Keys.processOnKeyUp: 0,
            Keys.dubeolDouble: 0
        ])
    }

    private func loadSettings() {
        keyboardTag = defaults.integer(forKey: Keys.keyboard)
        processOnKeyUp = defaults.integer(forKey: Keys.processOnKeyUp)
        dubeolDouble = defaults.integer(forKey: Keys.dubeolDouble)
    }

    private func setupKVO() {
        defaults.addObserver(self, forKeyPath: Keys.keyboard, options: [.new], context: nil)
        defaults.addObserver(self, forKeyPath: Keys.processOnKeyUp, options: [.new], context: nil)
        defaults.addObserver(self, forKeyPath: Keys.dubeolDouble, options: [.new], context: nil)
    }

    // MARK: - KVO

    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        guard let keyPath = keyPath, let newValue = change?[.newKey] as? Int else { return }

        switch keyPath {
        case Keys.keyboard:
            handleKeyboardChange(newValue)
        case Keys.processOnKeyUp:
            handleProcessOnKeyUpChange(newValue)
        case Keys.dubeolDouble:
            handleDubeolDoubleChange(newValue)
        default:
            break
        }
    }

    // MARK: - Change Handlers

    private func handleKeyboardChange(_ newValue: Int) {
        guard keyboardTag != newValue else { return }
        keyboardTag = newValue
        Log.shared.info("[Config] keyboard=\(newValue)")
        NotificationCenter.default.post(
            name: .keyboardDidChange,
            object: nil,
            userInfo: ["tag": newValue]
        )
    }

    private func handleProcessOnKeyUpChange(_ newValue: Int) {
        guard processOnKeyUp != newValue else { return }
        processOnKeyUp = newValue
        Log.shared.info("[Config] processOnKeyUp=\(newValue)")
        NotificationCenter.default.post(
            name: .processOnKeyUpDidChange,
            object: nil,
            userInfo: ["enabled": newValue != 0]
        )
    }

    private func handleDubeolDoubleChange(_ newValue: Int) {
        guard dubeolDouble != newValue else { return }
        dubeolDouble = newValue
        Log.shared.info("[Config] dubeolDouble=\(newValue)")
        KeyboardFactory.getDubeolKeyboard()?.setDoubleConsonant(newValue == 1)
    }
}
