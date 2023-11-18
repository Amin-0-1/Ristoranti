//
//  UserdefaultManager.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation

protocol LocalStorageInterface {
    func getObject<T: Codable>(forKey key: UDKeys) -> T?
    func set<T: Codable>(object: T?, forKey key: UDKeys)
    func getValue(forKey key: UDKeys) -> Any?
    func set(value val: Any, forKey key: UDKeys)
    func truncate()
}

enum UDKeys: String, CaseIterable {
    case onboarding
    case userData
}

class UserdefaultManager: LocalStorageInterface {
    static let shared = UserdefaultManager()
    private let userDefaults = UserDefaults.standard
    
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
