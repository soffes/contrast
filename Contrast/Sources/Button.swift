//
//  Button.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class ButtonCell: NSButtonCell {
	var theme: Theme = .default

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
		let bounds = controlView.bounds

		let fill = NSBezierPath(roundedRect: bounds, xRadius: 4, yRadius: 4)
		NSColor(white: 1, alpha: 0.05).setFill()
		fill.fill()

		let border = NSBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 4, yRadius: 4)
		NSColor(white: 0, alpha: 0.2).setStroke()
		border.stroke()
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		guard let image = image else { return }

		let bounds = controlView.bounds

		var rect = CGRect(origin: .zero, size: image.size)
		rect.origin.x += (bounds.width - rect.width) / 2
		rect.origin.y += (bounds.height - rect.height) / 2

		image.tinting(with: NSColor(white: 0, alpha: isHighlighted ? 1 : 0.7)).draw(in: rect)
	}
}

final class Button: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			themeDidChange()
		}
	}


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		image = #imageLiteral(resourceName: "EyeDropper")
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 32, height: 22)
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return ButtonCell.self
	}


	// MARK: - Private

	private var buttonCell: ButtonCell? {
		return cell as? ButtonCell
	}


	// MARK: - Private

	private func themeDidChange() {
		buttonCell?.theme = theme
		setNeedsDisplay()
	}
}
