import AppKit
import HotKey
import ServiceManagement

final class PreferencesWindowController: NSWindowController {

	// MARK: - Properties

//	@IBOutlet private var showRecorder: SRRecorderControl!
//	@IBOutlet private var foregroundRecorder: SRRecorderControl!
//	@IBOutlet private var backgroundRecorder: SRRecorderControl!

	// MARK: - NSResponder

	override var acceptsFirstResponder: Bool {
		return true
	}

	func cancel(_ sender: Any?) {
		close()
	}

	// MARK: - NSWindowController

	override var windowNibName: NSNib.Name? {
		return "Preferences"
	}

	override func windowDidLoad() {
		super.windowDidLoad()

		window?.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)))

//		for recorder in [showRecorder, foregroundRecorder, backgroundRecorder] {
//			recorder?.delegate = self
//		}

//		let controller = HotKeysController.shared
//		showRecorder.objectValue = controller.showHotKey?.keyCombo.shortcutRecorderDictionary
//		foregroundRecorder.objectValue = controller.foregroundHotKey?.keyCombo.shortcutRecorderDictionary
//		backgroundRecorder.objectValue = controller.backgroundHotKey?.keyCombo.shortcutRecorderDictionary
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

//extension PreferencesWindowController: SRRecorderControlDelegate {
//	func shortcutRecorderShouldBeginRecording(_ aRecorder: SRRecorderControl!) -> Bool {
//		HotKeysController.shared.isPaused = true
//		return true
//	}
//
//	func shortcutRecorder(_ recorder: SRRecorderControl!, canRecordShortcut aShortcut: [AnyHashable: Any]!) -> Bool {
//		guard let value = aShortcut as? [String: Any],
//			let keyCombo = KeyCombo(shortcutRecorderDictionary: value)
//			else { return false }
//
//		if recorder === showRecorder && HotKeysController.shared.showHotKey?.keyCombo == keyCombo {
//			return true
//		}
//
//		if recorder === foregroundRecorder && HotKeysController.shared.foregroundHotKey?.keyCombo == keyCombo {
//			return true
//		}
//
//		if recorder === backgroundRecorder && HotKeysController.shared.backgroundHotKey?.keyCombo == keyCombo {
//			return true
//		}
//
//		return HotKeysController.shared.isAvailable(keyCombo: keyCombo)
//	}
//
//	func shortcutRecorderDidEndRecording(_ recorder: SRRecorderControl!) {
//		let value = recorder.objectValue as? [String: Any]
//
//		if recorder === showRecorder {
//			HotKeysController.shared.showHotKey = hotKey(from: value)
//		} else if recorder === foregroundRecorder {
//			HotKeysController.shared.foregroundHotKey = hotKey(from: value)
//		} else if recorder === backgroundRecorder {
//			HotKeysController.shared.backgroundHotKey = hotKey(from: value)
//		}
//
//		HotKeysController.shared.isPaused = false
//	}
//
//	private func hotKey(from dictionary: [String: Any]?) -> HotKey? {
//		guard let dictionary = dictionary,
//			let keyCombo = KeyCombo(shortcutRecorderDictionary: dictionary)
//			else { return nil }
//
//		return HotKey(keyCombo: keyCombo)
//	}
//}
