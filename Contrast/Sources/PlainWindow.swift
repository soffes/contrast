//
//  PlainWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class PlainWindow: NSWindow {
	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		if event.modifierFlags.contains(.command) && event.characters == "w" {
			close()
			return true
		}

		return super.performKeyEquivalent(with: event)
	}
}
