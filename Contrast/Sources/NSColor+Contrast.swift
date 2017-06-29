//
//  NSColor+Contrast.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSColor {
	// From https://www.w3.org/TR/WCAG20/#relativeluminancedef
	var relativeLuminance: CGFloat {
		if colorSpace != .sRGB {
			return usingColorSpace(.sRGB)?.relativeLuminance ?? 0
		}

		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0

		getRed(&red, green: &green, blue: &blue, alpha: nil)

		red = red <= 0.03928 ? red / 12.92 : pow(((red + 0.055) / 1.055), 2.4)
		green = green <= 0.03928 ? green / 12.92 : pow(((green + 0.055) / 1.055), 2.4)
		blue = blue <= 0.03928 ? blue / 12.92 : pow(((blue + 0.055) / 1.055), 2.4)

		return 0.2126 * red + 0.7152 * green + 0.0722 * blue
	}

	// From https://www.w3.org/TR/WCAG20/#contrast-ratiodef
	static func contrastRatio(_ color1: NSColor, _ color2: NSColor) -> CGFloat {
		let lum1 = color1.relativeLuminance
		let lum2 = color2.relativeLuminance

		return (max(lum1, lum2) + 0.05) / (min(lum1, lum2) + 0.05)
	}
}
