//
//  AppDelegate.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit
import HotKey

@NSApplicationMain final class AppDelegate: NSResponder {

	// MARK: - Properties

	let menuBarController = MenuBarController()

	fileprivate var welcomeWindow: NSWindow?
	fileprivate var preferencesWindowController: NSWindowController?


	// MARK: - Actions

	func showPreferences(_ sender: Any?) {
		let windowController = preferencesWindowController ?? PreferencesWindowController()
		preferencesWindowController = windowController
		windowController.showWindow(self)
		windowController.window?.center()
	}
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		mixpanel.track(event: "Launch")

		// Preferences keyboard shortcut
		NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
			if event.modifierFlags.contains(.command) &&  event.characters == "," {
				self?.showPreferences(self)
				return nil
			}
			return event
		}

		// Initialize hot keys
		_ = HotKeysController.shared

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

		let window = CustomWindow(contentViewController: WelcomeViewController())
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
		if preferencesWindowController?.window?.isVisible == false {
			menuBarController.popoverController.showPopover(sender)
		}
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
