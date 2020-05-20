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
    
    private func set(value: Codable, for key: String) {
        defaults.setValue(value, forKey: key)
    }
    
    private func getValue<T>(for key: String, defaultValue: T) -> T where T: Codable {
        guard let stored = defaults.value(forKey: key) else {
            return defaultValue
        }
        return (stored as? T) ?? defaultValue
    }
}

extension SettingsStorage: RootViewModelSettings {
    
    var isUserRegistered: Bool {
        get {
            return getValue(for: "isUserRegistered", defaultValue: false)
        }
        set {
            set(value: newValue, for: "isUserRegistered")
        }
    }
}
