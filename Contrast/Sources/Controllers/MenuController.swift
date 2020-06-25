import AppKit

final class MenuController: NSObject {

	// MARK: - Properties

	static let shared = MenuController()

	private var aboutWindowController: NSWindowController?

	// MARK: - Initializers

	private override init() {
		super.init()
	}

	// MARK: - Creating Menus

	func createMenu(isInPopover: Bool) -> NSMenu {
		let menu = NSMenu()

		if Preferences.shared.isTutorialCompleted {
			menu.addItem(NSMenuItem(title: "About Contrast", target: self, action: #selector(showAbout)))

			menu.addItem(.separator())

			menu.addItem(NSMenuItem(title: "Preferences…", action: #selector(AppDelegate.showPreferences),
									keyEquivalent: ","))

			menu.addItem(.separator())

			menu.addItem(NSMenuItem(title: "Copy URL", target: ColorsController.shared,
									action: #selector(ColorsController.copyURL), keyEquivalent: "C"))

			menu.addItem(.separator())

			menu.addItem(NSMenuItem(title: "Accessibility Guide", target: self, action: #selector(showGuide)))
			menu.addItem(NSMenuItem(title: "Contrast Help", target: self, action: #selector(showHelp)))

			menu.addItem(.separator())
		}

		menu.addItem(withTitle: "Quit Contrast", action: #selector(NSApplication.terminate), keyEquivalent: "q")

		return menu
	}

	// MARK: - Actions

	@objc private func showGuide(_ sender: Any?) {
		NSWorkspace.shared.open(URL(string: "https://usecontrast.com/guide")!)
	}

	@objc private func showHelp(_ sender: Any?) {
		NSWorkspace.shared.open(URL(string: "https://usecontrast.com/support")!)
	}

	@objc private func showAbout(_ sender: Any?) {
		let windowController: NSWindowController

		if let controller = aboutWindowController {
			windowController = controller
		} else {
			let object = NSStoryboard(name: "About", bundle: nil)
				.instantiateInitialController()

			guard let controller = object as? NSWindowController else {
				return
			}

			windowController = controller
			aboutWindowController = windowController
		}

		windowController.showWindow(self)
		windowController.window?.center()
	}
}
