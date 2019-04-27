import AppKit

private final class WelcomeButtonCell: NSButtonCell {

	var isPrimary = false
	private let darkColor = NSColor(red: 17 / 255, green: 17 / 255, blue: 18 / 255, alpha: 1)
	private let lightColor = NSColor(red: 226 / 255, green: 231 / 255, blue: 232 / 255, alpha: 1)

	override func drawBezel(withFrame frame: NSRect, in view: NSView) {
		var backgroundColor = isPrimary ? darkColor : lightColor

		if !NSApp.isActive {
			backgroundColor = backgroundColor.withAlphaComponent(0.7)
		}

		backgroundColor.setFill()

		NSBezierPath(roundedRect: view.bounds.insetBy(dx: 4, dy: 4), xRadius: 4, yRadius: 4).fill()

		if showsFirstResponder {
			NSColor(red: 0, green: 182 / 255, blue: 253 / 255, alpha: 1).setStroke()

			let path = NSBezierPath(roundedRect: view.bounds.insetBy(dx: 2, dy: 2), xRadius: 7, yRadius: 7)
			path.lineWidth = 4
			path.stroke()
		}
	}

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		var foregroundColor = isPrimary ? lightColor : darkColor

		if !NSApp.isActive {
			foregroundColor = foregroundColor.withAlphaComponent(0.7)
		}

		let title = NSAttributedString(string: self.title, attributes: [
			.foregroundColor: foregroundColor,
			.font: NSFont.systemFont(ofSize: 14, weight: NSFont.Weight.medium)
		])

		let size = title.size()
		title.draw(at: CGPoint(x: round((view.bounds.width - size.width) / 2),
                               y: round((view.bounds.height - size.height) / 2) - 2))
	}
}

final class WelcomeButton: NSButton {

	// MARK: - Properties

	var isPrimary = false {
		didSet {
			keyEquivalent = isPrimary ? "\r" : ""
			(cell as? WelcomeButtonCell)?.isPrimary = isPrimary
			setNeedsDisplay()
		}
	}

	private let cursor = NSCursor.pointingHand


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		focusRingType = .none

		NotificationCenter.default.addObserver(self, selector: #selector(activeDidChange),
                                               name: NSApplication.didBecomeActiveNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(activeDidChange),
                                               name: NSApplication.didResignActiveNotification, object: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 130 + 8, height: 48 + 8)
	}

	override func resetCursorRects() {
		super.resetCursorRects()
		addCursorRect(bounds, cursor: cursor)
	}


	// MARK: - NSControl

	override class var cellClass: AnyClass? {
        get {
            return WelcomeButtonCell.self
        }

        // swiftlint:disable:next unused_setter_value
        set {}
	}


	// MARK: - Private

	@objc private func activeDidChange() {
		setNeedsDisplay()
	}
}
