import AppKit

private extension Theme {
	var closeButtonFill: NSColor {
		NSColor(white: isDark ? 1 : 0, alpha: 0.3)
	}

	func closeButtonImageColor(isHighlighted: Bool) -> NSColor {
		NSColor(white: 0, alpha: isHighlighted ? 0.8 : 0.5)
	}
}

private final class CloseButtonCell: NSButtonCell {

	var theme: Theme = .default

	let buttonRect = CGRect(x: 8, y: 5, width: 12, height: 12)

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
		theme.closeButtonFill.setFill()
		NSBezierPath(ovalIn: buttonRect).fill()

		// Custom focus ring
		if showsFirstResponder {
			theme.focusRingColor.setStroke()

			let path = NSBezierPath(ovalIn: buttonRect.insetBy(dx: -2, dy: -2))
			path.lineWidth = 4
			path.stroke()
		}
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {}

	override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
		super.highlight(flag, withFrame: cellFrame, in: controlView)

		(controlView as? NSButton)?.isHighlighted = flag
	}
}

final class CloseButton: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			buttonCell?.theme = theme
			updateImage()
			setNeedsDisplay()
		}
	}

	let imageView: NSImageView = {
		let view = NSImageView()
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.clear.cgColor
		return view
	}()

	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		focusRingType = .none

		imageView.frame = buttonCell!.buttonRect
		addSubview(imageView)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSResponder

	override var acceptsFirstResponder: Bool {
		false
	}

	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		CGSize(width: 26, height: 21)
	}

	// MARK: - NSControl

	override class var cellClass: AnyClass? {
		get {
			return CloseButtonCell.self
		}

		// swiftlint:disable:next unused_setter_value
		set {}
	}

	// MARK: - NSButton

	override var isHighlighted: Bool {
		didSet {
			updateImage()
		}
	}

	// MARK: - Private

	private var buttonCell: CloseButtonCell? {
		cell as? CloseButtonCell
	}

	private func updateImage() {
		let imageColor = theme.closeButtonImageColor(isHighlighted: isHighlighted)
		imageView.image = #imageLiteral(resourceName: "Close").tinting(with: imageColor)
	}
}
