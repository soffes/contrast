import HotKey

extension Key: CustomStringConvertible {
	public var description: String {
		switch  self {
		case .a:
			return "A"
		case .s:
			return "S"
		case .d:
			return "D"
		case .f:
			return "F"
		case .h:
			return "H"
		case .g:
			return "G"
		case .z:
			return "Z"
		case .x:
			return "X"
		case .c:
			return "C"
		case .v:
			return "V"
		case .b:
			return "B"
		case .q:
			return "Q"
		case .w:
			return "W"
		case .e:
			return "E"
		case .r:
			return "R"
		case .y:
			return "Y"
		case .t:
			return "T"
		case .one, .keypad1:
			return "1"
		case .two, .keypad2:
			return "2"
		case .three, .keypad3:
			return "3"
		case .four, .keypad4:
			return "4"
		case .six, .keypad6:
			return "6"
		case .five, .keypad5:
			return "5"
		case .equal:
			return "="
		case .nine, .keypad9:
			return "9"
		case .seven, .keypad7:
			return "7"
		case .minus:
			return "-"
		case .eight, .keypad8:
			return "8"
		case .zero, .keypad0:
			return "0"
		case .rightBracket:
			return "]"
		case .o:
			return "O"
		case .u:
			return "U"
		case .leftBracket:
			return "["
		case .i:
			return "I"
		case .p:
			return "P"
		case .l:
			return "L"
		case .j:
			return "J"
		case .quote:
			return "\""
		case .k:
			return "K"
		case .semicolon:
			return ";"
		case .backslash:
			return "\\"
		case .comma:
			return ","
		case .slash:
			return "/"
		case .n:
			return "N"
		case .m:
			return "M"
		case .period:
			return "."
		case .grave:
			return "`"
		case .keypadDecimal:
			return "."
		case .keypadMultiply:
			return "𝗑"
		case .keypadPlus:
			return "+"
		case .keypadClear:
			return "⌧"
		case .keypadDivide:
			return "/"
		case .keypadEnter:
			return "↩︎"
		case .keypadMinus:
			return "-"
		case .keypadEquals:
			return "="
		case .`return`:
			return "↩︎"
		case .tab:
			return "⇥"
		case .space:
			return "␣"
		case .delete:
			return "⌦"
		case .escape:
			return "⎋"
		case .command, .rightCommand:
			return "⌘"
		case .shift, .rightShift:
			return "⇧"
		case .capsLock:
			return "⇪"
		case .option, .rightOption:
			return "⌥"
		case .control, .rightControl:
			return "⌃"
		case .function:
			return "fn"
		case .f17:
			return "F17"
		case .volumeUp:
			return "🔊"
		case .volumeDown:
			return "🔉"
		case .mute:
			return "🔇"
		case .f18:
			return "F18"
		case .f19:
			return "F19"
		case .f20:
			return "F20"
		case .f5:
			return "F5"
		case .f6:
			return "F6"
		case .f7:
			return "F7"
		case .f3:
			return "F3"
		case .f8:
			return "F8"
		case .f9:
			return "F9"
		case .f11:
			return "F11"
		case .f13:
			return "F13"
		case .f16:
			return "F16"
		case .f14:
			return "F14"
		case .f10:
			return "F10"
		case .f12:
			return "F12"
		case .f15:
			return "F15"
		case .help:
			return "?⃝"
		case .home:
			return "↖"
		case .pageUp:
			return "⇞"
		case .forwardDelete:
			return "⌦"
		case .f4:
			return "F4"
		case .end:
			return "↘"
		case .f2:
			return "F2"
		case .pageDown:
			return "⇟"
		case .f1:
			return "F1"
		case .leftArrow:
			return "←"
		case .rightArrow:
			return "→"
		case .downArrow:
			return "↓"
		case .upArrow:
			return "↑"
		}
	}
}
