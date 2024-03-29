import AppKit

final class MenuBarController: NSObject {

	// MARK: - Properties

	private let statusItem: NSStatusItem

	let popoverController = PopoverController()

	static var shared: MenuBarController? {
		(NSApp.delegate as? AppDelegate)?.menuBarController
	}

	var isShowingPopover: Bool {
		popoverController.popover.isShown
	}

	// MARK: - Initializers

	override init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.button?.image = #imageLiteral(resourceName: "MenuBarIcon")

		super.init()

		popoverController.delegate = self

		// Show popover event
		NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.leftMouseDown) { [weak self] event in
			if event.window == self?.statusItem.button?.window && !event.modifierFlags.contains(NSEvent.ModifierFlags.command) {
				self?.popoverController.togglePopover()
				return nil
			}

			return event
		}
	}

	// MARK: - Actions

	func showPopover() {
		popoverController.showPopover()
	}
}

extension MenuBarController: PopoverControllerDelegate {
	func popoverControllerWillShow(popover: NSPopover) -> NSView? {
		statusItem.button
	}

	func popoverControllerDidShow(popover: NSPopover) {
		statusItem.button?.isHighlighted = true
	}

	func popoverControllerDidDismiss(popover: NSPopover) {
		statusItem.button?.isHighlighted = false
	}

	func popoverControllerDidDetach(popover: NSPopover) {
		statusItem.button?.isHighlighted = false
	}
}
