import AppKit
import HotKey

protocol KeyComboInputDelegate: class {
    func keyComboInputShouldBeginRecording(_ keyComboInput: KeyComboInput) -> Bool
    func keyComboInput(_ keyComboInput: KeyComboInput, canRecordKeyCombo keyCombo: KeyCombo) -> Bool
    func keyComboInputDidEndRecording(_ keyComboInput: KeyComboInput)
}

final class KeyComboInput: NSControl {
    weak var delegate: KeyComboInputDelegate?
    var keyCombo: KeyCombo?
}
