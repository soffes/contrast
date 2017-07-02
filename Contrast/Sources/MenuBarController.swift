//
//  MenuBarController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class MenuBarController: NSObject {

	// MARK: - Properties

	fileprivate let statusItem: NSStatusItem

	fileprivate let popover: NSPopover

	static var shared: MenuBarController? {
		return (NSApp.delegate as? AppDelegate)?.menuBarController
	}


	// MARK: - Initializers

	override init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system()
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.image = #imageLiteral(resourceName: "MenuBarIcon")

		// Create popover
		popover = NSPopover()
		popover.animates = false
		popover.contentViewController = PopoverViewController()

		super.init()

		// Show popover event
		NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
			if event.window == self?.statusItem.button?.window {
				self?.togglePopover(self?.statusItem.button)
				return nil
			}

			return event
		}

		// Show menu event
		NSEvent.addLocalMonitorForEvents(matching: .rightMouseDown) { [weak self] event in
			if event.window == self?.statusItem.button?.window, let button = self?.statusItem.button {
				self?.showMenu(button, event: event)
				return nil
			}

			return event
		}

		// Register for notifications
		NotificationCenter.default.addObserver(self, selector: #selector(didResignActive), name: .NSApplicationWillResignActive, object: nil)
	}


	// MARK: - Actions

	@objc func showMenu(_ sender: NSButton, event: NSEvent) {
		let menu = NSMenu()
		menu.delegate = self
		menu.addItem(withTitle: "Preferences…", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
		menu.addItem(.separator())
		menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q")

		sender.isHighlighted = true
		statusItem.popUpMenu(menu)
	}

	@objc func togglePopover(_ sender: Any?) {
		if popover.isShown {
			dismissPopover(sender)
		} else {
			showPopover(sender)
		}
	}

	@objc func showPopover(_ sender: Any?) {
		guard let button = statusItem.button else { return }

		button.isHighlighted = true

		NSApp.activate(ignoringOtherApps: true)
		popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
	}

	@objc func dismissPopover(_ sender: Any?) {
		statusItem.button?.isHighlighted = false

		popover.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}

	@objc private func didResignActive(_ notification: NSNotification?) {
		if UserDefaults.standard.bool(forKey: "ContrastAlwaysOnTop") == true {
			return
		}

		dismissPopover(notification)
	}
}


extension MenuBarController: NSMenuDelegate {
	func menuDidClose(_ menu: NSMenu) {
		statusItem.button?.isHighlighted = popover.isShown
	}
}
