import HotKey

final class HotKeysController {

	// MARK: - Properties

	var showHotKey: HotKey? {
		didSet {
			Preferences.shared.showKeyCombo = showHotKey?.keyCombo

			showHotKey?.isPaused = isPaused
			showHotKey?.keyDownHandler = { [weak self] in
				self?.togglePopover(self)
			}
		}
	}

	var foregroundHotKey: HotKey? {
		didSet {
			Preferences.shared.foregroundKeyCombo = foregroundHotKey?.keyCombo

			foregroundHotKey?.isPaused = isPaused
			foregroundHotKey?.keyDownHandler = { [weak self] in
				self?.pickForegroundColor(self)
			}
		}
	}

	var backgroundHotKey: HotKey? {
		didSet {
			Preferences.shared.backgroundKeyCombo = backgroundHotKey?.keyCombo

			backgroundHotKey?.isPaused = isPaused
			backgroundHotKey?.keyDownHandler = { [weak self] in
				self?.pickBackgroundColor(self)
			}
		}
	}

	var isPaused = false {
		didSet {
			showHotKey?.isPaused = isPaused
			foregroundHotKey?.isPaused = isPaused
			backgroundHotKey?.isPaused = isPaused
		}
	}

	static let shared = HotKeysController()


	// MARK: - Initializers

	private init() {
		showHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		foregroundHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		backgroundHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
	}


	// MARK: - Hot Key Information

	func isAvailable(keyCombo: KeyCombo) -> Bool {
		if showHotKey?.keyCombo == keyCombo || foregroundHotKey?.keyCombo == keyCombo || backgroundHotKey?.keyCombo == keyCombo {
			return false
		}

		return true
	}


	// MARK: - Actions

	private func togglePopover(_ sender: Any?) {
		MenuBarController.shared?.popoverController.togglePopover(sender)
	}

	private func pickForegroundColor(_ sender: Any?) {
		MenuBarController.shared?.popoverController.showPopover(sender)
		if let viewController = MenuBarController.shared?.popoverController.popover.contentViewController as? ColorsViewController {
			viewController.pickForeground()
		}
	}

	private func pickBackgroundColor(_ sender: Any?) {
		MenuBarController.shared?.popoverController.showPopover(sender)
		if let viewController = MenuBarController.shared?.popoverController.popover.contentViewController as? ColorsViewController {
			viewController.pickBackground()
		}
	}
}
