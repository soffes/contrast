import AppKit

final class HexFormatter: Formatter {

	// MARK: - Properties

	private let maximumLength = 6
	private let allowedCharacters = CharacterSet(charactersIn: "0123456789ABCDEFabcdef")


	// MARK: - Formatter

	override func string(for obj: Any?) -> String? {
		return obj as? String
	}

	override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String,
                                 errorDescription error: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool
    {
		obj?.pointee = string as AnyObject
		return true
	}

	override func isPartialStringValid(_ partialStringPtr: AutoreleasingUnsafeMutablePointer<NSString>,
                                       proposedSelectedRange: NSRangePointer?, originalString: String,
                                       originalSelectedRange: NSRange,
                                       errorDescription: AutoreleasingUnsafeMutablePointer<NSString?>?) -> Bool
    {
		var result = true
		var partialString = partialStringPtr.pointee

		// Remove hash
		if partialString.contains("#") {
			partialString = partialString.replacingOccurrences(of: "#", with: "") as NSString
			partialStringPtr.pointee = partialString
			result = false
		}

		// Enforce length
		if partialString.length > maximumLength {
			partialString = partialString.substring(to: maximumLength) as NSString
			partialStringPtr.pointee = partialString
			NSSound.beep()
			return false
		}

		// TODO: Ensure characters are a subset of allowedCharacters

		return result
	}

	override func attributedString(for obj: Any, withDefaultAttributes attrs: [NSAttributedStringKey: Any]? = nil)
        -> NSAttributedString?
    {
		return nil
	}
}
