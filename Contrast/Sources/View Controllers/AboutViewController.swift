//
//  AboutViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 8/1/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

class AboutViewController: NSViewController {

	// MARK: - Properties

	@IBOutlet var versionLabel: NSTextField!


	// MARK: - NSViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		if let info = Bundle.main.infoDictionary, let shortVersion = info["CFBundleShortVersionString"] as? String, let version = info["CFBundleVersion"] as? String {
			versionLabel.stringValue = "Version \(shortVersion) (\(version))"
		} else {
			versionLabel.stringValue = ""
		}
	}
}
