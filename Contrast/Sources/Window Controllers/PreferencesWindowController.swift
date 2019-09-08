import AppKit
import HotKey
import ServiceManagement

final class PreferencesWindowController: NSWindowController {

	// MARK: - Properties

	@IBOutlet private var showRecorder: ShortcutTextField!
	@IBOutlet private var foregroundRecorder: ShortcutTextField!
	@IBOutlet private var backgroundRecorder: ShortcutTextField!

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

		for recorder in [showRecorder, foregroundRecorder, backgroundRecorder] {
			recorder?.keyComboDelegate = self
		}

		let controller = HotKeysController.shared
		showRecorder.keyCombo = controller.showHotKey?.keyCombo
		foregroundRecorder.keyCombo = controller.foregroundHotKey?.keyCombo
		backgroundRecorder.keyCombo = controller.backgroundHotKey?.keyCombo
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

extension PreferencesWindowController: ShortcutTextFieldDelegate {
	func shortcutTextField(_ textField: ShortcutTextField, willChoose keyCombo: KeyCombo) -> Bool {
		if textField === showRecorder && HotKeysController.shared.showHotKey?.keyCombo == keyCombo {
			return true
		}

		if textField === foregroundRecorder && HotKeysController.shared.foregroundHotKey?.keyCombo == keyCombo {
			return true
		}

		if textField === backgroundRecorder && HotKeysController.shared.backgroundHotKey?.keyCombo == keyCombo {
			return true
		}

		return HotKeysController.shared.isAvailable(keyCombo: keyCombo)
	}

	func shortcutTextField(_ textField: ShortcutTextField, didChoose keyCombo: KeyCombo?) {
		let hotKey = keyCombo.flatMap { HotKey(keyCombo: $0) }

		if textField === showRecorder {
			HotKeysController.shared.showHotKey = hotKey
		} else if textField === foregroundRecorder {
			HotKeysController.shared.foregroundHotKey = hotKey
		} else if textField === backgroundRecorder {
			HotKeysController.shared.backgroundHotKey = hotKey
		}
	}
}
