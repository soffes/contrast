//
//  AppDelegate.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit
import HotKey

@NSApplicationMain final class AppDelegate: NSObject {

	// MARK: - Properties

	let menuBarController = MenuBarController()

	fileprivate let hotKey = HotKey(key: .c, modifiers: [.command, .option, .control])

	fileprivate var welcomeWindow: NSWindow?
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mixpanel.track(event: "Launch")

		hotKey.keyDownHandler = { [weak self] in
			self?.menuBarController.showPopover(self)
		}

		if Preferences.shared.isTutorialCompleted {
			// For some reason it launches all stupid on 10.11, so defer it
			if #available(OSX 10.12, *) {
				menuBarController.showPopover(self)
			} else {
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
					self?.menuBarController.showPopover(self)
				}
			}
			return
		}

		let window = Window(contentViewController: WelcomeViewController())
		window.delegate = self

		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(self)
		window.center()
		welcomeWindow = window
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		mixpanel.track(event: "Activiate")
	}

	func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
		menuBarController.popoverController.showPopover(sender)
		return true
	}
}


extension AppDelegate: NSWindowDelegate {
	func windowWillClose(_ notification: Notification) {
		welcomeWindow = nil

		Preferences.shared.isTutorialCompleted = true
		menuBarController.showPopover(self)
	}
}
