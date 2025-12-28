import Cocoa

final class SimeApplicationDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        Log.shared.info("[App] didFinishLaunching")
    }

    func applicationWillTerminate(_ notification: Notification) {
        Log.shared.info("[App] willTerminate")
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        Log.shared.info("[App] shouldTerminate")
        return .terminateNow
    }
}
