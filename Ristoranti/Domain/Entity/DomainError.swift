//
//  DomainError.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
enum DomainError{
    case connectionError
    case serverError
    case customError(String)
}

extension DomainError:Error{
    var localizedDescription: String{
        switch self {
            case .serverError:
                return "Server Error"
            case .connectionError:
                return "No internet connection, try again later!"
            case .customError(let string):
                return string
        }
    }
}
