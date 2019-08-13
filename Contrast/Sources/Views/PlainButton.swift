import AppKit

private extension Theme {
	func settingsButtonImageColor(isActive: Bool = false, isHighlighted: Bool) -> NSColor {
		if isActive {
			return .white
		}

		return NSColor(white: isDark ? 1 : 0, alpha: isHighlighted ? 1 : 0.5)
	}
}

private final class PlainButtonCell: NSButtonCell {

	var theme: Theme = .default
	var isSettings = false

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {}

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		guard let image = image else { return }

		let bounds = view.bounds

		var rect = CGRect(origin: .zero, size: image.size)
		rect.origin.x += (bounds.width - rect.width) / 2
		rect.origin.y += (bounds.height - rect.height) / 2

		let imageColor = isSettings ? theme.settingsButtonImageColor(isHighlighted: isHighlighted) :
			theme.buttonImageColor(isHighlighted: isHighlighted)

		image.tinting(with: imageColor).draw(in: rect)

		// Custom focus ring
		if showsFirstResponder {
			theme.focusRingColor.setStroke()

			let path = NSBezierPath(roundedRect: view.bounds.insetBy(dx: 2, dy: 7), xRadius: 7, yRadius: 7)
			path.lineWidth = 4
			path.stroke()
		}
	}
}

final class PlainButton: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			buttonCell?.theme = theme
			setNeedsDisplay()

		}
	}

	var isSettings = false {
		didSet {
			buttonCell?.isSettings = isSettings
		}
	}

	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		focusRingType = .none
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		var size = image?.size ?? .zero
		size.width += 8
		size.height += 8
		return size
	}

	// MARK: - NSControl

	override class var cellClass: AnyClass? {
		get {
			return PlainButtonCell.self
		}

		// swiftlint:disable:next unused_setter_value
		set {}
	}

	// MARK: - Private

	private var buttonCell: PlainButtonCell? {
		return cell as? PlainButtonCell
	}
}
