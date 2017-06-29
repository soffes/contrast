//
//  MenuBarController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class MenuBarController {

	// MARK: - Properties

	private let statusItem: NSStatusItem

	private let popover: NSPopover

	static var shared: MenuBarController? {
		return (NSApp.delegate as? AppDelegate)?.menuBarController
	}


	// MARK: - Initializers

	init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system()
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.image = #imageLiteral(resourceName: "MenuBarIcon")

		// Create popover
		popover = NSPopover()
		popover.contentViewController = PopoverViewController()

		// Setup button in menu bar item
		statusItem.button?.target = self
		statusItem.button?.action = #selector(togglePopover)
		statusItem.button?.sendAction(on: .leftMouseDown)

		// Register for notifications
		NotificationCenter.default.addObserver(self, selector: #selector(dismissPopover), name: .NSApplicationWillResignActive, object: nil)
	}


	// MARK: - Actions

	@objc func togglePopover(_ sender: Any?) {
		if popover.isShown {
			dismissPopover(sender)
		} else {
			showPopover(sender)
		}
	}

	@objc func showPopover(_ sender: Any?) {
		guard let button = statusItem.button else { return }

		NSApp.activate(ignoringOtherApps: true)
		popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
	}

	@objc func dismissPopover(_ sender: Any?) {
		popover.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}
}
