import Foundation
import InputMethodKit

@main
struct SimeApp {
    static func main() {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        Log.shared.info("[App] Sime v\(version) (\(build)) started")

        guard let connectionName = Bundle.main.object(forInfoDictionaryKey: "InputMethodConnectionName") as? String else {
            Log.shared.error("[App] InputMethodConnectionName not found")
            return
        }
        _ = IMKServer(name: connectionName, bundleIdentifier: Bundle.main.bundleIdentifier)

        let app = NSApplication.shared
        let delegate = SimeApplicationDelegate()
        app.delegate = delegate
        app.run()
    }
}
