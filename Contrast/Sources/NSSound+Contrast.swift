//
//  NSSound+Contrast.swift
//  Contrast
//
//  Created by Sam Soffes on 7/5/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSSound {
	static var contrastSwap: NSSound {
		return NSSound(named: "slide_left")!
	}

	static var contrastPickColor: NSSound {
		return NSSound(named: "click_tiny")!
	}

	static var contrastCopyColor: NSSound {
		return NSSound(named: "click_snap")!
	}
}
