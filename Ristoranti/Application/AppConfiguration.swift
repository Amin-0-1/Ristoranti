//
//  AppConfiguration.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation

class AppConfiguration {
    static var shared = AppConfiguration()
    let env = Environment()
    private init() {}
    
    lazy var kBaseURL: String = {
        do {
            return try env.get(.connectionProtocol).appending("://").appending(env.get(.serverURL))
        } catch {
            printDetailed(error)
            return ""
        }
    }()
    
    lazy var TOKEN: String = {
        do {
            return try env.get(.token)
        } catch {
            printDetailed(error)
            return ""
        }
    }()
    
    let kDeviceName = "galaxy A10"

    lazy var header: [String: String] = {
        return ["Accept-Language": "en"]
    }()
    
    private func printDetailed(_ error: Error) {
        let separator = "\n****************\n"
        print(separator, error, separator)
    }
}
