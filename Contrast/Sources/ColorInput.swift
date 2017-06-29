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

	var color: NSColor = .white

	let button: Button = {
		let view = Button()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()

	let textField: TextField = {
		let view = TextField()
		view.translatesAutoresizingMaskIntoConstraints = false
		return view
	}()
}
