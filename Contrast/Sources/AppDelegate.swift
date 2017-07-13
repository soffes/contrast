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
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mixpanel.track(event: "Launch")
		menuBarController.showPopover(self)
	}
}
