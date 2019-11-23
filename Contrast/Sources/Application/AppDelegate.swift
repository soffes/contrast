import AppKit

@NSApplicationMain final class AppDelegate: NSResponder {

	// MARK: - Properties

	let menuBarController = MenuBarController()

	private var welcomeWindow: NSWindow?
	private var preferencesWindowController: NSWindowController?

	private var isQuietLaunch: Bool {
		CommandLine.arguments.contains("quiet")
	}

	// MARK: - Actions

	@objc func showPreferences(_ sender: Any?) {
		let windowController = preferencesWindowController ?? PreferencesWindowController()
		preferencesWindowController = windowController
		windowController.showWindow(self)
		windowController.window?.center()
	}

	// MARK: - Private

	private func showTutorial() {
		let window = CustomWindow(contentViewController: WelcomeViewController())
		window.delegate = self

		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(self)
		window.center()
		welcomeWindow = window
	}

	@objc private func ping() {
		print("Received ping. Sending pong…")
		let pongName = Notification.Name("com.nothingmagical.contrast.notification.pong")
		DistributedNotificationCenter.default().postNotificationName(pongName, object: nil, userInfo: nil,
																	 options: [.deliverImmediately])
	}
}

extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		// Start Mixpanel
		mixpanel.track(event: "Launch")

		// Setup listener for pings from ContrastHelper
		let pingName = Notification.Name("com.nothingmagical.contrast.notification.ping")
		DistributedNotificationCenter.default().addObserver(self, selector: #selector(ping), name: pingName,
															object: nil)

		// Preferences keyboard shortcut
		NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
			if event.modifierFlags.contains(.command) &&  event.characters == "," {
				self?.showPreferences(self)
				return nil
			}
			return event
		}

		// Initialize hot keys
		_ = HotKeysController.shared

		// Check for tutorial completion
		if !Preferences.shared.isTutorialCompleted {
			// Show tutorial
			showTutorial()
		} else {
			// Don’t show the popover if it’s a quiet launch (i.e. launch at login)
			if isQuietLaunch {
				return
			}

			// For some reason it launches all stupid, so defer it
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
				self?.menuBarController.showPopover()
			}
		}
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		mixpanel.track(event: "Activiate")
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		if preferencesWindowController?.window?.isVisible == false {
			menuBarController.popoverController.showPopover()
		}
		return true
	}
}

extension AppDelegate: NSWindowDelegate {
	func windowWillClose(_ notification: Notification) {
		if (notification.object as? NSWindow) != welcomeWindow {
			return
		}

		welcomeWindow = nil

		Preferences.shared.isTutorialCompleted = true
		menuBarController.showPopover()
	}
}
