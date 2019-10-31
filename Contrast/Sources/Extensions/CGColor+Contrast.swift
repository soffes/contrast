import AppKit

extension CGImage {
	/// Get the color at a given point while optionally converting color spaces.
	///
	/// - parameter x: X coordinate
	/// - parameter y: Y coordinate
	/// - parameter colorSpace: color space to convert to before sampling
	///
	/// - returns: `NSColor` representation of the pixel at the given point
	func nsColor(atX x: Int, y: Int, colorSpace: CGColorSpace? = nil) -> NSColor? {
		var rep = NSBitmapImageRep(cgImage: self)

		if let cgColorSpace = colorSpace {
			if let nsColorSpace = NSColorSpace(cgColorSpace: cgColorSpace),
				let updated = rep.converting(to: nsColorSpace, renderingIntent: .default)
			{
				rep = updated
			} else {
				assertionFailure("Failed to convert to '\(cgColorSpace.name!)'.")
			}
		}

		return rep.colorAt(x: x, y: y)
	}
}
