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

	private let arrowView: NSView = {
		let view = NSView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		return view
	}()

	static var shared: MenuBarController? {
		return (NSApp.delegate as? AppDelegate)?.menuBarController
	}

	var backgroundColor: NSColor = .clear {
		didSet {
			arrowView.layer?.backgroundColor = backgroundColor.cgColor

			popover.contentViewController?.view.wantsLayer = true
			popover.contentViewController?.view.layer?.backgroundColor = backgroundColor.cgColor
		}
	}


	// MARK: - Initializers

	init() {
		// Create menu bar item
		let statusBar = NSStatusBar.system()
		statusItem = statusBar.statusItem(withLength: 28)
		statusItem.image = #imageLiteral(resourceName: "MenuBarIcon")

		// Create popover
		popover = NSPopover()
		popover.contentViewController = NSStoryboard(name: "Popover", bundle: nil).instantiateInitialController() as? NSViewController

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

		// Add arrow view hack
		guard let container = popover.contentViewController?.view.superview else { return }

		container.addSubview(arrowView)
		arrowView.layer?.backgroundColor = backgroundColor.cgColor

		NSLayoutConstraint.activate([
			arrowView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
			arrowView.topAnchor.constraint(equalTo: container.topAnchor),
			arrowView.widthAnchor.constraint(equalTo: container.widthAnchor),
			arrowView.heightAnchor.constraint(equalToConstant: 15)
		])
	}

	@objc func dismissPopover(_ sender: Any?) {
		popover.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}
}
