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
		let view = NSView(frame: CGRect(x: 0, y: 0, width: 128, height: 128))
		view.isHidden = true

		let layer = CAShapeLayer()
		layer.lineWidth = 4
		layer.path = CGPath(ellipseIn: view.bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2), transform: nil)
		layer.strokeColor = NSColor.black.cgColor
		layer.fillColor = nil

		view.wantsLayer = true
		view.layer = layer

		return view
	}()

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
	}

	override func updateTrackingAreas() {
		let trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
	}

	override func mouseMoved(with event: NSEvent) {
		let position = event.locationInWindow

		var rect = reticleView.bounds
		rect.origin.x = position.x - rect.width / 2
		rect.origin.y = position.y - rect.height / 2

		reticleView.frame = rect
	}
}


final class EyeDropperWindow: NSWindow {

	private let view = EyeDropperWindowView()

	init() {
		super.init(contentRect: NSScreen.main()?.frame ?? .zero, styleMask: .borderless, backing: .buffered, defer: false)

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
