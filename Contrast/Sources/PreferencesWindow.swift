//
//  PreferencesWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 7/1/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class PreferencesWindow: NSWindow {
	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		let commandKey = NSEventModifierFlags.command.rawValue
		
		if event.type == NSEventType.keyDown {
			if (event.modifierFlags.rawValue & NSEventModifierFlags.deviceIndependentFlagsMask.rawValue) == commandKey {
				if event.charactersIgnoringModifiers == "w" {
					close()
					return true
				}
			}
		}
		
		return super.performKeyEquivalent(with: event)
	}
}
