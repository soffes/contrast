import AppKit

private let swap = NSSound(named: "slide_left", volume: 0.4)!
private let pick = NSSound(named: "click_tiny", volume: 0.2)!
private let pickColor = NSSound(named: "click_type", volume: 0.2)!

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

	convenience init?(named name: String, volume: Float) {
		self.init(named: name)
		self.volume = volume
	}

	func forcePlay() {
		guard Preferences.shared.isSoundEnabled else {
			return
		}

		if isPlaying {
			stop()
		}

		play()
	}
}
