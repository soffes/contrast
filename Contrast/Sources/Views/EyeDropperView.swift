import AppKit

final class EyeDropperView: NSView {

	// MARK: - Properties

	let loupeView = LoupeView()

	private var trackingArea: NSTrackingArea?
	private let trackingAreaOptions: NSTrackingArea.Options = [.activeAlways, .mouseMoved, .mouseEnteredAndExited]
	private let cursor = NSCursor(image: NSImage(size: CGSize(width: 1, height: 1)), hotSpot: .zero)

	static let magnification: CGFloat = 20
	static let captureSize = CGSize(width: 17, height: 17)

	// MARK: - Initializers

	init() {
		super.init(frame: .zero)

		loupeView.isHidden = true
		addSubview(loupeView)

		// Setting a background color prevents views under this view from messing the the cursor.
		wantsLayer = true
		layer?.backgroundColor = NSColor(white: 0, alpha: 0.001).cgColor
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - NSResponder

	override func updateTrackingAreas() {
		self.trackingArea.flatMap(removeTrackingArea)

		let trackingArea = NSTrackingArea(rect: bounds, options: trackingAreaOptions, owner: self, userInfo: nil)
		addTrackingArea(trackingArea)
		self.trackingArea = trackingArea
		window?.invalidateCursorRects(for: self)
	}

	override func mouseEntered(with event: NSEvent) {
		loupeView.isHidden = false
		window?.makeKey()
	}

	override func mouseExited(with event: NSEvent) {
		loupeView.isHidden = true
	}

	override func mouseMoved(with event: NSEvent) {
		guard let window = event.window, window == self.window else {
			loupeView.isHidden = true
			return
		}

		loupeView.isHidden = false
		positionLoupe(at: event.locationInWindow)
	}

	// MARK: - NSView

	override func resetCursorRects() {
		super.resetCursorRects()
		addCursorRect(bounds, cursor: cursor)
	}

	override func viewDidMoveToWindow() {
		super.viewDidMoveToWindow()

		if let window = window {
			cursor.push()

			let position = window.mouseLocationOutsideOfEventStream
			if window.frame.contains(position) {
				loupeView.isHidden = false
				positionLoupe(at: position)
			}
		} else {
			cursor.pop()
		}
	}

	// MARK: - Positioning

	func positionLoupe(at position: CGPoint) {
		let scale = window?.screen?.backingScaleFactor ?? 1
		var position = convert(position, from: nil)
		position.x = (position.x * scale).rounded(.awayFromZero) / scale
		position.y = (position.y * scale).rounded(.awayFromZero) / scale

		// Position loupe
		var rect = loupeView.bounds
		rect.origin.x = position.x - rect.width / 2
		rect.origin.y = position.y - rect.height / 2
		loupeView.frame = rect

		// Update image
		loupeView.screenshot = screenshot(at: position).flatMap(Screenshot.init)
	}

	// MARK: - Private

	/// First is the original, second is scaled up
	private func screenshot(at position: CGPoint) -> (CGImage, NSImage)? {
		guard let window = window,
			let screen = window.screen,
			let screenNumber = screen.deviceDescription[NSDeviceDescriptionKey(rawValue: "NSScreenNumber")] as? UInt32
			else
		{
			loupeView.isHidden = true
			return nil
		}

		// Convert the coordinate. I don't fully understand why this works.
		let screenBounds = CGDisplayBounds(screenNumber)
		var position = position
		position.x += screenBounds.origin.x
		position.y = screenBounds.height - (-screenBounds.origin.y + position.y)

		// Take screenshot
		let windowID = UInt32(window.windowNumber)
		let captureSize = type(of: self).captureSize
		let magnification = type(of: self).magnification
		let screenshotFrame = CGRect(x: position.x - (captureSize.width / 2), y: position.y - (captureSize.height / 2),
									 width: captureSize.width, height: captureSize.height)

		guard let cgImage = CGWindowListCreateImage(screenshotFrame, .optionOnScreenBelowWindow, windowID,
													[.shouldBeOpaque, .bestResolution]) else
		{
			return nil
		}

		// Scale screenshot
		// TODO: Maybe instead of `/ 4` it should be `/ 2 / scale`. Need to verify.
		let scaledRect = CGRect(x: magnification / 4, y: magnification / 4,
								width: captureSize.width * magnification, height: captureSize.height * magnification)
		let scaled = NSImage(size: scaledRect.size, flipped: false) { _ in
			guard let gc = NSGraphicsContext.current else {
				return false
			}

			gc.imageInterpolation = .none
			gc.cgContext.draw(cgImage, in: scaledRect)
			return true
		}

		return (cgImage, scaled)
	}
}
