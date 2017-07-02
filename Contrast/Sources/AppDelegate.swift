//
//  AppDelegate.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

@NSApplicationMain final class AppDelegate: NSObject {

	// MARK: - Properties

	let menuBarController = MenuBarController()

	private var preferencesWindowController: NSWindowController?


	// MARK: - Actions

	func showPreferences(_ sender: Any?) {
		let windowController = preferencesWindowController ?? NSStoryboard(name: "Preferences", bundle: nil).instantiateInitialController() as? NSWindowController
		NSApp.activate(ignoringOtherApps: true)
		windowController?.showWindow(sender)

		preferencesWindowController = windowController
	}
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		menuBarController.showPopover(self)
	}
}
