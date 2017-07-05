//
//  Screenshot.swift
//  Contrast
//
//  Created by Sam Soffes on 7/5/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

struct Screenshot {
	var image: NSImage
	var color: NSColor

	init?(image: NSImage) {
		guard let data = image.tiffRepresentation,
			let rasterized = NSBitmapImageRep(data: data),
			let color = rasterized.colorAt(x: rasterized.pixelsWide / 2, y: rasterized.pixelsHigh / 2)?.convertingToPreferredColorSpace
		else { return nil }

		self.image = image
		self.color = color
	}
}
