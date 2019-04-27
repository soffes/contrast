import AppKit

struct Screenshot {
	var image: NSImage
	var color: NSColor

	init?(originalImage: NSImage, scaledImage: NSImage) {
        guard let data = originalImage.tiffRepresentation, let rasterized = NSBitmapImageRep(data: data) else {
            return nil
        }

        let point = CGPoint(x: CGFloat(rasterized.pixelsWide) / 2, y: CGFloat(rasterized.pixelsHigh) / 2)

        // I’m not sure why `- 1` fixes it and it’s only needed for the x-axis
        guard let color = rasterized.colorAt(x: Int(point.x) - 1, y: Int(point.y))?.usingColorSpace(.genericRGB) else {
            return nil
        }

		self.image = scaledImage
		self.color = color
	}
}
