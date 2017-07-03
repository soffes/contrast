//
//  DetachedWindow.swift
//  Contrast
//
//  Created by Sam Soffes on 7/2/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

/// Used when popover is detacted
final class DetachedWindow: NSWindow {

	// MARK: - Properties

	private let closeButton: CloseButton = {
		let view = CloseButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	override var contentViewController: NSViewController? {
		didSet {
			guard let view = contentView else { return }

			closeButton.target = self
			closeButton.action = #selector(close)
			view.addSubview(closeButton)

			NSLayoutConstraint.activate([
				closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 1),
				closeButton.topAnchor.constraint(equalTo: view.topAnchor)
			])
		}
	}


	// MARK: - Initializers

	override init(contentRect: NSRect, styleMask: NSWindowStyleMask, backing: NSBackingStoreType, defer: Bool) {
		let style: NSWindowStyleMask = [.titled, .closable, .fullSizeContentView]
		
		super.init(contentRect: contentRect, styleMask: style, backing: backing, defer: `defer`)

		isMovableByWindowBackground = true
		titlebarAppearsTransparent = true
		titleVisibility = .hidden
		standardWindowButton(.closeButton)?.isHidden = true
		standardWindowButton(.miniaturizeButton)?.isHidden = true
		standardWindowButton(.zoomButton)?.isHidden = true
	}
}
