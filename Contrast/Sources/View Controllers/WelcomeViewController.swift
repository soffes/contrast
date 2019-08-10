import AppKit

final class WelcomeViewController: NSViewController {

	// MARK: - Properties

	private let orangeView: NSView = {
		let view = View(frame: CGRect(x: -210, y: 20, width: 254, height: 240))
        view.backgroundColor = NSColor(named: "Welcome - Orange")
		view.rotate(byDegrees: -315)
		return view
	}()

	private let blueView: NSView = {
		let view = View(frame: CGRect(x: 185, y: -130, width: 230, height: 230))
		view.backgroundColor = NSColor(named: "Welcome - Blue")
		view.layer?.cornerRadius = view.frame.height / 2
		return view
	}()

	private let pinkView: NSView = {
		let view = View(frame: CGRect(x: 260, y: 232, width: 203, height: 191))
        view.backgroundColor = NSColor(named: "Welcome - Pink")
		view.rotate(byDegrees: -315)
		return view
	}()

	private let iconView: NSImageView = {
		let view = NSImageView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.image = #imageLiteral(resourceName: "LargeIcon")
		return view
	}()

	private let contentView: NSStackView = {
		let view = NSStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.orientation = .vertical
		view.alignment = .leading
		view.spacing = 12
		view.alphaValue = 0

		let textColor = NSColor(named: "Welcome - Text")!

		let title = Label()
		title.stringValue = "285,000,000"
		title.textColor = textColor
		title.font = .systemFont(ofSize: 24, weight: .heavy)
		view.addArrangedSubview(title)

		let paragraph = NSMutableParagraphStyle()
		paragraph.lineHeightMultiple = 1.1
		paragraph.paragraphSpacing = 20

		let bodyText = NSMutableAttributedString(string: """
        That’s the estimated number of visually impaired people in the world. 🤓
        This tool will help you design better interfaces for them. 👍
        """, attributes: [
			.foregroundColor: textColor,
			.font: NSFont.systemFont(ofSize: 14),
			.paragraphStyle: paragraph
		])

		let body = Label()
		body.attributedStringValue = bodyText
		body.usesSingleLineMode = false
		body.lineBreakMode = .byWordWrapping
		body.setContentCompressionResistancePriority(NSLayoutConstraint.Priority(rawValue: 250), for: .horizontal)
		view.addArrangedSubview(body)
		view.setCustomSpacing(20, after: body)

		return view
	}()

	private let learnButton: NSButton = {
		let view = WelcomeButton()
		view.title = "Learn More"
		return view
	}()

	private let startButton: NSButton = {
		let view = WelcomeButton()
		view.title = "Get Started"
		view.isPrimary = true
		return view
	}()


	// MARK: - NSResponder

	override func cancelOperation(_ sender: Any?) {
		start()
	}


	// MARK: - NSViewController

	override func loadView() {
		let view = View()
        view.backgroundColor = NSColor(named: "Welcome - Background")
        self.view = view
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(orangeView)
		view.addSubview(blueView)
		view.addSubview(pinkView)
		view.addSubview(iconView)
		view.addSubview(contentView)

		let stackView = NSStackView()
		stackView.spacing = 2

		learnButton.target = self
		learnButton.action = #selector(learnMore)
		stackView.addArrangedSubview(learnButton)

		startButton.target = self
		startButton.action = #selector(start)
		stackView.addArrangedSubview(startButton)

		contentView.addArrangedSubview(stackView)

		let iconCenterX = iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
		iconCenterX.priority = NSLayoutConstraint.Priority.defaultLow

		let iconCenterY = iconView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		iconCenterY.priority = NSLayoutConstraint.Priority.defaultLow

		let stackTop = contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 84)
		stackTop.priority = NSLayoutConstraint.Priority.defaultLow

		NSLayoutConstraint.activate([
			view.widthAnchor.constraint(equalToConstant: 440),
			view.heightAnchor.constraint(equalToConstant: 280),

			iconCenterX,
			iconCenterY,

			stackTop,
			contentView.widthAnchor.constraint(equalToConstant: 290),
			contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 122),
			stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -4)
		])
	}

	override func viewDidAppear() {
		super.viewDidAppear()

		view.window?.makeFirstResponder(startButton)

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) { [weak self] in
			self?.animateIn()
		}
	}


	// MARK: - Private

	@objc private func learnMore() {
		start()
		NSApp.deactivate()

		let url = URL(string: "https://usecontrast.com/guide")!
		let application = try? NSWorkspace.shared.open(url, options: [], configuration: [:])
		application?.activate(options: [])
	}

	@objc private func start() {
		view.window?.close()
	}

	@objc private func animateIn() {
		NSLayoutConstraint.activate([
			iconView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 28),
			iconView.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
			contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 38)
		])

		NSAnimationContext.runAnimationGroup({ [weak self] context in
			context.duration = 0.3
			context.allowsImplicitAnimation = true
			self?.view.layoutSubtreeIfNeeded()

			self?.orangeView.frame = CGRect(x: -290, y: -30, width: 254, height: 240)
			self?.blueView.frame = CGRect(x: 279, y: -130, width: 230, height: 230)
			self?.pinkView.frame = CGRect(x: 310, y: 260, width: 96, height: 90)
			self?.contentView.alphaValue = 1
		}, completionHandler: nil)
	}
}
