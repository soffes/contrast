import AppKit

final class MenuBarController: NSObject {

	// MARK: - Properties

	private let statusItem: NSStatusItem

	let popoverController = PopoverController()

	static var shared: MenuBarController? {
		(NSApp.delegate as? AppDelegate)?.menuBarController
	}

	// MARK: - Initializers

	override init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.image = #imageLiteral(resourceName: "MenuBarIcon")

		super.init()

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
