//
//  ColorsController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/13/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension Notification.Name {
	static let themeDidChange = Notification.Name(rawValue: "ColorsController.themeDidChange")
}

final class ColorsController {

	// MARK: - Properties

	var theme: Theme {
		didSet {
			NotificationCenter.default.post(name: .themeDidChange, object: theme)
		}
	}

	static let shared = ColorsController()


	// MARK: - Initializers

	private init() {
		// TODO: Read from UserDefaults
		theme = .default
	}
}
