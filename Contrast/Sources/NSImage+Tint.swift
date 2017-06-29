//
//  NSImage+Tint.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSImage {
	func tinting(with tintColor: NSColor) -> NSImage {
		guard let cgImage = self.cgImage(forProposedRect: nil, context: nil, hints: nil) else { return self }

		return NSImage(size: size, flipped: false) { bounds in
			guard let context = NSGraphicsContext.current()?.cgContext else { return false }

			tintColor.set()
			context.clip(to: bounds, mask: cgImage)
			context.fill(bounds)

			return true
		}
	}
}
