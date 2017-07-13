//
//  Preferences.swift
//  Contrast
//
//  Created by Sam Soffes on 7/13/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Foundation

final class Preferences {

	// MARK: - Types

	private enum Key: String {
		case themeData = "Colors"
		case soundsEnabled = "SoundsEnabled"
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


	// MARK: - Initializers

	init(userDefaults: UserDefaults = .standard) {
		self.userDefaults = userDefaults

		userDefaults.register(defaults: [
			Key.soundsEnabled.rawValue: true
		])
	}
}
