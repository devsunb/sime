import Cocoa

final class SimeApplicationDelegate: NSObject, NSApplicationDelegate {
    func applicationWillTerminate(_ notification: Notification) {
        Log.shared.info("[App] terminated")
    }
}
