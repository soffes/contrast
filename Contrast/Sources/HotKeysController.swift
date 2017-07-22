//
//  HotKeysController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/21/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import HotKey

final class HotKeysController {

	// MARK: - Properties

	var showHotKey: HotKey? {
		didSet {
			Preferences.shared.showKeyCombo = showHotKey?.keyCombo

			showHotKey?.keyDownHandler = { [weak self] in
				self?.togglePopover(self)
			}
		}
	}

	var foregroundHotKey: HotKey? {
		didSet {
			Preferences.shared.foregroundKeyCombo = foregroundHotKey?.keyCombo

			foregroundHotKey?.keyDownHandler = { [weak self] in
				self?.pickForegroundColor(self)
			}
		}
	}

	var backgroundHotKey: HotKey? {
		didSet {
			Preferences.shared.backgroundKeyCombo = backgroundHotKey?.keyCombo

			backgroundHotKey?.keyDownHandler = { [weak self] in
				self?.pickBackgroundColor(self)
			}
		}
	}

	static let shared = HotKeysController()


	// MARK: - Initializers

	private init() {
		showHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		foregroundHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
		backgroundHotKey = Preferences.shared.showKeyCombo.flatMap({ HotKey(keyCombo: $0) })
	}


	// MARK: - Actions

	private func togglePopover(_ sender: Any?) {
		MenuBarController.shared?.popoverController.togglePopover(sender)
	}

	private func pickForegroundColor(_ sender: Any?) {
		// TODO: Implement
	}

	private func pickBackgroundColor(_ sender: Any?) {
		// TODO: Implement
	}
}
