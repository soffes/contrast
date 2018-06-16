import AppKit

class AboutViewController: NSViewController {

	// MARK: - Properties

	@IBOutlet var versionLabel: NSTextField!


	// MARK: - NSViewController

	override func viewDidLoad() {
		super.viewDidLoad()

		if let info = Bundle.main.infoDictionary, let shortVersion = info["CFBundleShortVersionString"] as? String,
            let version = info["CFBundleVersion"] as? String
        {
			versionLabel.stringValue = "Version \(shortVersion) (\(version))"
		} else {
			versionLabel.stringValue = ""
		}
	}
}
