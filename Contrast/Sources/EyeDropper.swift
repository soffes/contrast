//
//  EyeDropper.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol EyeDropperDelegate: class {
	func eyeDropperDidSelectColor(_ color: NSColor, continuePicking: Bool)
	func eyeDropperDidCancel()
}

final class EyeDropper: NSWindowController {

	// MARK: - Properties

	weak var delegate: EyeDropperDelegate?

	private let pasteboard: NSPasteboard = {
		let pasteboard = NSPasteboard.general()
		pasteboard.declareTypes([NSPasteboardTypeString], owner: nil)
		return pasteboard
	}()

	static let magnification: CGFloat = 20
	static let captureSize = CGSize(width: 17, height: 17)


	// MARK: - Initializer

	init(delegate: EyeDropperDelegate) {
		self.delegate = delegate
		let window = EyeDropperWindow()
		super.init(window: window)
		window.customDelegate = self
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSResponder

	override func mouseDown(with event: NSEvent) {
		pickColor(with: event)
	}


	// MARK: - Actions

	@objc func cancel(_ sender: Any?) {
		window?.orderOut(sender)
		delegate?.eyeDropperDidCancel()
	}

	func magnify() {

		showWindow(nil)

		guard let window = window, let view = window.contentView else { return }

		let rect = NSScreen.main()!.frame
		window.setFrame(rect, display: true)
		view.frame = rect

		NSApp.activate(ignoringOtherApps: true)
		window.makeKey()
		window.orderFrontRegardless()
	}


	// MARK: - Private

	fileprivate func pickColor(with event: NSEvent) {
		guard let window = window as? EyeDropperWindow, let color = window.screenshot?.color else { return }

		let shouldContinue = event.modifierFlags.contains(.shift)

		if event.modifierFlags.contains(.option), let hex = color.hex() {
			pasteboard.setString(hex, forType: NSPasteboardTypeString)
			NSSound.contrastCopyColor.forcePlay()
		} else {
			NSSound.contrastPickColor.forcePlay()
		}

		delegate?.eyeDropperDidSelectColor(color, continuePicking: shouldContinue)
	}
}


extension EyeDropper: EyeDropperWindowDelegate {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPressReturn event: NSEvent) {
		pickColor(with: event)
	}
}
