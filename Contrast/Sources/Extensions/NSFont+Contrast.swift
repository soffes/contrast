import AppKit

extension NSFont {
	static func contrastMonoSpace(ofSize size: CGFloat = 13) -> NSFont {
		NSFont(name: "Native-Regular", size: size)!
	}
}
