import AppKit

private final class CustomWindowView: NSView {
	let closeButton: CloseButton = {
		let view = CloseButton()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.keyEquivalent = "w"
		view.keyEquivalentModifierMask = NSEvent.ModifierFlags.command
		view.imageView.alphaValue = 0
		return view
	}()

	private var trackingArea: NSTrackingArea? {
		willSet {
			trackingArea.flatMap(removeTrackingArea)
		}

		didSet {
			trackingArea.flatMap(addTrackingArea)
		}
	}

	override func mouseEntered(with event: NSEvent) {
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.2
			closeButton.imageView.animator().alphaValue = 1
		}, completionHandler: nil)
	}

	override func mouseExited(with event: NSEvent) {
		NSAnimationContext.runAnimationGroup({ context in
			context.duration = 0.2
			closeButton.imageView.animator().alphaValue = 0
		}, completionHandler: nil)
	}

	override func updateTrackingAreas() {
		let options: NSTrackingArea.Options = [.mouseEnteredAndExited, .activeAlways]
		trackingArea = NSTrackingArea(rect: closeButton.frame, options: options, owner: self, userInfo: nil)
		super.updateTrackingAreas()
	}

	func addCloseButton() {
		closeButton.removeFromSuperview()
		addSubview(closeButton)

		NSLayoutConstraint.activate([
			closeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 1),
			closeButton.topAnchor.constraint(equalTo: topAnchor)
		])
	}
}

extension CustomWindowView: ColorsViewControllerDelegate {
	func colorsViewController(_ viewController: ColorsViewController, didChangeTheme theme: Theme) {
		closeButton.theme = theme
	}
}

final class CustomWindow: NSWindow {

	// MARK: - Properties

	var customCloseButton = false {
		didSet {
			standardWindowButton(.closeButton)?.isHidden = customCloseButton

			if customCloseButton {
				customContentView.addCloseButton()
			}
		}
	}

	private let customContentView = CustomWindowView()
	private var customContentViewController: NSViewController?

	// MARK: - Initializers

	convenience init(contentViewController: NSViewController) {
		let view = contentViewController.view
		self.init(contentRect: view.bounds, styleMask: [], backing: .buffered, defer: false)
		isReleasedWhenClosed = false

		guard let contentView = contentView else {
			return
		}

		view.translatesAutoresizingMaskIntoConstraints = false
		contentView.addSubview(view)

		NSLayoutConstraint.activate([
			view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
			view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
			view.topAnchor.constraint(equalTo: contentView.topAnchor),
			view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		])

		contentViewController.viewDidAppear()
		customContentViewController = contentViewController

		if let viewController = contentViewController as? ColorsViewController {
			viewController.delegate = customContentView
			customContentView.closeButton.theme = viewController.theme
		}
	}

	override init(contentRect: NSRect, styleMask: NSWindow.StyleMask, backing: NSWindow.BackingStoreType, defer: Bool) {
		let style: NSWindow.StyleMask = [.titled, .closable, .fullSizeContentView]

		super.init(contentRect: contentRect, styleMask: style, backing: backing, defer: `defer`)

		contentView = customContentView

		customContentView.closeButton.target = self
		customContentView.closeButton.action = #selector(close)

		isMovableByWindowBackground = true
		titlebarAppearsTransparent = true
		titleVisibility = .hidden
		standardWindowButton(.miniaturizeButton)?.isHidden = true
		standardWindowButton(.zoomButton)?.isHidden = true
		level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.mainMenuWindow)))
	}
}
