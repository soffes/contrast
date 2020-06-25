import AppKit

extension NSFont {
	static func contrastMonoSpace(ofSize size: CGFloat = 13) -> NSFont {
		.monospacedSystemFont(ofSize: size, weight: .regular)
	}
}
