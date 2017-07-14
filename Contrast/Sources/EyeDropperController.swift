//
//  EyeDropperController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol EyeDropperControllerDelegate: class {
	func eyeDropperController(_ controller: EyeDropperController, didSelectColor color: NSColor, continuePicking: Bool)
	func eyeDropperControllerDidCancel(_ controller: EyeDropperController)
}

final class EyeDropperController {

	// MARK: - Properties

	weak var delegate: EyeDropperControllerDelegate?

	private let pasteboard: NSPasteboard = {
		let pasteboard = NSPasteboard.general()
		pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
		return pasteboard
	}()

	static let magnification: CGFloat = 20
	static let captureSize = CGSize(width: 17, height: 17)

	private var windows = [NSWindow]() {
		willSet {
			windows.forEach { $0.orderOut(self) }
		}
	}


	// MARK: - Initializer

	init(delegate: EyeDropperControllerDelegate) {
		self.delegate = delegate
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Actions

	@objc func cancel(_ sender: Any?) {
		windows.forEach { $0.orderOut(sender) }
		delegate?.eyeDropperControllerDidCancel(self)
	}

	func magnify() {
		guard let screens = NSScreen.screens() else { return }

		NSApp.activate(ignoringOtherApps: true)

		windows = screens.map { screen in
			let window = EyeDropperWindow(frame: screen.frame)
			window.customDelegate = self
			window.makeKey()
			window.orderFrontRegardless()
			return window
		}
	}


	// MARK: - Private

	fileprivate func pickColor(with event: NSEvent) {
		guard let window = event.window as? EyeDropperWindow,
			let color = window.screenshot?.color
		else { return }

		let shouldContinue = event.modifierFlags.contains(.shift)

		if event.modifierFlags.contains(.option), let hex = color.hex() {
			pasteboard.setString(hex, forType: NSPasteboardTypeString)
			NSSound.contrastCopyColor.forcePlay()
		} else {
			NSSound.contrastPickColor.forcePlay()
		}

		delegate?.eyeDropperController(self, didSelectColor: color, continuePicking: shouldContinue)
	}

	var picking = false
}


extension EyeDropperController: EyeDropperWindowDelegate {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPickColor event: NSEvent) {
		if !picking {
			pickColor(with: event)
		}
		picking = true
	}

	func eyeDropperWindowDidCancel(_ window: EyeDropperWindow) {
		cancel(window)
	}
}
