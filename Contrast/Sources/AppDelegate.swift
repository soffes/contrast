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

	fileprivate let welcomeWindow = DetachedWindow(contentViewController: WelcomeViewController())
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mixpanel.track(event: "Launch")
		menuBarController.showPopover(self)

		welcomeWindow.center()
		welcomeWindow.makeKeyAndOrderFront(self)
	}

	func applicationDidBecomeActive(_ notification: Notification) {
		mixpanel.track(event: "Activiate")
	}
}
