import AppKit
import HotKey

final class ShortcutTextField: NSTextField {

	// MARK: - Properties

	var keyCombo: KeyCombo? {
		didSet {
			guard let keyCombo = keyCombo, let key = keyCombo.key else {
				stringValue = ""
				return
			}

			let modifiers = keyCombo.modifiers.intersection(.deviceIndependentFlagsMask)

			var value = ""

			if modifiers.contains(.command) {
				value += "⌘"
			}

			if modifiers.contains(.option) {
				value += "⌥"
			}

			if modifiers.contains(.shift) {
				value += "⇧"
			}

			if modifiers.contains(.control) {
				value += "⌃"
			}

			value += key.description

			stringValue = value
		}
	}

	private var monitor: Any? {
		willSet {
			monitor.flatMap(NSEvent.removeMonitor)
		}
	}

	// MARK: - NSResponder

	@discardableResult
	override func becomeFirstResponder() -> Bool {
		let isFirstResponder = super.becomeFirstResponder()

		if isFirstResponder {
			monitor = NSEvent.addLocalMonitorForEvents(matching: [.keyDown, .flagsChanged]) { [weak self] event in
				if let key = Key(carbonKeyCode: UInt32(event.keyCode)) {
					if key == .escape {
						self?.window?.makeFirstResponder(nil)
						return nil
					}

					// TODO: This doesn't work
					if key == .tab {
						self?.window?.makeFirstResponder(self?.nextKeyView)
						return nil
					}

					let keyCombo = KeyCombo(key: key, modifiers: event.modifierFlags)

					if self?.isValid(keyCombo) == true {
						self?.keyCombo = keyCombo
					}
				}

				return nil
			}
		}

		return isFirstResponder
	}

	// MARK: - NSTextField

	override func textDidEndEditing(_ notification: Notification) {
		super.textDidEndEditing(notification)
		monitor = nil
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

		// TODO: Blacklist stuff like quit, close, etc.

		return true
	}
}
