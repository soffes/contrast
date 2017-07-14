//
//  ColorsViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

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
		view.font = .systemFont(ofSize: 16, weight: NSFontWeightHeavy)
		view.contentInsets = EdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
		return view
	}()

	fileprivate let foregroundInput = ColorInput()

	private let swapButton = PlainButton()

	fileprivate let backgroundInput = ColorInput()

	private let contrastRatioLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 12, weight: NSFontWeightBold)
		view.alignment = .right
		view.contentInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
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
		super.init(nibName: nil, bundle: nil)!
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
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
		stackView.setCustomSpacing(4, after: scoreLabel)
		stackView.addArrangedSubview(foregroundInput)
		stackView.setCustomSpacing(4, after: foregroundInput)
		stackView.addArrangedSubview(swapButton)
		stackView.setCustomSpacing(4, after: swapButton)
		stackView.addArrangedSubview(backgroundInput)
		stackView.setCustomSpacing(4, after: backgroundInput)
		stackView.addArrangedSubview(contrastRatioLabel)

		for input in [foregroundInput, backgroundInput] {
			input.button.target = self
			input.button.action = #selector(pickColor)

			input.textField.delegate = self
			input.textField.arrowDelegate = self
		}

		scoreLabel.toolTip = "WCAG 2.0 Score"
		foregroundInput.button.toolTip = "Pick Foreground"
		foregroundInput.textField.toolTip = "Foreground Color"
		swapButton.toolTip = "Swap Colors"
		backgroundInput.button.toolTip = "Pick Background"
		backgroundInput.textField.toolTip = "Background Color"
		contrastRatioLabel.toolTip = "Contrast Ratio"

		swapButton.target = self
		swapButton.action = #selector(swapColors)

		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalToConstant: 54),

			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			scoreLabel.widthAnchor.constraint(equalToConstant: 71),
			contrastRatioLabel.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor)
		])

		NotificationCenter.default.addObserver(self, selector: #selector(themeDidChange), name: .themeDidChange, object: nil)
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

		let contrastRatio = NSColor.contrastRatio(theme.foregroundColor, theme.backgroundColor)
		contrastRatioLabel.set(text: String(format: "%0.2f", contrastRatio))
		scoreLabel.set(text: Score(contrastRatio: contrastRatio).description)

		delegate?.colorsViewController(self, didChangeTheme: theme)
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
	override func controlTextDidChange(_ notification: Notification) {
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
