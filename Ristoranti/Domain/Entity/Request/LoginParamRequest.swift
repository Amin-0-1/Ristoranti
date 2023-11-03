//
//  LoginParamRequest.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

struct LoginParamRequest:Encodable{
    let phone:String
    let device_name:String = AppConfiguration.shared.DEVICE_NAME
    let password:String
}
