import Carbon
import HotKey

extension KeyCombo {
	static func systemHotKeys() -> [KeyCombo] {
		var unmanagedGlobalHotkeys: Unmanaged<CFArray>?
		guard CopySymbolicHotKeys(&unmanagedGlobalHotkeys) == noErr,
			let globalHotkeys = unmanagedGlobalHotkeys?.takeRetainedValue() else
		{
			assertionFailure("Unable to get system-wide hotkeys")
			return []
		}

		return (0..<CFArrayGetCount(globalHotkeys)).compactMap { i in
			let hotKeyInfo = unsafeBitCast(CFArrayGetValueAtIndex(globalHotkeys, i), to: NSDictionary.self)
			guard (hotKeyInfo[kHISymbolicHotKeyEnabled] as? NSNumber)?.boolValue == true,
				let keyCode = (hotKeyInfo[kHISymbolicHotKeyCode] as? NSNumber)?.uint32Value,
				let modifiers = (hotKeyInfo[kHISymbolicHotKeyModifiers] as? NSNumber)?.uint32Value else
			{
					return nil
			}

			let keyCombo = KeyCombo(carbonKeyCode: keyCode, carbonModifiers: modifiers)
			return keyCombo.isValid ? keyCombo : nil
		}
	}
}
