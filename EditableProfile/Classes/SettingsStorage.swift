//
//  SettingsStorage.swift
//  EditableProfile
//
//  Created by Aliaksei Zhemblouski on 5/19/20.
//

import Foundation

final class SettingsStorage {
    
    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    private func set(value: Codable?, for key: String) {
        defaults.setValue(value, forKey: key)
    }
    
	private func getValue<T: Codable>(for key: String) -> T? {
        guard let stored = defaults.value(forKey: key) else {
            return nil
        }
        return stored as? T
    }
}

extension SettingsStorage: UserModelProviderSettings {
	var userData: Data? {
		get {
			return getValue(for: "userData")
		}
		set {
			return set(value: newValue, for: "userData")
		}
	}
}
