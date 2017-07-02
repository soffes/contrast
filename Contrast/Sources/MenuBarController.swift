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

	private let popoverController = PopoverController()

	static var shared: MenuBarController? {
		return (NSApp.delegate as? AppDelegate)?.menuBarController
	}

	var isShowingPopover: Bool {
		return popoverController.popover.isShown
	}


	// MARK: - Initializers

	override init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system()
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.image = #imageLiteral(resourceName: "MenuBarIcon")

		super.init()

		popoverController.delegate = self

		// Show popover event
		NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
			if event.window == self?.statusItem.button?.window {
				self?.popoverController.togglePopover(self?.statusItem.button)
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
	}


	// MARK: - Actions

	func showPopover(_ sender: Any?) {
		popoverController.showPopover(sender)
	}

	func showMenu(_ sender: NSButton, event: NSEvent) {
		let menu = NSMenu()
		menu.delegate = self
		menu.addItem(withTitle: "Preferences…", action: #selector(AppDelegate.showPreferences), keyEquivalent: ",")
		menu.addItem(.separator())
		menu.addItem(withTitle: "Quit", action: #selector(NSApplication.terminate), keyEquivalent: "q")

		sender.isHighlighted = true
		statusItem.popUpMenu(menu)
	}
}


extension MenuBarController: PopoverControllerDelegate {
	func popoverControllerWillShow(popover: NSPopover) -> NSView? {
		return statusItem.button
	}

	func popoverControllerDidShow(popover: NSPopover) {
		statusItem.button?.isHighlighted = true
	}

	func popoverControllerDidDismiss(popover: NSPopover) {
		statusItem.button?.isHighlighted = false
	}
}


extension MenuBarController: NSMenuDelegate {
	func menuDidClose(_ menu: NSMenu) {
		statusItem.button?.isHighlighted = isShowingPopover
	}
}
