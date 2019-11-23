import AppKit

private extension Theme {
	func textFieldBackground(isFirstResponder: Bool) -> NSColor {
		if isFirstResponder {
			return isDark ? NSColor(white: 0, alpha: 0.4) : NSColor.white
		}

		return isDark ? NSColor(white: 0, alpha: 0.2) : NSColor(white: 0, alpha: 0.05)
	}

	func textFieldBorder(isFirstResponder: Bool) -> NSColor {
		if isFirstResponder {
			return isDark ? NSColor(white: 0, alpha: 0.8) : NSColor(white: 0, alpha: 0.4)
		}

		return isDark ? NSColor(white: 0, alpha: 0.5) : NSColor(white: 0, alpha: 0.2)
	}

	var textFieldTextColor: NSColor {
		isDark ? .white : .black
	}
}

private final class TextFieldCell: NSTextFieldCell {
	var theme: Theme = .default

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		let bounds = view.bounds.insetBy(dx: 4, dy: 4)

		theme.textFieldBorder(isFirstResponder: showsFirstResponder).setStroke()
		NSBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 4, yRadius: 4).stroke()

		theme.textFieldBackground(isFirstResponder: showsFirstResponder).setFill()
		NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 4, yRadius: 4).fill()

		// Custom focus ring
		if showsFirstResponder {
			theme.focusRingColor.setStroke()

			let path = NSBezierPath(roundedRect: view.bounds.insetBy(dx: 2, dy: 2), xRadius: 7, yRadius: 7)
			path.lineWidth = 4
			path.stroke()
		}

		super.drawInterior(withFrame: adjust(frame), in: view)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: adjust(rect), in: controlView, editor: editor, delegate: delegate, event: event)
	}

	override func select(withFrame rect: NSRect, in controlView: NSView, editor: NSText, delegate: Any?, start: Int,
						 length: Int)
	{
		super.select(withFrame: adjust(rect), in: controlView, editor: editor, delegate: delegate, start: start,
					 length: length)
	}

	private func adjust(_ frame: CGRect) -> CGRect {
		frame.insetBy(dx: 10, dy: 5)
	}
}

protocol TextFieldArrowDelegate: class {
	func textField(_ textField: TextField, didPressUpWithShift shift: Bool)
	func textField(_ textField: TextField, didPressDownWithShift shift: Bool)
}

final class TextField: NSTextField {

	// MARK: - Properties

	weak var arrowDelegate: TextFieldArrowDelegate?

	var theme: Theme = .default {
		didSet {
			themeDidChange()
		}
	}

	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		isBordered = false
		isBezeled = false
		backgroundColor = .clear
		focusRingType = .none
		isContinuous = true

		font = .contrastMonoSpace()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSResponder

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		guard isFirstResponder, event.type == .keyDown, let characters = event.charactersIgnoringModifiers else {
			return super.performKeyEquivalent(with: event)
		}

		if let arrowDelegate = arrowDelegate {
			switch characters {
			case String(Character(UnicodeScalar(NSUpArrowFunctionKey)!)):
				arrowDelegate.textField(self, didPressUpWithShift: event.modifierFlags.contains(NSEvent.ModifierFlags.shift))
				return true
			case String(Character(UnicodeScalar(NSDownArrowFunctionKey)!)):
				arrowDelegate.textField(self, didPressDownWithShift: event.modifierFlags.contains(NSEvent.ModifierFlags.shift))
				return true
			default: break
			}
		}

		let commandKey = NSEvent.ModifierFlags.command.rawValue
		let commandShiftKey = NSEvent.ModifierFlags.command.rawValue | NSEvent.ModifierFlags.shift.rawValue

		if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
			switch characters {
			case "x":
				if NSApp.sendAction(#selector(NSText.cut(_:)), to: nil, from: self) {
					return true
				}
			case "c":
				if NSApp.sendAction(#selector(NSText.copy(_:)), to: nil, from: self) {
					return true
				}
			case "v":
				if NSApp.sendAction(#selector(NSText.paste(_:)), to: nil, from: self) {
					return true
				}
			case "z":
				if NSApp.sendAction(Selector(("undo:")), to: nil, from: self) {
					return true
				}
			case "a":
				if NSApp.sendAction(#selector(NSResponder.selectAll(_:)), to: nil, from: self) {
					return true
				}
			default:
				break
			}
		} else if (event.modifierFlags.rawValue & NSEvent.ModifierFlags.deviceIndependentFlagsMask.rawValue)
			== commandShiftKey
		{
			if event.charactersIgnoringModifiers == "Z" {
				if NSApp.sendAction(Selector(("redo:")), to: nil, from: self) {
					return true
				}
			}
		}

		return super.performKeyEquivalent(with: event)
	}

	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 62 + 8, height: 22 + 8)
	}

	// MARK: - NSControl

	override class var cellClass: AnyClass? {
		get {
			TextFieldCell.self
		}

		// swiftlint:disable:next unused_setter_value
		set {}
	}

	// MARK: - Private

	private var textFieldCell: TextFieldCell? {
		cell as? TextFieldCell
	}

	// MARK: - Private

	private func themeDidChange() {
		textFieldCell?.theme = theme
		textColor = theme.textFieldTextColor
		setNeedsDisplay()
	}

	private var isFirstResponder: Bool {
		// Wow.
		(window?.firstResponder as? NSTextView)?.delegate as? NSTextField == self
	}
}
