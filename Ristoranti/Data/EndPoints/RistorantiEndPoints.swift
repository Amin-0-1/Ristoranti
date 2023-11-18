//
//  RistorantiEndPoints.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

enum RistorantiEndPoints: CustomStringConvertible {
    case login(LoginParamRequest)
    case foodItems
    case details(Int)
    var description: String {
        switch self {
            case .login:
                return "/foodItem/public/api/users/login"
            case .foodItems:
                return "/foodItem/public/api/foodItem"
            case .details(let id):
                return "/foodItem/public/api/foodItem/\(id)"
        }
    }
}
extension RistorantiEndPoints: EndPoint {
    var base: String {
        return AppConfiguration.shared.kBaseURL
    }
    
    var path: String {
        return self.description
    }
    
    var header: HTTPHeaders? {
        return AppConfiguration.shared.header
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
    
    var encoding: Encoding {
        return .JSONEncoding
    }
}
