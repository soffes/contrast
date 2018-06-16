//
//  HexColor.swift
//  Contrast
//
//  Created by Sam Soffes on 7/3/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit
import Color

struct HexColor {

	// MARK: - Properties

	var color: NSColor
	var hex: String

	static let white = HexColor(color: .white, hex: "ffffff")


	// MARK: - Initializers

	init(color: NSColor, hex: String) {
		self.color = color
		self.hex = hex
	}

	init?(color: NSColor) {
		self.color = color
		self.hex = color.hex
	}

	init?(hex: String) {
		guard let color = NSColor(hex: hex) else { return nil }

		self.color = color
		self.hex = hex
	}


	// MARK: - Mutating

	mutating func lighten(by ratio: CGFloat = 0.01) {
		if color.brightnessComponent == 1 {
			NSBeep()
			return
		}

		color = color.lightening(by: ratio)
		hex = color.hex
	}

	mutating func darken(by ratio: CGFloat = 0.01) {
		if color.brightnessComponent == 0 {
			NSBeep()
			return
		}

		color = color.darkening(by: ratio)
		hex = color.hex
	}
}
