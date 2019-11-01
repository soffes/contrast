import AppKit

struct Screenshot {

	// MARK: - Properties

	/// Scaled image used for preview in loupe
	let image: NSImage

	/// Color of the selected pixel in the screenshot
	let color: NSColor

	// MARK: - Initializers

	init?(originalImage: CGImage, scaledImage: NSImage) {
		self.image = scaledImage

		let colorSpace = Preferences.shared.colorProfile.colorSpace
		let x = originalImage.width / 2
		let y = originalImage.height / 2

		if let color = originalImage.nsColor(atX: x, y: y, colorSpace: colorSpace) {
			self.color = color
		} else {
			assertionFailure("Failed to sample color.")
			self.color = .white
		}
	}
}
