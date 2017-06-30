//
//  Label.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class LabelCell: NSTextFieldCell {
	// MARK: - Properties

	var contentInsets = NSEdgeInsetsZero {
		didSet {
			controlView?.needsLayout = true
		}
	}


	// MARK: - NSCell

	override
	func drawingRect(forBounds theRect: NSRect) -> NSRect {
		var rect = super.drawingRect(forBounds: theRect)
		rect.origin.x += contentInsets.left
		rect.origin.y += contentInsets.top
		rect.size.width -= contentInsets.right
		rect.size.height -= contentInsets.bottom
		return rect
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


	// MARK: - Initializers

	override init(frame frameRect: NSRect) {
		super.init(frame: frameRect)

		guard let cell = labelCell else { return }

		cell.isEditable = false
		cell.drawsBackground = false
		cell.usesSingleLineMode = true
		cell.lineBreakMode = .byTruncatingTail
		cell.isScrollable = false
		cell.isEnabled = false
		cell.isBezeled = false
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
}
