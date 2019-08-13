import AppKit

final class AboutWindowController: NSWindowController {

	// MARK: - NSResponder

	override var acceptsFirstResponder: Bool {
		return true
	}

	func cancel(_ sender: Any?) {
		close()
	}

	// MARK: - NSWindowController

	override func windowDidLoad() {
		super.windowDidLoad()
		window?.level = .mainMenu
	}
}
