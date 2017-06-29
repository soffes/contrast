//
//  EyeDropper.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol EyeDropperDelegate: class {
	func eyeDropperDidCancel()
}

final class EyeDropper: NSWindowController {

	// MARK: - Properties

	weak var delegate: EyeDropperDelegate?


	// MARK: - Initializer

	init(delegate: EyeDropperDelegate) {
		self.delegate = delegate
		super.init(window: EyeDropperWindow())
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSResponder

	@objc func cancel(_ sender: Any?) {
		window?.orderOut(sender)
		delegate?.eyeDropperDidCancel()
	}


	// MARK: - Actions

	func magnify() {

		showWindow(nil)

		guard let window = window, let view = window.contentView else { return }

		let rect = NSScreen.main()!.frame
		window.setFrame(rect, display: true)
		view.frame = rect

		NSApp.activate(ignoringOtherApps: true)
		window.makeKeyAndOrderFront(self)
	}
}
