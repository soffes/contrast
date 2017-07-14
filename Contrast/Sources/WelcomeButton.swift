//
//  WelcomeButton.swift
//  Contrast
//
//  Created by Sam Soffes on 7/14/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class WelcomeButtonCell: NSButtonCell {

	private let darkColor = NSColor(red: 17 / 255, green: 17 / 255, blue: 18 / 255, alpha: 1)
	private let lightColor = NSColor(red: 226 / 255, green: 231 / 255, blue: 232 / 255, alpha: 1)

	override func drawBezel(withFrame frame: NSRect, in view: NSView) {
		let backgroundColor = showsFirstResponder ? darkColor : lightColor
		backgroundColor.setFill()
		NSBezierPath(roundedRect: view.bounds, xRadius: 4, yRadius: 4).fill()
	}

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		let foregroundColor = showsFirstResponder ? lightColor : darkColor

		let title = NSAttributedString(string: self.title, attributes: [
			NSForegroundColorAttributeName: foregroundColor,
			NSFontAttributeName: NSFont.systemFont(ofSize: 14, weight: NSFontWeightMedium)
		])

		let size = title.size()
		title.draw(at: CGPoint(x: round((view.bounds.width - size.width) / 2), y: round((view.bounds.height - size.height) / 2) - 2))
	}
}

final class WelcomeButton: NSButton {

	// MARK: - Properties

	private let cursor = NSCursor.pointingHand()


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		focusRingType = .none
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSResponder

	override func performKeyEquivalent(with event: NSEvent) -> Bool {
		// Return
		if event.keyCode == 36 {
			sendAction(action, to: target)
			return true
		}

		return super.performKeyEquivalent(with: event)
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 130, height: 48)
	}

	override func resetCursorRects() {
		super.resetCursorRects()
		addCursorRect(bounds, cursor: cursor)
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return WelcomeButtonCell.self
	}
}
