import Foundation

// MARK: - Log

final class Log: NSObject {
    static let shared = Log()

    private static let suiteName = "dev.sunb.inputmethod.sime"

    private enum Keys {
        static let debug = "debug"
    }

    private let defaults: UserDefaults
    private let logFile: URL
    private let dateFormatter: DateFormatter
    private let fileManager = FileManager.default
    private var fileHandle: FileHandle?
    private let queue = DispatchQueue(label: "dev.sunb.inputmethod.sime.log", qos: .utility)
    private let lock = NSLock()
    private var _isDebugEnabled: Bool = false
    private var isDebugEnabled: Bool {
        get { lock.withLock { _isDebugEnabled } }
        set { lock.withLock { _isDebugEnabled = newValue } }
    }

    private override init() {
        self.defaults = UserDefaults(suiteName: Log.suiteName) ?? UserDefaults.standard

        let logsDir = fileManager.homeDirectoryForCurrentUser
            .appendingPathComponent("Library")
            .appendingPathComponent("Logs")
        logFile = logsDir.appendingPathComponent("Sime.log")

        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "[yyyy-MM-dd HH:mm:ss.SSS] "

        super.init()

        openLogFile()
        isDebugEnabled = defaults.bool(forKey: Keys.debug)
        defaults.addObserver(self, forKeyPath: Keys.debug, options: [.new], context: nil)
    }

    deinit {
        defaults.removeObserver(self, forKeyPath: Keys.debug)
        closeLogFile()
    }

    // MARK: - Public API

    func info(_ message: String) {
        write(level: "INFO", message: message)
    }

    func error(_ message: String) {
        write(level: "ERROR", message: message)
    }

    func debug(_ message: String) {
        guard isDebugEnabled else { return }
        write(level: "DEBUG", message: message)
    }

    // MARK: - Private

    private func openLogFile() {
        queue.async { [weak self] in
            guard let self else { return }

            let logsDir = logFile.deletingLastPathComponent()
            do {
                try fileManager.createDirectory(at: logsDir, withIntermediateDirectories: true)
            } catch {
                NSLog("[Sime] Failed to create log directory: \(error.localizedDescription)")
                return
            }

            if !fileManager.fileExists(atPath: logFile.path) {
                if !fileManager.createFile(atPath: logFile.path, contents: nil) {
                    NSLog("[Sime] Failed to create log file: \(logFile.path)")
                    return
                }
            }

            do {
                fileHandle = try FileHandle(forWritingTo: logFile)
                fileHandle?.seekToEndOfFile()
            } catch {
                NSLog("[Sime] Failed to open log file: \(error.localizedDescription)")
            }
        }
    }

    private func closeLogFile() {
        queue.async { [weak self] in
            try? self?.fileHandle?.close()
            self?.fileHandle = nil
        }
    }

    private func write(level: String, message: String) {
        queue.async { [weak self] in
            guard let self else { return }
            let timestamp = dateFormatter.string(from: Date())
            let logLine = "\(timestamp)[\(level)] \(message)\n"
            if let data = logLine.data(using: .utf8) {
                try? fileHandle?.write(contentsOf: data)
            }
        }
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == Keys.debug {
            let newValue = change?[.newKey] as? Bool ?? false
            if isDebugEnabled != newValue {
                isDebugEnabled = newValue
                info("[Config] debug=\(newValue)")
            }
        }
    }
}
