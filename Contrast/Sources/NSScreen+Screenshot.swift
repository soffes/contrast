//
//  NSScreen+Screenshot.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

extension NSScreen {
	func screenshot(frame: CGRect? = nil) -> NSImage? {
		let frame = frame ?? self.frame
		guard let cgImage = CGWindowListCreateImage(frame, .optionOnScreenOnly, kCGNullWindowID, [.nominalResolution, .shouldBeOpaque]) else { return nil }

		let rep = NSBitmapImageRep(cgImage: cgImage)
		let image = NSImage()
		image.addRepresentation(rep)
		return image
	}
}
