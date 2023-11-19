//
//  Environment.swift
//  Football-Leagues
//
//  Created by Amin on 29/10/2023.
//

import Foundation
public struct Environment {
    
    private var infoDict: [String: Any]? {
        guard let dict = Bundle.main.infoDictionary else {
            return nil
        }
        return dict
    }
    
    public func get(_ key: EnvKey) throws -> String {
        guard let infoDict = infoDict else {
            throw EnvError.plistNotFound
        }
        guard let element = infoDict[key.value] as? String else {
            throw EnvError.keyNotFound(key)
        }
        return element
    }
}

extension Environment {
    public enum EnvKey {
        case serverURL
        case token
        case connectionProtocol
        
        var value: String {
            switch self {
                case .serverURL:
                    return "BASE_URL"
                case .connectionProtocol:
                    return "PROTOCOL"
                case .token:
                    return "TOKEN"
            }
        }
    }
    
    public enum EnvError: Error {
        case keyNotFound(EnvKey)
        case plistNotFound
        
        var localizedDescription: String {
            switch self {
                case .keyNotFound(let envKey):
                    return "\(envKey.value) not found in the plist file"
                case .plistNotFound:
                    return "plist file is not exist"
            }
        }
    }

}
