import AppKit

struct Screenshot {
	var image: NSImage
	var color: NSColor

	init?(originalImage: CGImage, scaledImage: NSImage) {
		guard let color = originalImage.nsColor(atX: originalImage.width / 2, y: originalImage.height / 2) else {
			return nil
		}

		self.color = color
		self.image = scaledImage
	}
}
