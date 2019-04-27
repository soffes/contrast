import AppKit

protocol EyeDropperControllerDelegate: class {
	func eyeDropperController(_ controller: EyeDropperController, didSelectColor color: NSColor, continuePicking: Bool)
	func eyeDropperControllerDidCancel(_ controller: EyeDropperController)
}

final class EyeDropperController {

	// MARK: - Properties

	weak var delegate: EyeDropperControllerDelegate?

	private let pasteboard: NSPasteboard = {
		let pasteboard = NSPasteboard.general
		pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
		return pasteboard
	}()

	static let magnification: CGFloat = 20
	static let captureSize = CGSize(width: 17, height: 17)

	private var windows = [EyeDropperWindow]() {
		willSet {
			windows.forEach { window in
				window.customDelegate = nil
				window.orderOut(self)
			}
		}
	}

	private var visible = false


	// MARK: - Initializer

	init(delegate: EyeDropperControllerDelegate) {
		self.delegate = delegate
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - Actions

	@objc func cancel(_ sender: Any?) {
		NotificationCenter.default.removeObserver(self, name: NSApplication.didChangeScreenParametersNotification,
                                                  object: nil)
		visible = false

		windows.removeAll()
		delegate?.eyeDropperControllerDidCancel(self)
	}

	@objc func magnify() {
		NSApp.activate(ignoringOtherApps: true)

		windows = NSScreen.screens.map { screen in
			let window = EyeDropperWindow(frame: screen.frame)
			window.customDelegate = self
			window.makeKey()
			window.orderFrontRegardless()
			return window
		}

		if !visible {
			NotificationCenter.default.addObserver(self, selector: #selector(magnify),
                                                   name: NSApplication.didChangeScreenParametersNotification,
                                                   object: nil)
		}

		visible = true
	}


	// MARK: - Private

	private func pickColor(with event: NSEvent) {
		guard let window = event.window as? EyeDropperWindow,
			let color = window.screenshot?.color
		else { return }

		let shouldContinue = event.modifierFlags.contains(NSEvent.ModifierFlags.shift)

		if event.modifierFlags.contains(NSEvent.ModifierFlags.option) {
			pasteboard.setString(color.hex, forType: NSPasteboard.PasteboardType.string)
			NSSound.contrastCopyColor.forcePlay()
		} else {
			NSSound.contrastPickColor.forcePlay()
		}

		delegate?.eyeDropperController(self, didSelectColor: color, continuePicking: shouldContinue)
	}

	var picking = false
}


extension EyeDropperController: EyeDropperWindowDelegate {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPickColor event: NSEvent) {
		if !picking {
			pickColor(with: event)
		}
		picking = true
	}

	func eyeDropperWindowDidCancel(_ window: EyeDropperWindow) {
		cancel(window)
	}
}
