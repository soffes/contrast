import AppKit

final class PopoverController {

	// MARK: - Properties

	let contentViewController = ColorsViewController(isInPopover: false)

	private lazy var window: NSWindow = {
		let window = CustomWindow(contentViewController: contentViewController)
		window.customCloseButton = true
		return window
	}()

	// MARK: - Actions

	func togglePopover() {
		if window.isVisible {
			dismissPopover()
		} else {
			showPopover()
		}
	}

	@objc func showPopover() {
		guard Preferences.shared.isTutorialCompleted else {
			return
		}

		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(self)
	}

	@objc func dismissPopover() {
		window.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}
}
