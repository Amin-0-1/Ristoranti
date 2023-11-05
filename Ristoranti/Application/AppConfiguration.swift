//
//  AppConfiguration.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation


class AppConfiguration{
    static var shared:AppConfiguration = AppConfiguration()
    private init(){}
    
    let BASE_URL = "http://\("216.219.83.182")/foodItem/public/api"
    let TOKEN = "1279|zBfsKdhO10hU9TEgCoHLFiCEyaash1fuCCUW8oM1"
    let DEVICE_NAME = "galaxy A10"

    lazy var header:[String:String] = {
        return ["Accept-Language" : "en"]
    }()
    
    
}


