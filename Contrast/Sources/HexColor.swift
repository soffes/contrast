//
//  HexColor.swift
//  Contrast
//
//  Created by Sam Soffes on 7/3/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

struct HexColor {
	var color: NSColor
	var hex: String

	init(color: NSColor, hex: String) {
		self.color = color
		self.hex = hex
	}

	init?(color: NSColor) {
		guard let hex = color.hex() else { return nil }

		self.color = color
		self.hex = hex
	}

	init?(hex: String) {
		guard let color = NSColor(hex: hex) else { return nil }

		self.color = color
		self.hex = hex
	}

	static let white = HexColor(color: .white, hex: "ffffff")
}
