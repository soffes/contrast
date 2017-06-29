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

	func testRelativeLuminance() {
		XCTAssertEqualWithAccuracy(0.589, color1.relativeLuminance, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(0.017, color2.relativeLuminance, accuracy: 0.001)
	}

	func testContrastRatio() {
		XCTAssertEqualWithAccuracy(9.51, NSColor.contrastRatio(color1, color2), accuracy: 0.01)
		XCTAssertEqualWithAccuracy(9.51, NSColor.contrastRatio(color2, color1), accuracy: 0.01)
	}

	func testYIQ() {
		XCTAssertEqualWithAccuracy(199.648, color1.yiq, accuracy: 0.001)
		XCTAssertEqualWithAccuracy(35.938, color2.yiq, accuracy: 0.001)
	}

	func testIsDark() {
		XCTAssertEqual(false, color1.isDark)
		XCTAssertEqual(true, color2.isDark)
	}
}
