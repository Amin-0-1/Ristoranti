//
//  UserdefaultManager.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation

/// Protocol defining the interface for local storage operations
protocol LocalStorageInterface {
    /// Retrieve a generic object from UserDefaults based on a specific key
    /// - Parameters:
    ///   - key: Custom key for UserDefaults
    /// - Returns: An optional generic value representing whether the key contains a value in UserDefaults
    func getObject<T: Codable>(forKey key: UDKeys) -> T?
    
    /// Set a generic object in UserDefaults with a specified key
    /// - Parameters:
    ///   - object: Generic object to be saved in UserDefaults
    ///   - key: Custom key in UserDefaults to save the object relative to
    func set<T: Codable>(object: T?, forKey key: UDKeys)
    
    /// Retrieve a value from UserDefaults based on a key
    /// - Parameters:
    ///   - key: UserDefaults key
    /// - Returns: An optional value representing the existence of a value relative to the key
    func getValue(forKey key: UDKeys) -> Any?
    
    /// Set a value in UserDefaults for a specified key
    /// - Parameters:
    ///   - val: Value to be saved in UserDefaults
    ///   - key: Custom key in UserDefaults to save the value relative to
    func set(value val: Any, forKey key: UDKeys)
    
    /// Remove all values stored in UserDefaults
    func truncate()
}

/// Enum defining custom keys for UserDefaults
enum UDKeys: String, CaseIterable {
    case onboarding
    case userData
}

/// Wrapper class on top of UserDefaults, facilitating easy access
class UserdefaultManager: LocalStorageInterface {
    /// Shared instance of UserdefaultManager
    static let shared = UserdefaultManager()
    
    /// UserDefaults instance
    private let userDefaults = UserDefaults.standard
    
    /// Private initializer to enforce singleton pattern
    private init() {}
    
    func getObject<T: Codable>(forKey key: UDKeys) -> T? {
        if let data = userDefaults.data(forKey: key.rawValue) {
            return try? PropertyListDecoder().decode([T].self, from: data).first
        }
        return nil
    }
    
    func set<T: Codable>(object: T?, forKey key: UDKeys) {
        if let value = object {
            if let data = try? PropertyListEncoder().encode([value]) {
                userDefaults.set(data, forKey: key.rawValue)
            }
        } else {
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
    
    func getValue(forKey key: UDKeys) -> Any? {
        let val = userDefaults.value(forKey: key.rawValue)
        return val
    }
    
    func set(value val: Any, forKey key: UDKeys) {
        userDefaults.set(val, forKey: key.rawValue)
    }
    
    func truncate() {
        for key in UDKeys.allCases {
            userDefaults.removeObject(forKey: key.rawValue)
        }
    }
}
