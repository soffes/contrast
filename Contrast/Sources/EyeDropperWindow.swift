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

	private let imageView = NSImageView()
	private let gridView = GridView(rows: 17, columns: 17, dimension: 10)

	private var trackingArea: NSTrackingArea?
	private let trackingAreaOptions: NSTrackingAreaOptions = [.activeAlways, .mouseMoved, .cursorUpdate, .mouseEnteredAndExited, .activeInActiveApp]

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

	private func positionReticle(at position: CGPoint) {
		// TODO: This won't work on multiple screens
		guard let screen = NSScreen.main() else { return }

		let position = convert(position, from: nil)
		
		var rect = reticleView.bounds
		rect.origin.x = position.x - rect.width / 2
		rect.origin.y = position.y - rect.height / 2

		reticleView.frame = rect

		let magnification: CGFloat = 10
		let captureSize = CGSize(width: 17, height: 17)

		let image = screen.screenshot(frame: CGRect(x: position.x - (captureSize.width / 2), y: screen.frame.height - position.y - (captureSize.height / 2), width: captureSize.width, height: captureSize.height))!

		let scaled = NSImage(size: CGSize(width: captureSize.width * magnification, height: captureSize.height * magnification))
		scaled.lockFocus()

		NSGraphicsContext.current()?.imageInterpolation = .none
		image.draw(in: CGRect(x: 0, y: 0, width: captureSize.width * magnification, height: captureSize.height * magnification), from: CGRect(origin: .zero, size: captureSize), operation: .sourceOver, fraction: 1)
		scaled.unlockFocus()

		imageView.image = scaled
	}
}


final class EyeDropperWindow: NSWindow {

	private let view = EyeDropperWindowView()

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
	}
}
