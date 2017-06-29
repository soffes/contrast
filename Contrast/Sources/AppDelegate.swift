//
//  AppDelegate.swift
//  Contrast
//
//  Created by Sam Soffes on 6/28/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import AppKit

@NSApplicationMain final class AppDelegate: NSObject {

	// MARK: - Properties

	let menuBarController = MenuBarController()
	fileprivate var windowController: NSWindowController?
}


extension AppDelegate: NSApplicationDelegate {
	func applicationDidFinishLaunching(_ aNotification: Notification) {
		menuBarController.showPopover(self)

//		let eyeDropper = EyeDropper()
//		eyeDropper.magnify()
//		windowController = eyeDropper


//		let list = CGWindowListCopyWindowInfo([.optionOnScreenOnly], kCGNullWindowID)! //as! [[String: Any]]

//		print("count: \(list.count)")
//
//		let filtered = list//.filter {
//			if $0[String(kCGWindowOwnerPID)] as? pid_t == NSRunningApplication.current().processIdentifier {
//				return false
//			}
//
//			return true
//		}
//
//		print("count: \(filtered.count)")

//		let cgImage = CGImage(windowListFromArrayScreenBounds: NSScreen.main()!.frame, windowArray: filtered as CFArray, imageOption: .nominalResolution)
//		let image = NSImage()
//		image.addRepresentation(NSBitmapImageRep(cgImage: cgImage!))
//		print("image: \(image)")
	}
}
