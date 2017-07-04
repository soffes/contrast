//
//  CloseButton.swift
//  Contrast
//
//  Created by Sam Soffes on 7/2/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

fileprivate extension Theme {
	var closeButtonFill: NSColor {
		return NSColor(white: isDark ? 1 : 0, alpha: 0.3)
	}

	func closeButtonImageColor(isHighlighted: Bool) -> NSColor {
		return NSColor(white: 0, alpha: isHighlighted ? 0.8 : 0.5)
	}
}


private final class CloseButtonCell: NSButtonCell {

	var theme: Theme = .default

	let buttonRect = CGRect(x: 8, y: 5, width: 12, height: 12)

	override func drawBezel(withFrame frame: NSRect, in controlView: NSView) {
		theme.closeButtonFill.setFill()
		NSBezierPath(ovalIn: buttonRect).fill()

		// Custom focus ring
		if showsFirstResponder {
			theme.focusRingColor.setStroke()

			let path = NSBezierPath(ovalIn: buttonRect.insetBy(dx: -2, dy: -2))
			path.lineWidth = 4
			path.stroke()
		}
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {}

	override func highlight(_ flag: Bool, withFrame cellFrame: NSRect, in controlView: NSView) {
		super.highlight(flag, withFrame: cellFrame, in: controlView)

		(controlView as? NSButton)?.isHighlighted = flag
	}
}

final class CloseButton: NSButton {

	// MARK: - Properties

	var theme: Theme = .default {
		didSet {
			buttonCell?.theme = theme
			updateImage()
			setNeedsDisplay()
		}
	}

	let imageView: NSImageView = {
		let view = NSImageView()
		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.clear.cgColor
		return view
	}()


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		title = ""
		focusRingType = .none

		imageView.frame = buttonCell!.buttonRect
		addSubview(imageView)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		return CGSize(width: 26, height: 20)
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return CloseButtonCell.self
	}


	// MARK: - NSButton

	override var isHighlighted: Bool {
		didSet {
			updateImage()
		}
	}


	// MARK: - Private

	private var buttonCell: CloseButtonCell? {
		return cell as? CloseButtonCell
	}

	private func updateImage() {
		let imageColor = theme.closeButtonImageColor(isHighlighted: isHighlighted)
		imageView.image = #imageLiteral(resourceName: "Close").tinting(with: imageColor)
	}
}
