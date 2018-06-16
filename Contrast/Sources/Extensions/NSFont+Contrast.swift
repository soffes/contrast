//
//  NSFont.swift
//  Contrast
//
//  Created by Sam Soffes on 7/5/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSFont {
	static func contrastMonoSpace(ofSize size: CGFloat = 13) -> NSFont {
		return NSFont(name: "Native-Regular", size: size)!
	}
}
