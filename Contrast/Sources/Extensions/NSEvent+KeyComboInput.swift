import AppKit

extension NSEvent.ModifierFlags {
    static var allCocoaModifierFlags: NSEvent.ModifierFlags {
        return [.command, .option, .shift, .control]
    }

    var cocoa: NSEvent.ModifierFlags {
        let possible = NSEvent.ModifierFlags.allCocoaModifierFlags
        var flags = self
        flags.formIntersection(possible)
        return flags
    }
}
