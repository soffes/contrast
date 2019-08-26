import Carbon
import CoreServices
import HotKey

extension Key: CustomStringConvertible {
	public var description: String {
		let scanCode = UInt16(self.carbonKeyCode)
		let maxNameLength = 4
		var nameBuffer = [UniChar](repeating: 0, count: maxNameLength)
		var nameLength = 0

		let modifierKeys = UInt32(alphaLock >> 8) & 0xFF // Caps Lock
		var deadKeys: UInt32 = 0
		let keyboardType = UInt32(LMGetKbdType())

		let source = TISCopyCurrentKeyboardLayoutInputSource().takeRetainedValue()
		guard let ptr = TISGetInputSourceProperty(source, kTISPropertyUnicodeKeyLayoutData) else {
			NSLog("[HotKey.Key] Could not get keyboard layout data")
			return ""
		}
		let layoutData = Unmanaged<CFData>.fromOpaque(ptr).takeUnretainedValue() as Data
		let osStatus = layoutData.withUnsafeBytes { bytes in
			return UCKeyTranslate(bytes, scanCode,
								  UInt16(kUCKeyActionDown), modifierKeys, keyboardType,
								  UInt32(kUCKeyTranslateNoDeadKeysMask), &deadKeys, maxNameLength, &nameLength,
								  &nameBuffer)
		}

		guard osStatus == noErr else {
			NSLog("[HotKey.Key] Code: 0x%04X  Status: %+i", scanCode, osStatus)
			return ""
		}

		return String(utf16CodeUnits: nameBuffer, count: nameLength)
	}
}
