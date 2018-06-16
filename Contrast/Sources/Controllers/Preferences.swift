//
//  Preferences.swift
//  Contrast
//
//  Created by Sam Soffes on 7/13/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

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

	private let userDefaults: UserDefaults

	var themeData: Data? {
		get {
			return userDefaults.data(forKey: Key.themeData.rawValue)
		}

		set {
			if let data = newValue {
				userDefaults.set(data, forKey: Key.themeData.rawValue)
			} else {
				userDefaults.removeObject(forKey: Key.themeData.rawValue)
			}
		}
	}

	var isSoundEnabled: Bool {
		get {
			return userDefaults.bool(forKey: Key.soundsEnabled.rawValue)
		}

		set {
			userDefaults.set(newValue, forKey: Key.soundsEnabled.rawValue)
		}
	}

	var isTutorialCompleted: Bool {
		get {
			return userDefaults.bool(forKey: Key.tutorialCompleted.rawValue)
		}

		set {
			userDefaults.set(newValue, forKey: Key.tutorialCompleted.rawValue)
		}
	}

	var usesLowercaseHex: Bool {
		get {
			return userDefaults.bool(forKey: Key.lowercaseHex.rawValue)
		}

		set {
			userDefaults.set(newValue, forKey: Key.lowercaseHex.rawValue)
		}
	}

	var showKeyCombo: KeyCombo? {
		get {
			return getKeyCombo(forKey: .showKeyCombo)
		}

		set {
			set(newValue, forKey: .showKeyCombo)
		}
	}

	var foregroundKeyCombo: KeyCombo? {
		get {
			return getKeyCombo(forKey: .foregroundKeyCombo)
		}

		set {
			set(newValue, forKey: .foregroundKeyCombo)
		}
	}

	var backgroundKeyCombo: KeyCombo? {
		get {
			return getKeyCombo(forKey: .backgroundKeyCombo)
		}

		set {
			set(newValue, forKey: .backgroundKeyCombo)
		}
	}

	var launchAtLogin: Bool {
		get {
			return userDefaults.bool(forKey: Key.launchAtLogin.rawValue)
		}

		set {
			userDefaults.set(newValue, forKey: Key.launchAtLogin.rawValue)
		}
	}


	// MARK: - Initializers

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults

		userDefaults.register(defaults: [
			Key.soundsEnabled.rawValue: true,
			Key.lowercaseHex.rawValue: true
		])
	}


	// MARK: - Private

	private func set(_ keyCombo: KeyCombo?, forKey key: Key) {
		if let keyCombo = keyCombo {
			userDefaults.set(keyCombo.dictionary, forKey: key.rawValue)
		} else {
			userDefaults.removeObject(forKey: key.rawValue)
		}
	}

	private func getKeyCombo(forKey key: Key) -> KeyCombo? {
		return userDefaults.dictionary(forKey: key.rawValue).flatMap({ KeyCombo(dictionary: $0) })
	}
}
