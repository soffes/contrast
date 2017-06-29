//
//  EyeDropper.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

protocol EyeDropperDelegate: class {
	func eyeDropperDidSelectColor(_ color: NSColor)
	func eyeDropperDidCancel()
}

final class EyeDropper: NSWindowController {

	// MARK: - Properties

	weak var delegate: EyeDropperDelegate?


	// MARK: - Initializer

	init(delegate: EyeDropperDelegate) {
		self.delegate = delegate
		super.init(window: EyeDropperWindow())

		let click = NSClickGestureRecognizer(target: self, action: #selector(selectColor))
		window?.contentView?.addGestureRecognizer(click)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Actions

	@objc func cancel(_ sender: Any?) {
		window?.orderOut(sender)
		delegate?.eyeDropperDidCancel()
	}

	@objc private func selectColor() {
		if let window = window as? EyeDropperWindow,
			let image = window.image,
			let data = image.tiffRepresentation,
			let rasterized = NSBitmapImageRep(data: data),
			let color = rasterized.colorAt(x: rasterized.pixelsWide / 2, y: rasterized.pixelsHigh / 2) {

				delegate?.eyeDropperDidSelectColor(color)
		}

		cancel(self)
	}

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
