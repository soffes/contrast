//
//  LoupeView.swift
//  Contrast
//
//  Created by Sam Soffes on 7/5/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class LoupeView: NSView {

	// MARK: - Properties

	let gridView: NSView = {
		let size = EyeDropper.captureSize
		let view = GridView(rows: Int(size.height), columns: Int(size.width), dimension: EyeDropper.magnification / 2)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		return view
	}()

	let imageView: NSImageView = {
		let view = NSImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.imageAlignment = .alignCenter
		view.imageScaling = .scaleNone
		view.wantsLayer = true
		return view
	}()


	// MARK: - Initializers

	convenience init() {
		let size = EyeDropper.captureSize
		let magnification = EyeDropper.magnification
		self.init(frame: CGRect(x: 0, y: 0, width: size.width * magnification / 2, height: size.height * magnification / 2))
	}

	override init(frame: NSRect) {
		super.init(frame: frame)

		let layer = CAShapeLayer()
		layer.lineWidth = 4
		layer.path = CGPath(ellipseIn: bounds.insetBy(dx: layer.lineWidth / 2, dy: layer.lineWidth / 2), transform: nil)
		layer.strokeColor = NSColor(white: 0.125, alpha: 1).cgColor
		layer.fillColor = nil

		wantsLayer = true
		self.layer = layer

		imageView.layer?.mask = makeMask()
		addSubview(imageView)

		gridView.layer?.mask = makeMask()
		addSubview(gridView)

		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
			imageView.topAnchor.constraint(equalTo: topAnchor),
			imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

			gridView.leadingAnchor.constraint(equalTo: leadingAnchor),
			gridView.trailingAnchor.constraint(equalTo: trailingAnchor),
			gridView.topAnchor.constraint(equalTo: topAnchor),
			gridView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Private

	private func makeMask() -> CALayer {
		let maskPath = CGPath(ellipseIn: bounds.insetBy(dx: 4, dy: 4), transform: nil)
		let mask = CAShapeLayer()
		mask.path = maskPath
		return mask
	}
}
