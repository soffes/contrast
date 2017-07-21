//
//  MenuController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/16/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class MenuController: NSObject {

	// MARK: - Properties

	static let shared = MenuController()

	private var preferencesWindowController: PreferencesWindowController?


	// MARK: - Initializers

	private override init() {
		super.init()
	}


	// MARK: - Creating Menus

	func createMenu(isInPopover: Bool) -> NSMenu {
		let menu = NSMenu()

		if Preferences.shared.isTutorialCompleted {
			if !isInPopover {
				let attach = NSMenuItem(title: "Attach to Menu Bar", action: #selector(PopoverController.showPopover), keyEquivalent: "")
				attach.target = (NSApp.delegate as? AppDelegate)?.menuBarController.popoverController
				menu.addItem(attach)
				menu.addItem(.separator())
			}

			let preferences = NSMenuItem(title: "Preferences…", action: #selector(showPreferences), keyEquivalent: ",")
			preferences.target = self
			menu.addItem(preferences)

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


	// MARK: - Actions

	@objc private func showGuide(_ sender: Any?) {
		NSWorkspace.shared().open(URL(string: "https://usecontrast.com/guide")!)
	}

	@objc private func showHelp(_ sender: Any?) {
		NSWorkspace.shared().open(URL(string: "https://usecontrast.com/support")!)
	}

	@objc private func showPreferences(_ sender: Any?) {
		let windowController = preferencesWindowController ?? PreferencesWindowController()
		preferencesWindowController = windowController
		windowController.showWindow(self)
		windowController.window?.center()
	}
}
