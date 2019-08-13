import AppKit

protocol PopoverControllerDelegate: class {
	func popoverControllerWillShow(popover: NSPopover) -> NSView?
	func popoverControllerDidShow(popover: NSPopover)
	func popoverControllerDidDismiss(popover: NSPopover)
	func popoverControllerDidDetach(popover: NSPopover)
}

final class PopoverController: NSObject {

	// MARK: - Properties

	let popover: NSPopover

	weak var delegate: PopoverControllerDelegate?

	private var detachedWindow: NSWindow?

	// MARK: - Initializers

	override init() {
		// Create popover
		popover = NSPopover()
		popover.animates = false
		popover.contentViewController = ColorsViewController()

		super.init()

		popover.delegate = self

		// Register for notifications
		NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive),
											   name: NSApplication.willResignActiveNotification, object: nil)
	}

	// MARK: - Actions

	func togglePopover() {
		detachedWindow?.close()
		detachedWindow = nil

		if popover.isShown {
			if popover.isDetached {
				dismissPopover()
				showPopover()
				return
			}
			dismissPopover()
		} else {
			showPopover()
		}
	}

	@objc func showPopover() {
		guard Preferences.shared.isTutorialCompleted,
			let view = delegate?.popoverControllerWillShow(popover: popover)
			else { return }

		detachedWindow?.close()
		detachedWindow = nil

		NSApp.activate(ignoringOtherApps: true)
		popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
	}

	@objc func dismissPopover() {
		popover.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}

	@objc private func applicationWillResignActive(_ notification: Notification?) {
		// Don't close when it's detached
		if popover.isDetached {
			return
		}

		dismissPopover()
	}
}

extension PopoverController: NSPopoverDelegate {
	func popoverDidShow(_ notification: Notification) {
		delegate?.popoverControllerDidShow(popover: popover)
	}

	func popoverDidClose(_ notification: Notification) {
		delegate?.popoverControllerDidDismiss(popover: popover)
	}

	func popoverShouldDetach(_ popover: NSPopover) -> Bool {
		return true
	}

	func popoverDidDetach(_ popover: NSPopover) {
		delegate?.popoverControllerDidDetach(popover: popover)
	}

	func detachableWindow(for popover: NSPopover) -> NSWindow? {
		guard let contentViewController = popover.contentViewController as? ColorsViewController else { return nil }

		let viewController = ColorsViewController(theme: contentViewController.theme, isInPopover: false)
		let window = CustomWindow(contentViewController: viewController)
		window.customCloseButton = true
		window.delegate = self
		detachedWindow = window
		return window
	}
}

extension PopoverController: NSWindowDelegate {
	func windowWillClose(_ notification: Notification) {
		detachedWindow = nil
	}
}
