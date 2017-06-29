//
//  EyeDropperWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class EyeDropperWindowView: NSView {
	let reticleView: NSView = {
		let view = NSView(frame: CGRect(x: 0, y: 0, width: 170, height: 170))
		view.isHidden = true

		let layer = CAShapeLayer()
		layer.lineWidth = 4
		layer.path = CGPath(ellipseIn: view.bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2), transform: nil)
		layer.strokeColor = NSColor(white: 0.125, alpha: 1).cgColor
		layer.fillColor = nil

		view.wantsLayer = true
		view.layer = layer

		return view
	}()

	fileprivate let imageView = NSImageView()

	private let magnification: CGFloat = 20
	private let captureSize = CGSize(width: 17, height: 17)
	private let gridView: GridView

	private var trackingArea: NSTrackingArea?
	private let trackingAreaOptions: NSTrackingAreaOptions = [.activeAlways, .mouseMoved, .cursorUpdate, .mouseEnteredAndExited, .activeInActiveApp]

	init() {
		gridView = GridView(rows: Int(captureSize.height), columns: Int(captureSize.width), dimension: magnification / 2)

		super.init(frame: .zero)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func setupTracking() {
		if self.trackingArea != nil {
			return
		}

		let trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea

		addSubview(reticleView)

		let maskPath = CGPath(ellipseIn: reticleView.bounds.insetBy(dx: 4, dy: 4), transform: nil)
		var mask = CAShapeLayer()
		mask.path = maskPath

		imageView.imageAlignment = .alignCenter
		imageView.imageScaling = .scaleNone
		imageView.frame = reticleView.bounds
		imageView.wantsLayer = true
		imageView.layer?.mask = mask
		reticleView.addSubview(imageView)

		mask = CAShapeLayer()
		mask.path = maskPath

		gridView.wantsLayer = true
		gridView.layer?.mask = mask
		reticleView.addSubview(gridView)
	}

	override func updateTrackingAreas() {
		let trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}

	override func mouseMoved(with event: NSEvent) {
		let position = event.locationInWindow

		positionReticle(at: position)
	}

	func positionReticle(at position: CGPoint) {
		// TODO: This won't work on multiple screens
		guard let screen = NSScreen.main(), let window = window else { return }

		let position = convert(position, from: nil)
		
		var rect = reticleView.bounds
		rect.origin.x = position.x - rect.width / 2
		rect.origin.y = position.y - rect.height / 2

		reticleView.frame = rect

		let screenshotFrame = CGRect(x: position.x - (captureSize.width / 2), y: screen.frame.height - position.y - (captureSize.height / 2), width: captureSize.width, height: captureSize.height)
		let windowID = UInt32(window.windowNumber)

		guard let cgImage = CGWindowListCreateImage(screenshotFrame, .optionOnScreenBelowWindow, windowID, []) else { return }

		let scaled = NSImage(size: CGSize(width: captureSize.width * magnification, height: captureSize.height * magnification))
		scaled.lockFocus()

		if let gc = NSGraphicsContext.current() {
			gc.imageInterpolation = .none

			let scaledRect = CGRect(x: 0, y: 0, width: captureSize.width * magnification, height: captureSize.height * magnification)
			gc.cgContext.draw(cgImage, in: scaledRect)
		}

		scaled.unlockFocus()

		imageView.image = scaled
	}
}


final class EyeDropperWindow: NSWindow {

	// MARK: - Properties

	private let view = EyeDropperWindowView()

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
