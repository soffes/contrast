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
	private let trackingAreaOptions: NSTrackingAreaOptions = [.activeAlways, .mouseMoved, .mouseEnteredAndExited]

	private let cursor = NSCursor(image: NSImage(size: CGSize(width: 1, height: 1)), hotSpot: .zero)


	// MARK: - Initializers

	init() {
		super.init(frame: .zero)

		loupeView.isHidden = true
		addSubview(loupeView)

		// Setting a background color prevents views under this view from messing the the cursor.
		wantsLayer = true
		layer?.backgroundColor = NSColor(white: 0, alpha: 0.001).cgColor
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
		window?.invalidateCursorRects(for: self)
	}

	override func mouseEntered(with event: NSEvent) {
		loupeView.isHidden = false
		window?.makeKey()
	}

	override func mouseExited(with event: NSEvent) {
		loupeView.isHidden = true
	}

	override func mouseMoved(with event: NSEvent) {
		guard let window = event.window, window == self.window else {
			loupeView.isHidden = true
			return
		}

		loupeView.isHidden = false

		let position = event.locationInWindow
		positionLoupe(at: position)
	}


	// MARK: - NSView

	override func resetCursorRects() {
		super.resetCursorRects()
		addCursorRect(bounds, cursor: cursor)
	}

	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()

		if let window = window {
			cursor.push()

			let position = window.mouseLocationOutsideOfEventStream
			if window.frame.contains(position) {
				loupeView.isHidden = false
				positionLoupe(at: position)
			}
		} else {
			cursor.pop()
		}
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
		loupeView.screenshot = screenshot(at: position).flatMap(Screenshot.init)
	}


	// MARK: - Private

	/// First is the original, second is scaled up
	private func screenshot(at position: CGPoint) -> (NSImage, NSImage)? {
		guard let window = window,
			let screen = window.screen
		else {
			loupeView.isHidden = true
			return nil
		}

		var position = position
		position.x += window.frame.origin.x
		position.y += window.frame.origin.y

		// Take screenshot
		let captureSize = EyeDropperController.captureSize
		let magnification = EyeDropperController.magnification
		let screenshotFrame = CGRect(x: position.x - (captureSize.width / 2), y: screen.frame.height - position.y - (captureSize.height / 2), width: captureSize.width, height: captureSize.height)
		let windowID = UInt32(window.windowNumber)

		guard let cgImage = CGWindowListCreateImage(screenshotFrame, .optionOnScreenBelowWindow, windowID, []) else { return nil }
		let original = NSImage(cgImage: cgImage, size: captureSize)

		// Scale screenshot
		let scaledRect = CGRect(x: magnification / 4, y: magnification / 4, width: captureSize.width * magnification, height: captureSize.height * magnification)
		let scaled = NSImage(size: CGSize(width: captureSize.width * magnification, height: captureSize.height * magnification), flipped: false) { _ in
			guard let gc = NSGraphicsContext.current() else { return false }
			gc.imageInterpolation = .none
			gc.cgContext.draw(cgImage, in: scaledRect)
			return true
		}

		return (original, scaled)
	}
}
