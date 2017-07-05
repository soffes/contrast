//
//  EyeDropperView.swift
//  Contrast
//
//  Created by Sam Soffes on 7/1/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class EyeDropperView: NSView {

	// MARK: - Properties

	let loupeView = LoupeView()

	private var trackingArea: NSTrackingArea?
	private let trackingAreaOptions: NSTrackingAreaOptions = [.activeAlways, .mouseMoved]


	// MARK: - Initializers

	init() {
		super.init(frame: .zero)

		loupeView.isHidden = true
		addSubview(loupeView)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSResponder

	override func updateTrackingAreas() {
		self.trackingArea.flatMap(removeTrackingArea)

		let trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}

	override func mouseMoved(with event: NSEvent) {
		let position = event.locationInWindow
		positionLoupe(at: position)
	}


	// MARK: - Positioning

	func positionLoupe(at position: CGPoint) {
		let position = convert(position, from: nil)

		// Position loupe
		var rect = loupeView.bounds
		rect.origin.x = position.x - rect.width / 2
		rect.origin.y = position.y - rect.height / 2
		loupeView.frame = rect

		// Update image
		let image = screenshot(at: position)
		loupeView.screenshot = image.flatMap(Screenshot.init)
	}


	// MARK: - Private

	private func screenshot(at position: CGPoint) -> NSImage? {
		// TODO: This won't work on multiple screens
		guard let screen = NSScreen.main(), let window = window else { return nil }

		// Take screenshot
		let captureSize = EyeDropper.captureSize
		let magnification = EyeDropper.magnification
		let screenshotFrame = CGRect(x: position.x - (captureSize.width / 2), y: screen.frame.height - position.y - (captureSize.height / 2), width: captureSize.width, height: captureSize.height)
		let windowID = UInt32(window.windowNumber)

		guard let cgImage = CGWindowListCreateImage(screenshotFrame, .optionOnScreenBelowWindow, windowID, []) else { return nil }

		// Scale screenshot
		let scaledRect = CGRect(x: magnification / 4, y: magnification / 4, width: captureSize.width * magnification, height: captureSize.height * magnification)
		let scaled = NSImage(size: CGSize(width: captureSize.width * magnification, height: captureSize.height * magnification), flipped: false) { bounds in
			guard let gc = NSGraphicsContext.current() else { return false }
			gc.imageInterpolation = .none
			gc.cgContext.draw(cgImage, in: scaledRect)
			return true
		}

		return scaled
	}
}
