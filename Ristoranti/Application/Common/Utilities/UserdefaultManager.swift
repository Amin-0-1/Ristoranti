//
//  UserdefaultManager.swift
//  WezCast
//
//  Created by Amin on 04/08/2022.
//

import Foundation

protocol LocalStorageInterface{
    func getValue(forKey key:UDKeys)->Any?
    func set(value val:Any,forKey key:UDKeys)
}
enum UDKeys:String{
    case onboarding
}

class UserdefaultManager: LocalStorageInterface{
    static let shared = UserdefaultManager()
    private let userDefaults:UserDefaults = UserDefaults.standard
    
    private init(){}
    func getValue(forKey key:UDKeys)->Any?{
        let val = userDefaults.value(forKey:key.rawValue)
        return val
    }
    func set(value val:Any,forKey key:UDKeys){
        userDefaults.set(val, forKey: key.rawValue)
    }
}
