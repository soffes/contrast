//
//  MenuController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/16/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class MenuController {
	static let shared = MenuController()

	private init() {}

	func createMenu() -> NSMenu {
		let menu = NSMenu()

		if Preferences.shared.isTutorialCompleted {
			let item = NSMenuItem(title: "Sounds", action: #selector(toggleSounds), keyEquivalent: "")
			item.target = self
			item.state = Preferences.shared.isSoundEnabled ? NSOnState : NSOffState
			menu.addItem(item)

			menu.addItem(.separator())

			let guide = NSMenuItem(title: "Accessibility Guide", action: #selector(showGuide), keyEquivalent: "")
			guide.target = self
			menu.addItem(guide)

			let help = NSMenuItem(title: "Contrast Help", action: #selector(showHelp), keyEquivalent: "")
			help.target = self
			menu.addItem(help)

			menu.addItem(.separator())
		}

		menu.addItem(withTitle: "Quit Contrast", action: #selector(NSApplication.terminate), keyEquivalent: "q")

		return menu
	}

	@objc private func showGuide(_ sender: Any?) {
		NSWorkspace.shared().open(URL(string: "https://usecontrast.com/guide")!)
	}

	@objc private func showHelp(_ sender: Any?) {
		NSWorkspace.shared().open(URL(string: "https://usecontrast.com/support")!)
	}

	@objc private func toggleSounds(_ sender: Any?) {
		Preferences.shared.isSoundEnabled = !Preferences.shared.isSoundEnabled
	}
}
