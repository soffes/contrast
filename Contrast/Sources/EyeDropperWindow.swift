//
//  EyeDropperWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol EyeDropperWindowDelegate: class {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPressReturn event: NSEvent)
}

final class EyeDropperWindow: NSWindow {

	// MARK: - Properties

	weak var customDelegate: EyeDropperWindowDelegate?
	
	private let view = EyeDropperView()

	var screenshot: Screenshot? {
		return view.loupeView.screenshot
	}


	// MARK: - Initializers

	init() {
		super.init(contentRect: NSScreen.main()?.frame ?? .zero, styleMask: .borderless, backing: .buffered, defer: false)

		identifier = "com.nothingmagical.contrast.eyedropper"
		
		backgroundColor = .clear
		isOpaque = false
		hasShadow = false
		level = Int(CGWindowLevelForKey(.mainMenuWindow)) + 2

		view.updateTrackingAreas()
		contentView = view
	}


	// MARK: - NSResponder

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		// Return
		if event.keyCode == 36 {
			customDelegate?.eyeDropperWindow(self, didPressReturn: event)
			return true
		}

		return super.performKeyEquivalent(with: event)
	}


	// MARK: - NSWindow

	override var canBecomeKey: Bool {
		return true
	}

	override func resignKey() {
		super.resignKey()
		NSCursor.unhide()
		view.loupeView.isHidden = true
	}

	override func becomeKey() {
		super.becomeKey()
		NSCursor.hide()
		view.loupeView.isHidden = false
		view.positionLoupe(at: mouseLocationOutsideOfEventStream)
	}
}
