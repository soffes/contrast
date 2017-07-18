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

	fileprivate var welcomeWindow: NSWindow?
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mixpanel.track(event: "Launch")

		if Preferences.shared.isTutorialCompleted {
			// For some reason it launches all stupid on 10.11
			if #available(OSX 10.12, *) {
				menuBarController.showPopover(self)
			}
			return
		}

		let window = DetachedWindow(contentViewController: WelcomeViewController())
		window.delegate = self

		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(self)
		window.center()
		welcomeWindow = window
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		mixpanel.track(event: "Activiate")
	}
}


extension AppDelegate: NSWindowDelegate {
	func windowWillClose(_ notification: Notification) {
		welcomeWindow = nil

		Preferences.shared.isTutorialCompleted = true
		menuBarController.showPopover(self)
	}
}
