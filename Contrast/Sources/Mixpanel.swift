//
//  Mixpanel.swift
//  Contrast
//
//  Created by Sam Soffes on 7/13/17.
//  Copyright © 2017 Nothing Magical, Inc. All rights reserved.
//

import Foundation
import Mixpanel

let mixpanel: Mixpanel = {
	var mp = Mixpanel(token: Secrets.mixpanelToken)

	#if DEBUG
		mp.enabled = false
	#endif

	let key = "Identifier"
	if let identifier = UserDefaults.standard.string(forKey: key) {
		mp.identify(identifier: identifier)
	} else {
		let identifier = UUID().uuidString
		UserDefaults.standard.set(identifier, forKey: key)
		mp.identify(identifier: identifier)
	}

	return mp
}()
