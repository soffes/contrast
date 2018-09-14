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
			if !isInPopover {
				let attach = NSMenuItem(title: "Attach to Menu Bar", action: #selector(PopoverController.showPopover),
                                        keyEquivalent: "")
				attach.target = (NSApp.delegate as? AppDelegate)?.menuBarController.popoverController
				menu.addItem(attach)
				menu.addItem(.separator())
			}

			let about = NSMenuItem(title: "About Contrast", action: #selector(showAbout), keyEquivalent: "")
			about.target = self
			menu.addItem(about)

			menu.addItem(.separator())

			let preferences = NSMenuItem(title: "Preferences…", action: #selector(AppDelegate.showPreferences),
                                         keyEquivalent: ",")
			preferences.target = NSApp.delegate
			menu.addItem(preferences)

			menu.addItem(.separator())

			let guide = NSMenuItem(title: "Accessibility Guide", action: #selector(showGuide), keyEquivalent: "")
			guide.target = self
			menu.addItem(guide)

			let help = NSMenuItem(title: "Contrast Help", action: #selector(showHelp), keyEquivalent: "")
			help.target = self
			menu.addItem(help)

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

	@objc func showAbout(_ sender: Any?) {
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
