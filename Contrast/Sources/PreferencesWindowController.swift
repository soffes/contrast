//
//  PreferencesWindowController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit
import ShortcutRecorder
import HotKey

final class PreferencesWindowController: NSWindowController {

	// MARK: - Properties

	@IBOutlet var showRecorder: SRRecorderControl!
	@IBOutlet var foregroundRecorder: SRRecorderControl!
	@IBOutlet var backgroundRecorder: SRRecorderControl!


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

		for recorder in [showRecorder, foregroundRecorder, backgroundRecorder] {
			recorder?.delegate = self
		}

		showRecorder.objectValue = Preferences.shared.showKeyCombo?.shortcutRecorderDictionary
		foregroundRecorder.objectValue = Preferences.shared.foregroundKeyCombo?.shortcutRecorderDictionary
		backgroundRecorder.objectValue = Preferences.shared.backgroundKeyCombo?.shortcutRecorderDictionary
	}
}


extension PreferencesWindowController: SRRecorderControlDelegate {
	func shortcutRecorderDidEndRecording(_ recorder: SRRecorderControl!) {
		let value = recorder.objectValue as? [String: Any]

		if recorder === showRecorder {
			HotKeysController.shared.showHotKey = hotKey(from: value)
		} else if recorder === foregroundRecorder {
			HotKeysController.shared.foregroundHotKey = hotKey(from: value)
		} else if recorder === backgroundRecorder {
			HotKeysController.shared.backgroundHotKey = hotKey(from: value)
		}
	}

	private func hotKey(from dictionary: [String: Any]?) -> HotKey? {
		guard let dictionary = dictionary,
			let keyCombo = KeyCombo(shortcutRecorderDictionary: dictionary)
		else { return nil }

		return HotKey(keyCombo: keyCombo)
	}
}
