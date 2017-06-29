//
//  TextField.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class TextFieldCell: NSTextFieldCell {
	var theme: Theme = .default

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		let bounds = view.bounds.insetBy(dx: 4, dy: 4)

		NSColor(white: 0, alpha: showsFirstResponder ? 0.4 : 0.2).setStroke()
		NSBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 4, yRadius: 4).stroke()

		(showsFirstResponder ? NSColor.white : NSColor(white: 0, alpha: 0.05)).setFill()
		NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 4, yRadius: 4).fill()

		// Custom focus ring
		if showsFirstResponder {
			NSColor(white: 0, alpha: 0.2).setStroke()

			let path = NSBezierPath(roundedRect: view.bounds.insetBy(dx: 2, dy: 2), xRadius: 7, yRadius: 7)
			path.lineWidth = 4
			path.stroke()
		}

		super.drawInterior(withFrame: adjust(frame), in: view)
	}

	override func edit(withFrame rect: NSRect, in controlView: NSView, editor: NSText, delegate: Any?, event: NSEvent?) {
		super.edit(withFrame: adjust(rect), in: controlView, editor: editor, delegate: delegate, event: event)
	}

	override func select(withFrame rect: NSRect, in controlView: NSView, editor: NSText, delegate: Any?, start: Int, length: Int) {
		super.select(withFrame: adjust(rect), in: controlView, editor: editor, delegate: delegate, start: start, length: length)
	}

	private func adjust(_ frame: CGRect) -> CGRect {
		return frame.insetBy(dx: 11, dy: 5)
	}
}

final class TextField: NSTextField {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			themeDidChange()
		}
	}


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		isBordered = false
		isBezeled = false
		backgroundColor = .clear
		focusRingType = .none
		font = NSFont(name: "Menlo", size: 12)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 63 + 8, height: 22 + 8)
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return TextFieldCell.self
	}


	// MARK: - Private

	private var textFieldCell: TextFieldCell? {
		return cell as? TextFieldCell
	}


	// MARK: - Private

	private func themeDidChange() {
		textFieldCell?.theme = theme
		setNeedsDisplay()
	}
}
