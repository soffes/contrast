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

	private var windows = [EyeDropperWindow]() {
		willSet {
			windows.forEach { window in
				window.customDelegate = nil
				window.orderOut(self)
			}
		}
	}

	private var isVisible = false
	private var colorSampler: Any?

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
		isVisible = false

		windows.removeAll()
		delegate?.eyeDropperControllerDidCancel(self)
	}

	@objc func startPicking() {
		NSApp.activate(ignoringOtherApps: true)

		// Fallback if no permission
		if #available(macOS 10.15, *), !canRecordScreen() {
			let sampler = NSColorSampler()
			sampler.show { [weak self] color in
				guard let this = self, let color = color else {
					return
				}

				this.colorSampler = nil
				NSSound.contrastPickColor.forcePlay()
				this.delegate?.eyeDropperController(this, didSelectColor: color, continuePicking: false)
			}
			colorSampler = sampler
			return
 		}

		windows = NSScreen.screens.map { screen in
			let window = EyeDropperWindow(frame: screen.frame)
			window.customDelegate = self
			window.makeKey()
			window.orderFrontRegardless()
			return window
		}

		if !isVisible {
			NotificationCenter.default.addObserver(self, selector: #selector(startPicking),
												   name: NSApplication.didChangeScreenParametersNotification,
												   object: nil)
		}

		isVisible = true
	}

	// MARK: - Private

	private func pickColor(with event: NSEvent) {
		guard let window = event.window as? EyeDropperWindow,
			let color = window.screenshot?.color else
		{
			return
		}

		let shouldContinue = event.modifierFlags.contains(NSEvent.ModifierFlags.shift)

		if event.modifierFlags.contains(NSEvent.ModifierFlags.option) {
			pasteboard.setString(color.hex, forType: NSPasteboard.PasteboardType.string)
			NSSound.contrastCopyColor.forcePlay()
		} else {
			NSSound.contrastPickColor.forcePlay()
		}

		delegate?.eyeDropperController(self, didSelectColor: color, continuePicking: shouldContinue)
	}

	@available(macOS 10.15, *)
	private func canRecordScreen() -> Bool {
		let runningApplication = NSRunningApplication.current
		let processIdentifier = runningApplication.processIdentifier

		guard let windows = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID)
			as? [[String: AnyObject]] else
		{
			assertionFailure("Invalid window info")
			return false
		}

		for window in windows {
			// Get information for each window
			guard let windowProcessIdentifier = (window[String(kCGWindowOwnerPID)] as? Int).flatMap(pid_t.init) else {
				assertionFailure("Invalid window info")
				continue
			}

			// Don't check windows owned by this process
			if windowProcessIdentifier == processIdentifier {
				continue
			}

			// Get process information for each window
			guard let windowRunningApplication = NSRunningApplication(processIdentifier: windowProcessIdentifier) else {
				// Ignore processes we don't have access to, such as WindowServer, which manages the windows named
				// "Menubar" and "Backstop Menubar"
				continue
			}

			if window[String(kCGWindowName)] as? String != nil {
				if windowRunningApplication.executableURL?.lastPathComponent == "Dock" {
					// Ignore the Dock, which provides the desktop picture
					continue
				} else {
					return true
				}
			}
		}

		return false
	}
}

extension EyeDropperController: EyeDropperWindowDelegate {
	func eyeDropperWindow(_ window: EyeDropperWindow, didPickColor event: NSEvent) {
		pickColor(with: event)
	}

	func eyeDropperWindowDidCancel(_ window: EyeDropperWindow) {
		cancel(window)
	}
}
