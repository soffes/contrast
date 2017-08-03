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
import ServiceManagement

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


	// MARK: - Actions

	@IBAction func changeLaunchAtLogin(_ sender: Any?) {
		let identifier = "com.nothingmagical.contrast.helper" as CFString
		let launchAtLogin = Preferences.shared.launchAtLogin

		if SMLoginItemSetEnabled(identifier, launchAtLogin) {
			print("Launch at login: \(launchAtLogin)")
		} else {
			print("Failed to change login item")
		}
	}
}


extension PreferencesWindowController: SRRecorderControlDelegate {
	func shortcutRecorderShouldBeginRecording(_ aRecorder: SRRecorderControl!) -> Bool {
		HotKeysController.shared.isPaused = true
		return true
	}

	// TODO: Prevent duplicate shortcuts
	func shortcutRecorder(_ recorder: SRRecorderControl!, canRecordShortcut aShortcut: [AnyHashable : Any]!) -> Bool {
		guard let value = aShortcut as? [String: Any], let keyCombo = KeyCombo(shortcutRecorderDictionary: value) else { return true }

		let controller = HotKeysController.shared

		if recorder === showRecorder {
			return controller.foregroundHotKey?.keyCombo != keyCombo && controller.backgroundHotKey?.keyCombo != keyCombo
		} else if recorder === foregroundRecorder {
			return controller.showHotKey?.keyCombo != keyCombo && controller.backgroundHotKey?.keyCombo != keyCombo
		} else if recorder === backgroundRecorder {
			return controller.foregroundHotKey?.keyCombo != keyCombo && controller.showHotKey?.keyCombo != keyCombo
		}

		return true
	}

	func shortcutRecorderDidEndRecording(_ recorder: SRRecorderControl!) {
		HotKeysController.shared.isPaused = false

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
