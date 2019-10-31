import AppKit

struct Screenshot {

	// MARK: - Properties

	/// Scaled image used for preview in loupe
	var image: NSImage

	/// Color for the screenshot
	///
	/// - note: This resamples every time this is called so it can dynamically change when the color profile changes.
	var color: NSColor {
		let colorSpace = Preferences.shared.colorProfile.colorSpace
		let x = originalImage.width / 2
		let y = originalImage.height / 2

		guard let color = originalImage.nsColor(atX: x, y: y, colorSpace: colorSpace) else {
			assertionFailure("Failed to sample color.")
			return .white
		}

		return color
	}

	/// Original unscaled image used for color sampling
	private let originalImage: CGImage

	// MARK: - Initializers

	init?(originalImage: CGImage, scaledImage: NSImage) {
		self.originalImage = originalImage
		self.image = scaledImage
	}
}
