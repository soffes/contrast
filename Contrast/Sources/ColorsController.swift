//
//  ColorsController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/13/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Foundation

extension Notification.Name {
	static let themeDidChange = Notification.Name(rawValue: "ColorsController.themeDidChange")
}

final class ColorsController {

	// MARK: - Properties

	var theme: Theme {
		didSet {
			NotificationCenter.default.post(name: .themeDidChange, object: theme)

			if let data = try? JSONSerialization.data(withJSONObject: theme.dictionaryRepresentation, options: []) {
				UserDefaults.standard.set(data, forKey: "Colors")
			}
		}
	}

	static let shared = ColorsController()


	// MARK: - Initializers

	private init() {
		if let data = UserDefaults.standard.data(forKey: "Colors"), let raw = try? JSONSerialization.jsonObject(with: data, options: []), let json = raw as? [String: Any], let theme = Theme(dictionaryRepresentation: json) {
			self.theme = theme
		} else {
			theme = .default
		}
	}
}
