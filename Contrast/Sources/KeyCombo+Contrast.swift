//
//  KeyCombo+Contrast.swift
//  Contrast
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit
import HotKey
import ShortcutRecorder

extension KeyCombo {
	var shortcutRecorderDictionary: [String: Any] {
		return [
			SRShortcutKeyCode: Int(carbonKeyCode),
			SRShortcutModifierFlagsKey: Int(NSEventModifierFlags(carbonFlags: carbonModifiers).rawValue)
		]
	}

	init?(shortcutRecorderDictionary dictionary: [String: Any]) {
		guard let keyCode = dictionary[SRShortcutKeyCode] as? Int,
			let modifiers = dictionary[SRShortcutModifierFlagsKey] as? Int
		else { return nil }

		let carbonModifiers = NSEventModifierFlags(rawValue: UInt(modifiers)).carbonFlags
		self.init(carbonKeyCode: UInt32(keyCode), carbonModifiers: carbonModifiers)
	}
}
