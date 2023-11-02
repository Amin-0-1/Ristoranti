//
//  RistorantiEndPoints.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

enum RistorantiEndPoints:CustomStringConvertible{
    case login(LoginParamRequest)
    
    var description: String{
        switch self {
            case .login:
                return "/foodItem/public/api/users/login"
        }
    }
}
extension RistorantiEndPoints:EndPoint{
    var base: String {
        return AppConfiguration.shared.BASE_URL
    }
    
    var path: String {
        return self.description
    }
    
    var header: HTTPHeaders? {
        return nil
    }
    
    var parameters: Parameters? {
        switch self {
            case .login(let loginParamRequest):
                return loginParamRequest.dictionary
        }
    }
    
    var method: HTTPMethods {
        switch self {
            case .login:
                return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .login:
                return .JSONEncoding
        }
    }
    
    
}
