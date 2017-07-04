//
//  EyeDropperView.swift
//  Contrast
//
//  Created by Sam Soffes on 7/1/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class EyeDropperView: NSView {
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

	let imageView = NSImageView()

	private let magnification: CGFloat = 20
	private let captureSize = CGSize(width: 17, height: 17)
	private let gridView: GridView

	private var trackingArea: NSTrackingArea?
	private let trackingAreaOptions: NSTrackingAreaOptions = [.activeAlways, .mouseMoved]

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
		self.trackingArea.flatMap(removeTrackingArea)

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
