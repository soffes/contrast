//
//  PlainButton.swift
//  Contrast
//
//  Created by Sam Soffes on 7/2/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class PlainButtonCell: NSButtonCell {

	var theme: Theme = .default
	var isActive = false

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {}

	override func drawInterior(withFrame frame: NSRect, in view: NSView) {
		guard let image = image else { return }

		let bounds = view.bounds

		var rect = CGRect(origin: .zero, size: image.size)
		rect.origin.x += (bounds.width - rect.width) / 2
		rect.origin.y += (bounds.height - rect.height) / 2

		let imageColor = theme.buttonImageColor(isActive: isActive, isHighlighted: isHighlighted)
		image.tinting(with: imageColor).draw(in: rect)

		// Custom focus ring
		if showsFirstResponder {
			theme.focusRingColor.setStroke()

			let path = NSBezierPath(roundedRect: view.bounds.insetBy(dx: 2, dy: 7), xRadius: 7, yRadius: 7)
			path.lineWidth = 4
			path.stroke()
		}
	}
}

final class PlainButton: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			buttonCell?.theme = theme
			setNeedsDisplay()

		}
	}


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		image = #imageLiteral(resourceName: "Swap")
		focusRingType = .none
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 12 + 8, height: 22 + 8)
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return PlainButtonCell.self
	}


	// MARK: - Private

	private var buttonCell: PlainButtonCell? {
		return cell as? PlainButtonCell
	}
}
