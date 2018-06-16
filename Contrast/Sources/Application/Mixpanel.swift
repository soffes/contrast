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
