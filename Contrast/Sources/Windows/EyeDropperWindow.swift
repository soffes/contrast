import AppKit

protocol EyeDropperWindowDelegate: AnyObject {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPickColor event: NSEvent)
	func eyeDropperWindowDidCancel(_ window: EyeDropperWindow)
}

final class EyeDropperWindow: NSWindow {

	// MARK: - Properties

	weak var customDelegate: EyeDropperWindowDelegate?

	private let view = EyeDropperView()

	var screenshot: Screenshot? {
		view.loupeView.screenshot
	}

	// MARK: - Initializers

	init(frame: CGRect) {
		super.init(contentRect: frame, styleMask: .borderless, backing: .buffered, defer: false)

		identifier = NSUserInterfaceItemIdentifier(rawValue: "com.nothingmagical.contrast.eyedropper")

		backgroundColor = .clear
		isOpaque = false
		hasShadow = false
		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)) + 2)
		isReleasedWhenClosed = false

		contentView = view
		view.updateTrackingAreas()
	}

	// MARK: - NSResponder

	override func mouseDown(with event: NSEvent) {
		customDelegate?.eyeDropperWindow(self, didPickColor: event)
	}

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		// Return
		if event.keyCode == 36 {
			customDelegate?.eyeDropperWindow(self, didPickColor: event)
			return true
		}

		return super.performKeyEquivalent(with: event)
	}

	override func cancelOperation(_ sender: Any?) {
		customDelegate?.eyeDropperWindowDidCancel(self)
	}

	// MARK: - NSWindow

	override var canBecomeKey: Bool {
		true
	}

	override func resignKey() {
		super.resignKey()
		view.loupeView.isHidden = true
	}

	override func becomeKey() {
		super.becomeKey()
		view.loupeView.isHidden = false
		view.positionLoupe(at: mouseLocationOutsideOfEventStream)
	}
}
