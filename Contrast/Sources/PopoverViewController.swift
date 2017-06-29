//
//  PopoverViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {

	private let stackView: NSStackView = {
		let view = NSStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	private let scoreLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 16, weight: NSFontWeightHeavy)
		view.contentInsets = EdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
		return view
	}()

	private let foregroundInput = ColorInput()
	private let backgroundInput = ColorInput()

	private let contrastRatioLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 12, weight: NSFontWeightBold)
		view.alignment = .right
		view.contentInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		return view
	}()

	private var theme = Theme.`default` {
		didSet {
			themeDidChange()
		}
	}

	private let arrowView: NSView = {
		let view = NSView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.wantsLayer = true
		return view
	}()

	override func loadView() {
		view = NSView()
		view.wantsLayer = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(stackView)

		stackView.addArrangedSubview(scoreLabel)
		stackView.setCustomSpacing(4, after: scoreLabel)
		stackView.addArrangedSubview(foregroundInput)
		stackView.setCustomSpacing(12, after: foregroundInput)
		stackView.addArrangedSubview(backgroundInput)
		stackView.setCustomSpacing(4, after: backgroundInput)
		stackView.addArrangedSubview(contrastRatioLabel)

		NSLayoutConstraint.activate([
			view.heightAnchor.constraint(equalToConstant: 54),

			stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			stackView.topAnchor.constraint(equalTo: view.topAnchor),
			stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

			scoreLabel.widthAnchor.constraint(equalToConstant: 71),
			contrastRatioLabel.widthAnchor.constraint(equalTo: scoreLabel.widthAnchor)
		])

		themeDidChange()

		// Testing
		scoreLabel.stringValue = "AAA"
		contrastRatioLabel.stringValue = "21.00"

		foregroundInput.textField.nextKeyView = backgroundInput.textField
	}

	override func viewDidAppear() {
		super.viewDidAppear()

		guard let container = view.superview, arrowView.superview == nil else { return }

		container.addSubview(arrowView)
		arrowView.layer?.backgroundColor = theme.backgroundColor.cgColor

		NSLayoutConstraint.activate([
			arrowView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
			arrowView.topAnchor.constraint(equalTo: container.topAnchor),
			arrowView.widthAnchor.constraint(equalTo: container.widthAnchor),
			arrowView.heightAnchor.constraint(equalToConstant: 15)
		])
	}

//	@IBAction func colorWellDidChange(_ sender: Any?) {
//		scoreLabel.textColor = colorWell1.color
//		MenuBarController.shared?.backgroundColor = colorWell2.color
//
//		calculateContrastRatio()
//	}
//
//	private func calculateContrastRatio() {
//		let contrastRatio = NSColor.contrastRatio(colorWell1.color, colorWell2.color)
//		scoreLabel.stringValue = Score(contrastRatio: contrastRatio).description
//	}

	// MARK: - Private

	private func themeDidChange() {
		let background = theme.backgroundColor.cgColor
		view.layer?.backgroundColor = background
		arrowView.layer?.backgroundColor = background

		scoreLabel.textColor = theme.foregroundColor
		contrastRatioLabel.textColor = theme.foregroundColor

		backgroundInput.theme = theme
		backgroundInput.color = theme.backgroundColor

		foregroundInput.theme = theme
		foregroundInput.color = theme.foregroundColor
	}
}
