import AppKit
import Color

protocol ColorsViewControllerDelegate: class {
	func colorsViewController(_ viewController: ColorsViewController, didChangeTheme theme: Theme)
}

class ColorsViewController: NSViewController {

	// MARK: - Types

	fileprivate enum Position {
		case foreground
		case background

		var opposite: Position {
			switch self {
			case .foreground: return .background
			case .background: return .foreground
			}
		}
	}


	// MARK: - Properties

	weak var delegate: ColorsViewControllerDelegate?

	private let stackView: NSStackView = {
		let view = NSStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.spacing = 0
		return view
	}()

	private let scoreLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 16, weight: NSFont.Weight.heavy)
		view.toolTip = "WCAG 2.0 Score"
		return view
	}()

	fileprivate let foregroundInput: ColorInput = {
		let view = ColorInput()
		view.button.toolTip = "Pick Foreground"
		view.textField.toolTip = "Foreground Color"
		return view
	}()

	private let swapButton: PlainButton = {
		let view = PlainButton()
		view.image = #imageLiteral(resourceName: "Swap")
		view.toolTip = "Swap Colors"
		return view
	}()

	fileprivate let backgroundInput: ColorInput = {
		let view = ColorInput()
		view.button.toolTip = "Pick Background"
		view.textField.toolTip = "Background Color"
		return view
	}()

	private let contrastRatioLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 12, weight: NSFont.Weight.bold)
		view.toolTip = "Contrast Ratio"
		return view
	}()

	private let settingsButton: PlainButton = {
		let view = PlainButton()
		view.image = #imageLiteral(resourceName: "Cog")
		view.toolTip = "Settings"
		view.isSettings = true
		view.sendAction(on: NSEvent.EventTypeMask.leftMouseDown)
		return view
	}()

	private let isInPopover: Bool

	fileprivate(set) var theme: Theme {
		didSet {
			applyTheme()
		}
	}

	private let arrowView: NSView = {
		let view = NSView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		return view
	}()

	fileprivate var position: Position? {
		didSet {
			foregroundInput.button.isActive = position == .foreground
			backgroundInput.button.isActive = position == .background
		}
	}

	fileprivate var eyeDropperController: EyeDropperController? {
		willSet {
			eyeDropperController?.delegate = nil
			eyeDropperController?.cancel(self)
		}
	}


	// MARK: - Initializers

	init(theme: Theme? = nil, isInPopover: Bool = true) {
		self.theme = theme ?? ColorsController.shared.theme
		self.isInPopover = isInPopover
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}


	// MARK: - NSResponder

	override func cancelOperation(_ sender: Any?) {
		if isInPopover {
			(NSApp.delegate as? AppDelegate)?.menuBarController.popoverController.dismissPopover(sender)
		} else {
			view.window?.close()
		}
	}


	// MARK: - NSViewController

	override func loadView() {
		view = NSView()
		view.wantsLayer = true
		view.layer?.isOpaque = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(stackView)

		stackView.addArrangedSubview(scoreLabel)
		stackView.setCustomSpacing(12, after: scoreLabel)
		stackView.addArrangedSubview(foregroundInput)
		stackView.setCustomSpacing(4, after: foregroundInput)
		stackView.addArrangedSubview(swapButton)
		stackView.setCustomSpacing(4, after: swapButton)
		stackView.addArrangedSubview(backgroundInput)
		stackView.setCustomSpacing(12, after: backgroundInput)
		stackView.addArrangedSubview(contrastRatioLabel)
		stackView.setCustomSpacing(8, after: contrastRatioLabel)
		stackView.addArrangedSubview(settingsButton)

		for input in [foregroundInput, backgroundInput] {
			input.button.target = self
			input.button.action = #selector(pickColor)

			input.textField.delegate = self
			input.textField.arrowDelegate = self
		}

		swapButton.target = self
		swapButton.action = #selector(swapColors)

		settingsButton.target = self
		settingsButton.action = #selector(showMenu)

		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalToConstant: 54),

			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			scoreLabel.widthAnchor.constraint(equalToConstant: 38),
			contrastRatioLabel.widthAnchor.constraint(equalToConstant: 36),

			swapButton.heightAnchor.constraint(equalTo: foregroundInput.button.heightAnchor),
			settingsButton.heightAnchor.constraint(equalTo: swapButton.heightAnchor)
		])

		NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange,
                                               object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(updateTextFields),
                                               name: UserDefaults.didChangeNotification, object: nil)
		applyTheme()
	}

	override func viewDidAppear() {
		super.viewDidAppear()

		guard isInPopover, let container = view.superview, arrowView.superview == nil else { return }

		container.addSubview(arrowView)
		arrowView.layer?.backgroundColor = theme.backgroundColor.cgColor

		NSLayoutConstraint.activate([
			arrowView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
			arrowView.topAnchor.constraint(equalTo: container.topAnchor),
			arrowView.widthAnchor.constraint(equalTo: container.widthAnchor),
			arrowView.heightAnchor.constraint(equalToConstant: 15)
		])
	}

	override func viewDidDisappear() {
		super.viewDidDisappear()

		eyeDropperController = nil
	}


	// MARK: - Actions

	func pickForeground() {
		pickColor(foregroundInput.button)
	}

	func pickBackground() {
		pickColor(backgroundInput.button)
	}

	@objc private func pickColor(_ sender: Button) {
		NSSound.contrastPick.forcePlay()

		let eyeDropper = EyeDropperController(delegate: self)
		eyeDropper.magnify()
		eyeDropperController = eyeDropper

		position = foregroundInput.button == sender ? .foreground : .background
	}

	@objc private func swapColors(_ sender: Any?) {
		NSSound.contrastSwap.forcePlay()
		theme.swap()
	}


	// MARK: - Private

	@objc private func themeDidChange(_ notification: Notification) {
		if ColorsController.shared.theme == theme {
			return
		}

		theme = ColorsController.shared.theme
	}

	@objc func showMenu(_ sender: Any?) {
		guard let sender = sender as? NSView, let event = NSApplication.shared.currentEvent else { return }

		let menu = MenuController.shared.createMenu(isInPopover: isInPopover)
		NSMenu.popUpContextMenu(menu, with: event, for: sender)
	}

	private func applyTheme() {
		if ColorsController.shared.theme != theme {
			ColorsController.shared.theme = theme
		}

		let background = theme.backgroundColor.cgColor
		view.layer?.backgroundColor = background
		arrowView.layer?.backgroundColor = background

		scoreLabel.theme = theme
		contrastRatioLabel.theme = theme

		backgroundInput.theme = theme
		backgroundInput.hexColor = theme.background

		swapButton.theme = theme

		foregroundInput.theme = theme
		foregroundInput.hexColor = theme.foreground

		settingsButton.theme = theme

		let contrastRatio = theme.foregroundColor.contrastRatio(to: theme.backgroundColor)
		contrastRatioLabel.set(text: String(format: "%0.2f", contrastRatio))
		scoreLabel.set(text: ConformanceLevel(contrastRatio: contrastRatio).description)

		delegate?.colorsViewController(self, didChangeTheme: theme)
	}

	@objc private func updateTextFields() {
		foregroundInput.updateTextField()
		backgroundInput.updateTextField()
	}
}


