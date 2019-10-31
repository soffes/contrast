import Foundation
import HotKey

final class Preferences {

	// MARK: - Types

	enum Key: String {
		case themeData = "Colors"
		case soundsEnabled = "SoundsEnabled"
		case tutorialCompleted = "TutorialCompleted"
		case lowercaseHex = "LowercaseHex"
		case showKeyCombo = "ShowKeyCombo"
		case foregroundKeyCombo = "ForegroundKeyCombo"
		case backgroundKeyCombo = "BackgroundKeyCombo"
		case launchAtLogin = "LaunchAtLogin"
	}

	// MARK: - Properties

	static let shared = Preferences()

	@OptionalUserDefault(.themeData)
	var themeData: Data?

	@UserDefault(.soundsEnabled, defaultValue: false)
	var isSoundEnabled: Bool

	@UserDefault(.tutorialCompleted, defaultValue: false)
	var isTutorialCompleted: Bool

	@UserDefault(.lowercaseHex, defaultValue: false)
	var usesLowercaseHex: Bool

	@KeyComboUserDefault(.showKeyCombo)
	var showKeyCombo: KeyCombo?

	@KeyComboUserDefault(.foregroundKeyCombo)
	var foregroundKeyCombo: KeyCombo?

	@KeyComboUserDefault(.backgroundKeyCombo)
	var backgroundKeyCombo: KeyCombo?

	@UserDefault(.launchAtLogin, defaultValue: false)
	var launchAtLogin: Bool

	// MARK: - Initializers

	init() {
		UserDefaults.standard.register(defaults: [
			Key.soundsEnabled.rawValue: true,
			Key.lowercaseHex.rawValue: true
		])
	}
}
