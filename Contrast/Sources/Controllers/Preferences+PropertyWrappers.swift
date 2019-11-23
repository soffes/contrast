import Foundation
import HotKey

extension Preferences {
	@propertyWrapper
	struct UserDefault<T> {
		let key: Key
		let defaultValue: T

		init(_ key: Key, defaultValue: T) {
			self.key = key
			self.defaultValue = defaultValue
		}

		var wrappedValue: T {
			get {
				UserDefaults.standard.object(forKey: key.rawValue) as? T ?? defaultValue
			}

			set {
				UserDefaults.standard.set(newValue, forKey: key.rawValue)
			}
		}
	}

	@propertyWrapper
	struct OptionalUserDefault<T> {
		let key: Key

		init(_ key: Key) {
			self.key = key
		}

		var wrappedValue: T? {
			get {
				UserDefaults.standard.object(forKey: key.rawValue) as? T
			}

			set {
				if let value = newValue {
					UserDefaults.standard.set(value, forKey: key.rawValue)
				} else {
					UserDefaults.standard.removeObject(forKey: key.rawValue)
				}
			}
		}
	}

	@propertyWrapper
	struct KeyComboUserDefault {
		let key: Key

		init(_ key: Key) {
			self.key = key
		}

		var wrappedValue: KeyCombo? {
			get {
				UserDefaults.standard.dictionary(forKey: key.rawValue).flatMap({ KeyCombo(dictionary: $0) })
			}

			set {
				if let value = newValue {
					UserDefaults.standard.set(value.dictionary, forKey: key.rawValue)
				} else {
					UserDefaults.standard.removeObject(forKey: key.rawValue)
				}
			}
		}
	}

	@propertyWrapper
	struct ColorProfileUserDefault {
		let key: Key

		init(_ key: Key) {
			self.key = key
		}

		var wrappedValue: ColorProfile {
			get {
				UserDefaults.standard.string(forKey: key.rawValue).flatMap(ColorProfile.init) ?? .unmanaged
			}

			set {
				UserDefaults.standard.set(newValue.rawValue, forKey: key.rawValue)
			}
		}
	}
}