extension ColorsViewController: EyeDropperControllerDelegate {
	func eyeDropperController(_ controller: EyeDropperController, didSelectColor color: NSColor, continuePicking: Bool) {
		guard let position = position else { return }

		switch position {
		case .foreground:
			theme.foregroundColor = color
		case .background:
			theme.backgroundColor = color
		}

		if continuePicking {
			self.position = position.opposite

			let eyeDropper = EyeDropperController(delegate: self)
			eyeDropper.magnify()
			eyeDropperController = eyeDropper
		} else {
			eyeDropperController = nil
			self.position = nil
		}
	}

	func eyeDropperControllerDidCancel(_ controller: EyeDropperController) {
		eyeDropperController = nil
		position = nil
	}
}


extension ColorsViewController: NSTextFieldDelegate {
	func controlTextDidChange(_ notification: Notification) {
		guard let textField = notification.object as? NSTextField,
			let color = NSColor(hex: textField.stringValue)
		else { return }

		let hexColor = HexColor(color: color, hex: textField.stringValue)

		if textField == foregroundInput.textField {
			theme.foreground = hexColor
		} else {
			theme.background = hexColor
		}
	}
}


extension ColorsViewController: TextFieldArrowDelegate {
	func textField(_ textField: TextField, didPressUpWithShift shift: Bool) {
		let increment: CGFloat = shift ? 0.1 : 0.01

		if textField == foregroundInput.textField {
			theme.foreground.lighten(by: increment)
		} else {
			theme.background.lighten(by: increment)
		}
	}

	func textField(_ textField: TextField, didPressDownWithShift shift: Bool) {
		let increment: CGFloat = shift ? 0.1 : 0.01

		if textField == foregroundInput.textField {
			theme.foreground.darken(by: increment)
		} else {
			theme.background.darken(by: increment)
		}
	}
}
