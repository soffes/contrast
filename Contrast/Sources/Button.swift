//
//  Button.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension Theme {
	func buttonFillColor(isActive: Bool) -> NSColor {
		if isActive {
			return NSColor(white: 0, alpha: 0.7)
		}

		if isDark {
			return NSColor(white: 0, alpha: 0.1)
		}

		return NSColor(white: 1, alpha: 0.05)
	}

	func buttonBorderColor(isActive: Bool) -> NSColor {
		if isActive {
			return NSColor(white: 0, alpha: 0.5)
		}

		if isDark {
			return NSColor(white: 0, alpha: 0.3)
		}

		return NSColor(white: 0, alpha: 0.2)
	}

	func buttonImageColor(isActive: Bool, isHighlighted: Bool) -> NSColor {
		if isActive {
			return .white
		}

		return NSColor(white: isDark ? 1 : 0, alpha: isHighlighted ? 1 : 0.7)
	}
}


private final class ButtonCell: NSButtonCell {

	var theme: Theme = .default
	var isActive = false

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
		let bounds = controlView.bounds

		theme.buttonFillColor(isActive: isActive).setFill()
		NSBezierPath(roundedRect: bounds, xRadius: 4, yRadius: 4).fill()

		theme.buttonBorderColor(isActive: isActive).setStroke()
		NSBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), xRadius: 4, yRadius: 4).stroke()
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		guard let image = image else { return }

		let bounds = controlView.bounds

		// Glow
		if isActive {
			let center = CGPoint(x: bounds.midX, y: bounds.midY)
			let gradient = NSGradient(colors: [NSColor(white: 1, alpha: 0), NSColor(white: 1, alpha: 0.2)])
			gradient?.draw(fromCenter: center, radius: 16, toCenter: center, radius: 0, options: [])
		}

		var rect = CGRect(origin: .zero, size: image.size)
		rect.origin.x += (bounds.width - rect.width) / 2
		rect.origin.y += (bounds.height - rect.height) / 2

		let imageColor = theme.buttonImageColor(isActive: isActive, isHighlighted: isHighlighted)
		image.tinting(with: imageColor).draw(in: rect)
	}
}

final class Button: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			buttonCell?.theme = theme
			setNeedsDisplay()

		}
	}

	var isActive = false {
		didSet {
			buttonCell?.isActive = isActive
			setNeedsDisplay()
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
}