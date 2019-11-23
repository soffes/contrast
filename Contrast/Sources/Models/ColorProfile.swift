import QuartzCore

private let sRGBColorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
private let displayP3ColorSpace = CGColorSpace(name: CGColorSpace.displayP3)!

enum ColorProfile: String {
	case unmanaged = "Unmanaged"
	case sRGB = "sRGB"
	case displayP3 = "Display P3"

	var colorSpace: CGColorSpace? {
		switch self {
		case .unmanaged: return nil
		case .sRGB: return sRGBColorSpace
		case .displayP3: return displayP3ColorSpace
		}
	}
}

extension ColorProfile: CustomStringConvertible {
	var description: String {
		rawValue
	}
}
