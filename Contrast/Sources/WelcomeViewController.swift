//
//  WelcomeViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 7/14/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class WelcomeViewController: NSViewController {
	override func loadView() {
		view = NSView()
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.wantsLayer = true
		view.layer?.backgroundColor = NSColor.white.cgColor

		let orange = NSView(frame: CGRect(x: -290, y: -30, width: 254, height: 240))
		orange.wantsLayer = true
		orange.layer?.backgroundColor = NSColor(displayP3Red: 1, green: 167 / 255, blue: 0, alpha: 1).cgColor
		orange.rotate(byDegrees: -315)
		view.addSubview(orange)

		let blue = NSView(frame: CGRect(x: 279, y: -130, width: 230, height: 230))
		blue.wantsLayer = true
		blue.layer?.backgroundColor = NSColor(displayP3Red: 0, green: 188 / 255, blue: 1, alpha: 1).cgColor
		blue.layer?.cornerRadius = blue.frame.height / 2
		view.addSubview(blue)

		let pink = NSView(frame: CGRect(x: 310, y: 260, width: 96, height: 90))
		pink.wantsLayer = true
		pink.layer?.backgroundColor = NSColor(displayP3Red: 1, green: 0, blue: 210 / 255, alpha: 1).cgColor
		pink.rotate(byDegrees: -315)
		view.addSubview(pink)

		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: 440),
			view.heightAnchor.constraint(equalToConstant: 280)
		])
	}
}
