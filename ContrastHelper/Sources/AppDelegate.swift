import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    // MARK: - NSApplicationDelegate

    func applicationDidFinishLaunching(_ notification: Notification) {
        let notificationCenter = DistributedNotificationCenter.default()

        // Setup listener for pongs from Contrast
        let pongName = Notification.Name("com.nothingmagical.contrast.notification.pong")
        notificationCenter.addObserver(self, selector: #selector(launchContrast), name: pongName, object: nil)

        // Post ping
        let pingName = Notification.Name("com.nothingmagical.contrast.notification.ping")
        notificationCenter.postNotificationName(pingName, object: nil, userInfo: nil, options: [.deliverImmediately])

        // Launch after 1 second if we don’t recieve a pong. We delay like this to avoid launching if Contrast is
        // already running.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.launchContrast()
        }
    }

    // MARK: - Private

    @objc private func launchContrast() {
        // Get application path
        var  pathComponents = (Bundle.main.bundlePath as NSString).pathComponents
        pathComponents = Array(pathComponents[0..<(pathComponents.count - 4)])
        let url = URL(fileURLWithPath: NSString.path(withComponents: pathComponents))
        NSLog("Contrast path: \(url.path)")

        // Launch Contrast
        let options: NSWorkspace.LaunchOptions = [.withoutActivation, .andHide]
        do {
            try NSWorkspace.shared.launchApplication(at: url, options: options, configuration: [:])
            NSLog("Launched Contrast. Bye.")
        } catch {
            NSLog("Failed to launch Contrast: \(error)")
        }

        // Quit helper
        NSApp.terminate(self)
    }
}
