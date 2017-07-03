//
//  Theme.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

struct Theme {
	var foregroundColor: NSColor
	var backgroundColor: NSColor

	var isDark: Bool {
		return backgroundColor.isDark
	}

	init(foregroundColor: NSColor, backgroundColor: NSColor) {
		self.foregroundColor = foregroundColor
		self.backgroundColor = backgroundColor
	}

	mutating func swap() {
		let foreground = foregroundColor
		let background = backgroundColor

		foregroundColor = background
		backgroundColor = foreground
	}
}


extension Theme {
	var focusRingColor: NSColor {
		return NSColor(white: isDark ? 1 : 0, alpha: 0.2)
	}
	
	func buttonImageColor(isActive: Bool = false, isHighlighted: Bool) -> NSColor {
		if isActive {
			return .white
		}

		return NSColor(white: isDark ? 1 : 0, alpha: isHighlighted ? 1 : 0.7)
	}
}


extension Theme {
	private static var defaultDarkBackground: NSColor {
		return NSColor(hex: "2e2e2e")!
	}

	private static var defaultDarkForeground: NSColor {
		return NSColor(hex: "ffffff")!
	}

	private static var defaultLightBackground: NSColor {
		return NSColor(hex: "f9f9f9")!
	}

	private static var defaultLightForeground: NSColor {
		return NSColor(hex: "545454")!
	}

	static var `default`: Theme {
		if UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark" { // 🤷🏻‍♂️
			return Theme(foregroundColor: defaultDarkForeground, backgroundColor: defaultDarkBackground)
		}

		return Theme(foregroundColor: defaultLightForeground, backgroundColor: defaultLightBackground)
	}
}
