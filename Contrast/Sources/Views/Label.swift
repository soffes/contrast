//
//  Label.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

private final class LabelCell: NSTextFieldCell {

	// MARK: - Properties

	var contentInsets = NSEdgeInsetsZero {
		didSet {
			controlView?.needsLayout = true
		}
	}


	// MARK: - NSCell

	override func drawingRect(forBounds theRect: NSRect) -> NSRect {
		var rect = super.drawingRect(forBounds: theRect)
		rect.origin.x += contentInsets.left
		rect.origin.y += contentInsets.top
		rect.size.width -= contentInsets.right
		rect.size.height -= contentInsets.bottom
		return rect
	}

	override func drawInterior(withFrame cellFrame: NSRect, in controlView: NSView) {
		super.drawInterior(withFrame: drawingRect(forBounds: cellFrame), in: controlView)
	}
}


final class Label: NSTextField {

	// MARK: - Properties

	var contentInsets: EdgeInsets {
		set {
			labelCell?.contentInsets = newValue
		}

		get {
			return labelCell?.contentInsets ?? NSEdgeInsetsZero
		}
	}

	private var labelCell: LabelCell? {
		return cell as? LabelCell
	}

	var theme: Theme = .`default` {
		didSet {
			set(text: stringValue, foregroundColor: theme.foregroundColor, backgroundColor: theme.backgroundColor)
		}
	}


	// MARK: - Initializers

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		isEditable = false
		drawsBackground = true
		backgroundColor = .clear
		usesSingleLineMode = true
		lineBreakMode = .byTruncatingTail
		isBezeled = false

		guard let cell = labelCell else { return }

		cell.isScrollable = false
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: NSSize {
		var size = super.intrinsicContentSize
		size.width += contentInsets.left + contentInsets.right
		size.height += contentInsets.top + contentInsets.bottom
		return size
	}


	// MARK: - NSControl

	override class func cellClass() -> AnyClass? {
		return LabelCell.self
	}


	// MARK: - Setting Text

	func set(text: String, foregroundColor: NSColor? = nil, backgroundColor: NSColor? = nil) {
		let paragraph = NSMutableParagraphStyle()
		paragraph.alignment = alignment

		attributedStringValue = NSAttributedString(string: text, attributes: [
			NSForegroundColorAttributeName: foregroundColor ?? theme.foregroundColor,
			NSBackgroundColorAttributeName: backgroundColor ?? theme.backgroundColor,
			NSFontAttributeName: font ?? NSFont.systemFont(ofSize: NSFont.systemFontSize()),
			NSParagraphStyleAttributeName: paragraph
		])
	}
}
