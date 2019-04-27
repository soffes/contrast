import AppKit
import Carbon
import HotKey

protocol KeyComboInputDelegate: class {
    func keyComboInputShouldBeginRecording(_ keyComboInput: KeyComboInput) -> Bool
    func keyComboInput(_ keyComboInput: KeyComboInput, canRecordKeyCombo keyCombo: KeyCombo) -> Bool
    func keyComboInputDidEndRecording(_ keyComboInput: KeyComboInput)
}

final class KeyComboInput: NSControl {

    // MARK: - Properties

    weak var delegate: KeyComboInputDelegate?
    var keyCombo: KeyCombo?

    private(set) var allowedModifiers: NSEvent.ModifierFlags = .allCocoaModifierFlags
    private(set) var requiredModifiers: NSEvent.ModifierFlags = []
    private(set) var allowsEmptyModifiers = false
    var drawsASCIIEquivalentOfShortcut = true
    var allowsEscapeToCancelRecording = true
    var allowsDeleteToClearShortcutAndEndRecording = true
    private(set) var isRecording = false

    // MARK: - NSResponder

    override var acceptsFirstResponder: Bool {
        return true
    }

    override func keyDown(with event: NSEvent) {
        if !performKeyEquivalent(with: event) {
            super.keyDown(with: event)
        }
    }

    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        if !isEnabled || window?.firstResponder != self {
            return false
        }

        let modifiers = event.modifierFlags.cocoa
        guard let key = Key(keyCode: event.keyCode) else {
            return false
        }

        if key == .space {
            return self.beginRecording()
        }

        if !isRecording {
            return false
        }

        if allowsEscapeToCancelRecording && key == .escape && modifiers.isEmpty {
            endRecording()
            return true
        }

        if allowsDeleteToClearShortcutAndEndRecording && (key == .delete || key == .forwardDelete) && modifiers.isEmpty
        {
            self.keyCombo = nil
            endRecording()
            return true
        }

        let keyCombo = KeyCombo(key: key, modifiers: modifiers)
        if isValid(keyCombo) {
            if let result = delegate?.keyComboInput(self, canRecordKeyCombo: keyCombo) {
                if result == false {
                    return true
                }

                self.keyCombo = keyCombo
                endRecording()
                return true
            }
        }

        return false
    }

    override func flagsChanged(with event: NSEvent) {
        if isRecording {
            let keyCombo = KeyCombo(event: event)
            if !keyCombo.modifiers.isEmpty && !isValid(keyCombo) {
                NSSound.beep()
                setNeedsDisplay()
            }
        }

        super.flagsChanged(with: event)
    }

    // MARK: - Configuration

    func set(allowedModifierFlags: NSEvent.ModifierFlags, requiredModifierFlags: NSEvent.ModifierFlags,
             allowsEmptyModifierFlags: Bool)
    {
        let allowedModifierFlags = allowedModifierFlags.cocoa
        let requiredModifierFlags = requiredModifierFlags.cocoa

        if allowedModifierFlags.intersection(requiredModifierFlags) != requiredModifierFlags {
            assertionFailure("Required flags \(requiredModifierFlags) MUST be allowed \(allowedModifierFlags)")
        }

        if allowsEmptyModifierFlags && !requiredModifierFlags.isEmpty {
            assertionFailure("Empty modifier flags MUST be disallowed if required modifier flags are not empty.")
        }

        self.allowedModifiers = allowedModifierFlags
        self.requiredModifiers = requiredModifierFlags
        self.allowsEmptyModifiers = allowsEmptyModifierFlags
    }

    // MARK: - Private

    private func initialize() {
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        setContentHuggingPriority(.required, for: .vertical)

        setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        setContentCompressionResistancePriority(.required, for: .vertical)

        toolTip = "Click to record shortcut"
    }

    private func beginRecording() -> Bool {
        if delegate?.keyComboInputShouldBeginRecording(self) == false {
            NSSound.beep()
            return false
        }

        // TODO
        
        return true
    }

    private func endRecording() {
        if !isRecording {
            return
        }

        sendAction(action, to: target)

        if window?.firstResponder == self && !canBecomeKeyView {
            window?.makeFirstResponder(nil)
        }

        delegate?.keyComboInputDidEndRecording(self)
    }

    private func isValid(_ keyCombo: KeyCombo) -> Bool {
        if let delegate = self.delegate {
            return delegate.keyComboInput(self, canRecordKeyCombo: keyCombo)
        }

        let modifiers = keyCombo.modifiers

        if !allowsEmptyModifiers && modifiers.isEmpty {
            return false
        }

        if modifiers.intersection(requiredModifiers) != requiredModifiers {
            return false
        }

        if modifiers.intersection(allowedModifiers) != modifiers {
            return false
        }

        return true
    }
}
