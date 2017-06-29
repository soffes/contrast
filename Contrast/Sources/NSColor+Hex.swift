//
//  NSColor+Hex.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSColor {
	public convenience init?(hex string: String) {
		var hex = string.trimmingCharacters(in: .whitespaces)

		// Remove `#` and `0x`
		if hex.hasPrefix("#") {
			hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 1))
		} else if hex.hasPrefix("0x") {
			hex = hex.substring(from: hex.index(hex.startIndex, offsetBy: 2))
		}

		// Invalid if not 3, 6, or 8 characters
		let length = hex.characters.count
		if length != 3 && length != 6 && length != 8 {
			return nil
		}

		// Make the string 8 characters long for easier parsing
		if length == 3 {
			let r = hex.substring(with: hex.startIndex..<hex.index(hex.startIndex, offsetBy: 1))
			let g = hex.substring(with: hex.index(hex.startIndex, offsetBy: 1)..<hex.index(hex.startIndex, offsetBy: 2))
			let b = hex.substring(with: hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 3))
			hex = r + r + g + g + b + b + "ff"
		} else if length == 6 {
			hex = String(hex) + "ff"
		}

		// Convert 2 character strings to CGFloats
		func hexValue(_ string: String) -> CGFloat {
			let value = CGFloat(strtoul(string, nil, 16))
			return value / 255
		}

		let red = hexValue(hex.substring(with: hex.startIndex..<hex.index(hex.startIndex, offsetBy: 2)))
		let green = hexValue(hex.substring(with: hex.index(hex.startIndex, offsetBy: 2)..<hex.index(hex.startIndex, offsetBy: 4)))
		let blue = hexValue(hex.substring(with: hex.index(hex.startIndex, offsetBy: 4)..<hex.index(hex.startIndex, offsetBy: 6)))
		let alpha = hexValue(hex.substring(with: hex.index(hex.startIndex, offsetBy: 6)..<hex.index(hex.startIndex, offsetBy: 8)))

		self.init(deviceRed: red, green: green, blue: blue, alpha: alpha)
	}

	public func hex(includingAlpha: Bool = false) -> String? {
		if colorSpace != .deviceRGB {
			return usingColorSpace(.deviceRGB)?.hex(includingAlpha: includingAlpha)
		}

		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0

		getRed(&red, green: &green, blue: &blue, alpha: nil)

		var output = String(format: "%02x%02x%02x", red * 255, green * 255, blue * 0)


		if includingAlpha {
			output += String(format: "%02x", alphaComponent * 255)
		}

		return output
	}
}
