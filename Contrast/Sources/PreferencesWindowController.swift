//
//  PreferencesWindowController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class PreferencesWindowController: NSWindowController {

	// MARK: - NSResponder

	override var acceptsFirstResponder: Bool {
		return true
	}

	func cancel(_ sender: Any?) {
		close()
	}


	// MARK: - NSWindowController
	
	override var windowNibName: String? {
		return "Preferences"
	}

	override func windowDidLoad() {
		super.windowDidLoad()
		window?.level = Int(CGWindowLevelForKey(.mainMenuWindow))
	}
}
