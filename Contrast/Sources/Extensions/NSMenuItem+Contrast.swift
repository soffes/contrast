import AppKit

extension NSMenuItem {
	convenience init(title: String, target: AnyObject? = nil, action: Selector? = nil, keyEquivalent: String? = nil,
					 modifiers: NSEvent.ModifierFlags? = nil)
	{
		self.init(title: title, action: action, keyEquivalent: keyEquivalent ?? "")

		if let target = target {
			self.target = target
		}

		if let modifiers = modifiers {
			self.keyEquivalentModifierMask = modifiers
		}
	}
}
