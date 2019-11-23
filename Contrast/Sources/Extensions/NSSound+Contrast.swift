import AppKit

private let volume: Float = 0.2

private let swap = NSSound(named: "slide_left", volume: 0.4)!
private let pick = NSSound(named: "click_tiny", volume: volume)!
private let pickColor = NSSound(named: "click_type", volume: volume)!
private let copyColor = NSSound(named: "click_snap", volume: volume)!

extension NSSound {
	static var contrastSwap: NSSound {
		swap
	}

	static var contrastPick: NSSound {
		pick
	}

	static var contrastPickColor: NSSound {
		pickColor
	}

	static var contrastCopyColor: NSSound {
		copyColor
	}

	convenience init?(named name: String, volume: Float) {
		self.init(named: name)
		self.volume = volume
	}

	func forcePlay() {
		if isPlaying {
			stop()
		}

		if Preferences.shared.isSoundEnabled {
			play()
		}
	}
}
