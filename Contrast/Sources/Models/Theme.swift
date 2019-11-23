import AppKit

struct Theme {
	var foreground: HexColor

	var foregroundColor: NSColor {
		get {
			foreground.color
		}

		set {
			foreground = HexColor(color: newValue) ?? type(of: self).defaultForeground
		}
	}

	var foregroundHex: String {
		foreground.hex
	}

	var background: HexColor

	var backgroundColor: NSColor {
		get {
			background.color
		}

		set {
			background = HexColor(color: newValue) ?? type(of: self).defaultBackground
		}
	}

	var backgroundHex: String {
		background.hex
	}

	var isDark: Bool {
		backgroundColor.isDark
	}

	init(foreground: HexColor, background: HexColor) {
		self.foreground = foreground
		self.background = background
	}

	mutating func swap() {
		let foreground = self.foreground
		let background = self.background

		self.foreground = background
		self.background = foreground
	}
}

extension Theme {
	var focusRingColor: NSColor {
		NSColor(white: isDark ? 1 : 0, alpha: 0.2)
	}

	func buttonImageColor(isActive: Bool = false, isHighlighted: Bool) -> NSColor {
		if isActive {
			return .white
		}

		return NSColor(white: isDark ? 1 : 0, alpha: isHighlighted ? 1 : 0.7)
	}
}

extension Theme {
	private static var isSystemDark: Bool {
		UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
	}

	private static var defaultBackground: HexColor {
		HexColor(hex: isSystemDark ? "2e2e2e" : "f9f9f9")!
	}

	private static var defaultForeground: HexColor {
		HexColor(hex: isSystemDark ? "ffffff" : "545454")!
	}

	static var `default`: Theme {
		Theme(foreground: defaultForeground, background: defaultBackground)
	}
}

extension Theme {
	var dictionaryRepresentation: [String: Any] {
		[
			"foreground": foregroundHex,
			"background": backgroundHex
		]
	}

	init?(dictionaryRepresentation dictionary: [String: Any]) {
		guard let foreground = (dictionary["foreground"] as? String).flatMap(HexColor.init),
			let background = (dictionary["background"] as? String).flatMap(HexColor.init) else
		{
			return nil
		}

		self.foreground = foreground
		self.background = background
	}
}

extension Theme: Equatable {
	static func == (lhs: Theme, rhs: Theme) -> Bool {
		return lhs.foregroundColor == rhs.foregroundColor && lhs.backgroundColor == rhs.backgroundColor
	}
}
