//
//  SpaceView.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

/// Space view intented to be used with auto layout.
/// Similar to UIStackView, setting a background color is not supported.
final class SpaceView: NSView {

	// MARK: - Properties

	private let contentSize: CGSize


	// MARK: - Initializers

	init(size: CGSize) {
		contentSize = size
		super.init(frame: .zero)
	}

	convenience init(height: CGFloat) {
		self.init(size: CGSize(width: NSViewNoIntrinsicMetric, height: height))
	}

	convenience init(width: CGFloat) {
		self.init(size: CGSize(width: width, height: NSViewNoIntrinsicMetric))
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSView

	override var intrinsicContentSize: CGSize {
		return contentSize
	}
}


extension NSStackView {
	func addSpace(_ length: CGFloat = 0) {
		switch orientation {
		case .horizontal: addArrangedSubview(SpaceView(width: length))
		case .vertical: addArrangedSubview(SpaceView(height: length))
		}
	}
}
