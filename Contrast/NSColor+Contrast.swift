//
//  NSColor+Contrast.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSColor {
	// From https://en.wikipedia.org/wiki/Relative_luminance
	var relativeLuminance: CGFloat {
		if colorSpace != .displayP3 {
			return usingColorSpace(.displayP3)?.relativeLuminance ?? 0
		}

		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0

		getRed(&red, green: &green, blue: &blue, alpha: nil)

		return 0.2126 * red + 0.7152 * green + 0.0722 * blue
	}

	// From https://www.w3.org/TR/WCAG20/#contrast-ratiodef
	static func constrastRatio(_ color1: NSColor, _ color2: NSColor) -> CGFloat {
		let lum1 = color1.relativeLuminance
		let lum2 = color2.relativeLuminance

		return (max(lum1, lum2) + 0.05) / (min(lum1, lum2) + 0.05)
	}
}
