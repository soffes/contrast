//
//  PopoverController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/2/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol PopoverControllerDelegate: class {
	func popoverControllerWillShow(popover: NSPopover) -> NSView?
	func popoverControllerDidShow(popover: NSPopover)
	func popoverControllerDidDismiss(popover: NSPopover)
	func popoverControllerDidDetach(popover: NSPopover)
}

final class PopoverController: NSObject {

	// MARK: - Properties

	let popover: NSPopover

	weak var delegate: PopoverControllerDelegate?


	// MARK: - Initializers

	override init() {
		// Create popover
		popover = NSPopover()
		popover.animates = false
		popover.contentViewController = PopoverViewController()

		super.init()

		popover.delegate = self

		// Register for notifications
		NotificationCenter.default.addObserver(self, selector: #selector(didResignActive), name: .NSApplicationWillResignActive, object: nil)
	}


	// MARK: - Actions

	func togglePopover(_ sender: Any?) {
		if popover.isShown {
			if popover.isDetached {
				dismissPopover(sender)
				showPopover(sender)
				return
			}
			dismissPopover(sender)
		} else {
			showPopover(sender)
		}
	}

	func showPopover(_ sender: Any?) {
		guard let view = delegate?.popoverControllerWillShow(popover: popover) else { return }

		NSApp.activate(ignoringOtherApps: true)
		popover.show(relativeTo: view.bounds, of: view, preferredEdge: .minY)
	}

	@objc func dismissPopover(_ sender: Any?) {
		popover.close()

		if NSApp.isActive {
			NSApp.deactivate()
		}
	}

	@objc private func didResignActive(_ notification: NSNotification?) {
		// Don't close when it's detached
		if popover.isDetached {
			return
		}

		dismissPopover(notification)
	}
}


extension PopoverController: NSPopoverDelegate {
	func popoverDidShow(_ notification: Notification) {
		delegate?.popoverControllerDidShow(popover: popover)
	}

	func popoverDidClose(_ notification: Notification) {
		delegate?.popoverControllerDidDismiss(popover: popover)
	}

	func popoverShouldDetach(_ popover: NSPopover) -> Bool {
		return true
	}

	func popoverDidDetach(_ popover: NSPopover) {
		delegate?.popoverControllerDidDetach(popover: popover)
	}
}
