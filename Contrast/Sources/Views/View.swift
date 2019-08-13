import AppKit

class View: NSView {

	// MARK: - Properties

	var backgroundColor: NSColor? {
		didSet {
			updateLayer()
		}
	}

	// MARK: - Initializers

	override init(frame: CGRect) {
		super.init(frame: frame)
		initialize()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		initialize()
	}

	// MARK: - NSView

	override func updateLayer() {
		layer?.backgroundColor = backgroundColor?.cgColor
	}

	// MARK: - Private

	private func initialize() {
		wantsLayer = true
	}
}

