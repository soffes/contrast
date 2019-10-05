import AppKit

extension Notification.Name {
	static let themeDidChange = Notification.Name(rawValue: "ColorsController.themeDidChange")
}

final class ColorsController {

	// MARK: - Properties

	var theme: Theme {
		didSet {
			NotificationCenter.default.post(name: .themeDidChange, object: theme)

			Preferences.shared.themeData = try? JSONSerialization.data(withJSONObject: theme.dictionaryRepresentation,
																	   options: [])
		}
	}

	static let shared = ColorsController()

	// MARK: - Initializers

	private init() {
		if let data = Preferences.shared.themeData,
			let raw = try? JSONSerialization.jsonObject(with: data, options: []), let json = raw as? [String: Any],
			let theme = Theme(dictionaryRepresentation: json)
		{
			self.theme = theme
		} else {
			theme = .default
		}
	}

	// MARK: - Actions

	@objc func copyURL(_ sender: Any?) {
		let url = "https://usecontra.st/\(theme.foregroundHex)/\(theme.backgroundHex)"

		let pasteboard = NSPasteboard.general
		pasteboard.declareTypes([.URL], owner: nil)
		pasteboard.setString(url, forType: .URL)
	}
}
