import AppKit
import HotKey
import ServiceManagement

final class PreferencesWindowController: NSWindowController {

	// MARK: - Properties

	@IBOutlet var showKeyComboInput: KeyComboInput!
	@IBOutlet var foregroundKeyComboInput: KeyComboInput!
	@IBOutlet var backgroundKeyComboInput: KeyComboInput!


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

        for keyComboInput in [showKeyComboInput, foregroundKeyComboInput, backgroundKeyComboInput] {
            keyComboInput?.delegate = self
        }

        let controller = HotKeysController.shared
        showKeyComboInput.keyCombo = controller.showHotKey?.keyCombo
        foregroundKeyComboInput.keyCombo = controller.foregroundHotKey?.keyCombo
        backgroundKeyComboInput.keyCombo = controller.backgroundHotKey?.keyCombo
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


extension PreferencesWindowController: KeyComboInputDelegate {
    func keyComboInputShouldBeginRecording(_ keyComboInput: KeyComboInput) -> Bool {
        HotKeysController.shared.isPaused = true
        return true
    }

    func keyComboInput(_ keyComboInput: KeyComboInput, canRecordKeyCombo keyCombo: KeyCombo) -> Bool {
        let controller = HotKeysController.shared
        if keyComboInput === showKeyComboInput && controller.showHotKey?.keyCombo == keyCombo {
            return true
        }

        if keyComboInput === foregroundKeyComboInput && controller.foregroundHotKey?.keyCombo == keyCombo {
            return true
        }

        if keyComboInput === backgroundKeyComboInput && controller.backgroundHotKey?.keyCombo == keyCombo {
            return true
        }

        return controller.isAvailable(keyCombo: keyCombo)
    }

    func keyComboInputDidEndRecording(_ keyComboInput: KeyComboInput) {
        let controller = HotKeysController.shared
        let hotKey = keyComboInput.keyCombo.flatMap { HotKey(keyCombo: $0) }

        if keyComboInput === showKeyComboInput {
            controller.showHotKey = hotKey
        } else if keyComboInput === foregroundKeyComboInput {
            controller.foregroundHotKey = hotKey
        } else if keyComboInput === backgroundKeyComboInput {
            controller.backgroundHotKey = hotKey
        }

        controller.isPaused = false
    }
}
