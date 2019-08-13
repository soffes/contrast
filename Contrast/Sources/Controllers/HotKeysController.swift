import HotKey

final class HotKeysController {

	// MARK: - Properties

	var showHotKey: HotKey? {
		didSet {
			Preferences.shared.showKeyCombo = showHotKey?.keyCombo
			updateShowHotKey()
		}
	}

	var foregroundHotKey: HotKey? {
		didSet {
			Preferences.shared.foregroundKeyCombo = foregroundHotKey?.keyCombo
			updateForegroundHotKey()
		}
	}

	var backgroundHotKey: HotKey? {
		didSet {
			Preferences.shared.backgroundKeyCombo = backgroundHotKey?.keyCombo
			updateBackgroundHotKey()
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
		updateShowHotKey()

		foregroundHotKey = Preferences.shared.foregroundKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		updateForegroundHotKey()

		backgroundHotKey = Preferences.shared.backgroundKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		updateBackgroundHotKey()
	}

	// MARK: - Hot Key Information

	func isAvailable(keyCombo: KeyCombo) -> Bool {
		if showHotKey?.keyCombo == keyCombo || foregroundHotKey?.keyCombo == keyCombo ||
			backgroundHotKey?.keyCombo == keyCombo
		{
			return false
		}

		return true
	}

	// MARK: - Actions

	private func togglePopover() {
		MenuBarController.shared?.popoverController.togglePopover()
	}

	private func pickForegroundColor() {
		guard let controller = MenuBarController.shared?.popoverController else {
			return
		}

		controller.showPopover()
		if let viewController = controller.popover.contentViewController as? ColorsViewController {
			viewController.pickForeground()
		}
	}

	private func pickBackgroundColor() {
		guard let controller = MenuBarController.shared?.popoverController else {
			return
		}

		controller.showPopover()
		if let viewController = controller.popover.contentViewController as? ColorsViewController {
			viewController.pickBackground()
		}
	}

	// MARK: - Private

	private func updateShowHotKey() {
		showHotKey?.isPaused = isPaused
		showHotKey?.keyDownHandler = { [weak self] in
			self?.togglePopover()
		}
	}

	private func updateForegroundHotKey() {
		foregroundHotKey?.isPaused = isPaused
		foregroundHotKey?.keyDownHandler = { [weak self] in
			self?.pickForegroundColor()
		}
	}

	private func updateBackgroundHotKey() {
		backgroundHotKey?.isPaused = isPaused
		backgroundHotKey?.keyDownHandler = { [weak self] in
			self?.pickBackgroundColor()
		}
	}
}
