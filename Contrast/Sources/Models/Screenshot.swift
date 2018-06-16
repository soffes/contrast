import AppKit

struct Screenshot {
	var image: NSImage
	var color: NSColor

	init?(originalImage: NSImage, scaledImage: NSImage) {
		guard let data = originalImage.tiffRepresentation,
			let rasterized = NSBitmapImageRep(data: data),
			let color = rasterized.colorAt(x: rasterized.pixelsWide / 2, y: rasterized.pixelsHigh / 2)?
                .usingColorSpace(.genericRGB)
		else { return nil }

		self.image = scaledImage
		self.color = color
	}
}
