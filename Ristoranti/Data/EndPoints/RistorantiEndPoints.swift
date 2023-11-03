//
//  RistorantiEndPoints.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

enum RistorantiEndPoints:CustomStringConvertible{
    case login(LoginParamRequest)
    case fetchFood
    var description: String{
        switch self {
            case .login:
                return "/foodItem/public/api/users/login"
            case .fetchFood:
                return "/foodItem/public/api/foodItem"
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
            default: return nil
        }
    }
    
    var method: HTTPMethods {
        switch self {
            case .login:
                return .post
            default:
                return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
            case .login:
                return .JSONEncoding
            case .fetchFood:
                return .URLEncoding
        }
    }
    
    
}
