//
//  PopoverViewController.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {

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
	fileprivate let backgroundInput = ColorInput()

	private let contrastRatioLabel: Label = {
		let view = Label()
		view.font = .systemFont(ofSize: 12, weight: NSFontWeightBold)
		view.alignment = .right
		view.contentInsets = EdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
		return view
	}()

	fileprivate var theme = Theme.`default` {
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

	fileprivate var position: Position? {
		didSet {
			foregroundInput.button.isActive = position == .foreground
			backgroundInput.button.isActive = position == .background
		}
	}
	
	fileprivate var windowController: EyeDropper? {
		willSet {
			windowController?.window?.orderOut(self)
		}
	}


	// MARK: - NSViewController

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

		foregroundInput.button.target = self
		foregroundInput.button.action = #selector(pickColor)

		backgroundInput.button.target = self
		backgroundInput.button.action = #selector(pickColor)

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

	override func viewDidDisappear() {
		super.viewDidDisappear()

		windowController?.cancel(self)
	}


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

		let contrastRatio = NSColor.contrastRatio(theme.foregroundColor, theme.backgroundColor)
		contrastRatioLabel.stringValue = String(format: "%0.2f", contrastRatio)
		scoreLabel.stringValue = Score(contrastRatio: contrastRatio).description
	}

	@objc private func pickColor(_ sender: Button) {
		position = foregroundInput.button == sender ? .foreground : .background

		let eyeDropper = EyeDropper(delegate: self)
		eyeDropper.magnify()
		windowController = eyeDropper
	}
}


extension PopoverViewController: EyeDropperDelegate {
	func eyeDropperDidSelectColor(_ color: NSColor, continuePicking: Bool) {
		guard let position = position else { return }

		switch position {
		case .foreground:
			theme.foregroundColor = color
		case .background:
			theme.backgroundColor = color
		}

		if continuePicking {
			self.position = position.opposite

			let eyeDropper = EyeDropper(delegate: self)
			eyeDropper.magnify()
			windowController = eyeDropper
		} else {
			windowController = nil
			self.position = nil
		}
	}

	func eyeDropperDidCancel() {
		windowController = nil
		position = nil
	}
}
