import AppKit
import HotKey

protocol ShortcutTextFieldDelegate: AnyObject {
	func shortcutTextField(_ textField: ShortcutTextField, willChoose keyCombo: KeyCombo) -> Bool
	func shortcutTextField(_ textField: ShortcutTextField, didChoose keyCombo: KeyCombo?)
}

final class ShortcutTextField: NSSearchField {

	// MARK: - Properties

	weak var keyComboDelegate: ShortcutTextFieldDelegate?

	var keyCombo: KeyCombo? {
		didSet {
			guard let keyCombo = keyCombo else {
				stringValue = ""
				return
			}

			stringValue = keyCombo.description
		}
	}

	private var monitor: Any? {
		willSet {
			monitor.flatMap(NSEvent.removeMonitor)
		}
	}

	// MARK: - NSObject

	override func awakeFromNib() {
		super.awakeFromNib()

		let searchCell = cell as? NSSearchFieldCell

		// Remove search appearance
		searchCell?.searchButtonCell = nil
		placeholderString = "Choose shortcut"

		// Update clear button
		searchCell?.cancelButtonCell?.target = self
		searchCell?.cancelButtonCell?.action = #selector(clear)
	}

	// MARK: - NSResponder

	@discardableResult
	override func becomeFirstResponder() -> Bool {
		guard super.becomeFirstResponder() else {
			return false
		}

		placeholderString = "Type shortcut"

		monitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
			guard let this = self, let key = Key(carbonKeyCode: UInt32(event.keyCode)) else {
				return nil
			}

			// Escape loses focus
			if key == .escape {
				this.window?.makeFirstResponder(nil)
				return nil
			}

			// TODO: This doesn't work
			if key == .tab {
				this.window?.makeFirstResponder(this.nextKeyView)
				return nil
			}

			let keyCombo = KeyCombo(key: key, modifiers: event.modifierFlags)

			// Delete clears the key combo
			if keyCombo.key == .delete && keyCombo.modifiers.isEmpty {
				this.keyCombo = nil
				this.keyComboDelegate?.shortcutTextField(this, didChoose: keyCombo)
				return nil
			}

			if this.isValid(keyCombo) {
				this.keyCombo = keyCombo
				this.keyComboDelegate?.shortcutTextField(this, didChoose: keyCombo)
				this.window?.makeFirstResponder(nil)
			}

			return nil
		}

		return true
	}

	// MARK: - NSTextField

	override func textDidEndEditing(_ notification: Notification) {
		super.textDidEndEditing(notification)
		placeholderString = "Choose shortcut"
		monitor = nil
	}

	// MARK: - Actions

	@objc
	func clear() {
		keyCombo = nil
		keyComboDelegate?.shortcutTextField(self, didChoose: nil)
	}

	// MARK: - Private

	private func isValid(_ keyCombo: KeyCombo) -> Bool {
		guard let key = keyCombo.key else {
			return false
		}

		switch key {
		case .a, .s, .d, .f, .h, .g, .z, .x, .c, .v, .b, .q, .w, .e, .r, .y, .t, .one, .two, .three, .four, .six, .five,
			 .equal, .nine, .seven, .minus, .eight, .zero, .rightBracket, .o, .u, .leftBracket, .i, .p, .l, .j, .quote,
			 .k, .semicolon, .backslash, .comma, .slash, .n, .m, .period, .grave, .keypadDecimal, .keypadMultiply,
			 .keypadPlus, .keypadClear, .keypadDivide, .keypadEnter, .keypadMinus, .keypadEquals, .keypad0, .keypad1,
			 .keypad2, .keypad3, .keypad4, .keypad5, .keypad6, .keypad7, .keypad8, .keypad9, .`return`, .f17, .f18,
			 .f19, .f20, .f5, .f6, .f7, .f3, .f8, .f9, .f11, .f13, .f16, .f14, .f10, .f12, .f15, .home, .pageUp, .f4,
			 .end, .f2, .pageDown, .f1, .leftArrow, .rightArrow, .downArrow, .upArrow:
			break
		default:
			return false
		}

		// Only valid modifiers
		if keyCombo.modifiers.isEmpty ||
			keyCombo.modifiers.intersection([.command, .option, .shift, .control]) != keyCombo.modifiers
		{
			return false
		}

		let disallowed = KeyCombo.systemKeyCombos() + KeyCombo.mainMenuKeyCombos() + KeyCombo.standardKeyCombos()

		// Don’t allow shortcuts already in use by the system or app
		if disallowed.contains(keyCombo) {
			NSSound.beep()
			return false
		}

		// Let the delegate reject key combo
		if keyComboDelegate?.shortcutTextField(self, willChoose: keyCombo) == false {
			NSSound.beep()
			return false
		}

		return true
	}
}
