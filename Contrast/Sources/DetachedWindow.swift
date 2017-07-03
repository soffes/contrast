//
//  DetachedWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 7/2/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class DetachedWindowView: NSView {
	let closeButton: CloseButton = {
		let view = CloseButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.keyEquivalent = "w"
		view.keyEquivalentModifierMask = .command
		view.alphaValue = 0
		return view
	}()

	private var trackingArea: NSTrackingArea? {
		willSet {
			trackingArea.flatMap(removeTrackingArea)
		}

		didSet {
			trackingArea.flatMap(addTrackingArea)
		}
	}

	override func mouseEntered(with event: NSEvent) {
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.2
			closeButton.animator().alphaValue = 1
		}, completionHandler: nil)
	}

	override func mouseExited(with event: NSEvent) {
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.2
			closeButton.animator().alphaValue = 0
		}, completionHandler: nil)
	}

	override func updateTrackingAreas() {
		trackingArea = NSTrackingArea(rect: bounds, options: [.mouseEnteredAndExited, .activeAlways], owner: self, userInfo: nil)
		super.updateTrackingAreas()
	}

	func addCloseButton() {
		closeButton.removeFromSuperview()
		addSubview(closeButton)

		NSLayoutConstraint.activate([
			closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
			closeButton.topAnchor.constraint(equalTo: topAnchor)
		])
	}
}


/// Used when popover is detacted
final class DetachedWindow: NSWindow {

	// MARK: - Properties

	private let customContentView = DetachedWindowView()

	// MARK: - Initializers

	convenience init(contentViewController: NSViewController) {
		let view = contentViewController.view
		self.init(contentRect: view.bounds, styleMask: [], backing: .retained, defer: false)

		guard let contentView = contentView else { return }

		view.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(view)

		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			view.topAnchor.constraint(equalTo: contentView.topAnchor),
			view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])

		customContentView.addCloseButton()
	}

	override init(contentRect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, defer: Bool) {
		let style: NSWindowStyleMask = [.titled, .closable, .fullSizeContentView]
		
		super.init(contentRect: contentRect, styleMask: style, backing: backing, defer: `defer`)

		contentView = customContentView

		customContentView.closeButton.target = self
		customContentView.closeButton.action = #selector(close)

		isMovableByWindowBackground = true
		titlebarAppearsTransparent = true
		titleVisibility = .hidden
		standardWindowButton(.closeButton)?.isHidden = true
		standardWindowButton(.miniaturizeButton)?.isHidden = true
		standardWindowButton(.zoomButton)?.isHidden = true
		level = Int(CGWindowLevelForKey(.mainMenuWindow))
	}
}
