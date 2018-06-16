import AppKit

final class PlainWindow: NSWindow {
	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		if event.modifierFlags.contains(.command) && event.characters == "w" {
			close()
			return true
		}

		return super.performKeyEquivalent(with: event)
	}
}
