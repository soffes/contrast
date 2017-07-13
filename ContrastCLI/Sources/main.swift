//
//  main.swift
//  ContrastCLI
//
//  Created by Sam Soffes on 7/7/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

let args = CommandLine.arguments

if args.count != 3 {
	print("Usage: contrast FOREGROUND_HEX BACKGROUND_HEX")
	exit(1)
}

let hex1 = args[1]
guard let color1 = NSColor(hex: hex1) else {
	print("Invalid color: '\(hex1)'")
	exit(1)
}

let hex2 = args[2]
guard let color2 = NSColor(hex: hex2) else {
	print("Invalid color: '\(hex2)'")
	exit(1)
}

let contrastRatio = NSColor.contrastRatio(color1, color2)
let score = Score(contrastRatio: contrastRatio)
print(String(format: "%@ - %0.2f", score.description, contrastRatio))
