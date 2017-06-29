//
//  ColorTests.swift
//  ContrastTests
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import XCTest
@testable import Contrast

final class ColorTests: XCTestCase {
	let color1 = NSColor(hex: "acf")!
	let color2 = NSColor(hex: "222233")!

	func testContrastRatio() {
		XCTAssertEqualWithAccuracy(9.51, NSColor.contrastRatio(color1, color2), accuracy: 0.01)
		XCTAssertEqualWithAccuracy(9.51, NSColor.contrastRatio(color2, color1), accuracy: 0.01)
	}
}
