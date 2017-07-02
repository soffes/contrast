//
//  EyeDropperWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class EyeDropperWindow: NSWindow {

	// MARK: - Properties

	private let view = EyeDropperView()

	var image: NSImage? {
		return view.imageView.image
	}


	// MARK: - Initializers

	init() {
		super.init(contentRect: NSScreen.main()?.frame ?? .zero, styleMask: .borderless, backing: .buffered, defer: false)

		identifier = "com.nothingmagical.contrast.eyedropper"
		
		backgroundColor = .clear
		isOpaque = false
		hasShadow = false
		level = Int(CGWindowLevelForKey(.mainMenuWindow)) + 2

		view.setupTracking()
		contentView = view
	}


	// MARK: - NSWindow

	override var canBecomeKey: Bool {
		return true
	}

	override func resignKey() {
		super.resignKey()
		NSCursor.unhide()
		view.reticleView.isHidden = true
	}

	override func becomeKey() {
		super.becomeKey()
		NSCursor.hide()
		view.reticleView.isHidden = false
		view.positionReticle(at: mouseLocationOutsideOfEventStream)
	}
}
