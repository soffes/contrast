//
//  ViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

	@IBOutlet var colorWell1: NSColorWell!
	@IBOutlet var colorWell2: NSColorWell!
	@IBOutlet var scoreLabel: NSTextField!

	override func viewDidLoad() {
		super.viewDidLoad()
		colorWellDidChange(self)
	}

	@IBAction func colorWellDidChange(_ sender: Any?) {
		scoreLabel.textColor = colorWell1.color
		MenuBarController.shared?.backgroundColor = colorWell2.color

		calculateContrastRatio()
	}

	private func calculateContrastRatio() {
		let contrastRatio = NSColor.constrastRatio(colorWell1.color, colorWell2.color)
		scoreLabel.stringValue = Score(contrastRatio: contrastRatio).description
	}
}
