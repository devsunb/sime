import Foundation
import InputMethodKit

@main
struct SimeApp {
    static func main() {
        Log.shared.info("[App] starting (bundle: \(Bundle.main.bundleIdentifier ?? "unknown"))")

        guard let connectionName = Bundle.main.object(forInfoDictionaryKey: "InputMethodConnectionName") as? String else {
            Log.shared.error("[App] InputMethodConnectionName not found")
            return
        }
        _ = IMKServer(name: connectionName, bundleIdentifier: Bundle.main.bundleIdentifier)
        Log.shared.info("[App] IMKServer created")

        let app = NSApplication.shared
        let delegate = SimeApplicationDelegate()
        app.delegate = delegate

        Log.shared.info("[App] started")
        app.run()
        Log.shared.info("[App] terminated")
    }
}
