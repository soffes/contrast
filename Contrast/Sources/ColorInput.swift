//
//  ColorInput.swift
//  Contrast
//
//  Created by Sam Soffes on 6/29/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

final class ColorInput: NSControl {

	// MARK: - Properties

	var hexColor: HexColor = .white {
		didSet {
			if textField.stringValue.lowercased() == hexColor.hex.lowercased() {
				return
			}
			
			textField.stringValue = hexColor.hex
		}
	}

	var theme: Theme = .default {
		didSet {
			button.theme = theme
			textField.theme = theme
		}
	}

	private let stackView: NSStackView = {
		let view = NSStackView()
		view.translatesAutoresizingMaskIntoConstraints = false
		view.spacing = 0
		return view
	}()

	let button: Button = Button()

	let textField = TextField()


	// MARK: - Initializers

	override init(frame: NSRect) {
		super.init(frame: frame)

		stackView.addArrangedSubview(button)
		stackView.addArrangedSubview(textField)
		addSubview(stackView)

		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
			stackView.topAnchor.constraint(equalTo: topAnchor),
			stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
		])
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
