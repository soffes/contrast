//
//  AboutWindowController.swift
//  Contrast
//
//  Created by Sam Soffes on 8/1/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class AboutWindowController: NSWindowController {

	// MARK: - NSResponder

	override var acceptsFirstResponder: Bool {
		return true
	}

	func cancel(_ sender: Any?) {
		close()
	}


	// MARK: - NSWindowController

	override func windowDidLoad() {
		super.windowDidLoad()

		window?.level = Int(CGWindowLevelForKey(.mainMenuWindow))
	}
}
