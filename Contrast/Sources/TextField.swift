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

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		let bounds = controlView.bounds

		let border = NSBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 4, yRadius: 4)
		NSColor(white: 0, alpha: 0.2).setStroke()
		border.stroke()

		let fill = NSBezierPath(roundedRect: bounds.insetBy(dx: 1, dy: 1), xRadius: 4, yRadius: 4)
		NSColor(white: 1, alpha: 0.05).setFill()
		fill.fill()
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
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 63, height: 22)
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
