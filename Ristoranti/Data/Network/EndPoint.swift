//
//  EndPoint.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

typealias HTTPHeaders = [String: String]
typealias Parameters = [String: Any]

enum HTTPMethods: String {
    case post
    case get
    case delete
    case put
}

protocol EndPoint {
    var base: String { get }
    var path: String { get }
    var header: HTTPHeaders? { get }
    var parameters: Parameters? { get }
    var method: HTTPMethods { get }
    var encoding: ParameterEncoding { get }
}

extension EndPoint {
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = header
        if let parameters = parameters {
            switch encoding {
                case .JSONEncoding:
                    try? ParameterEncoding.jsonEncode(urlRequest: &urlRequest, with: parameters)
                case .URLEncoding:
                    try? ParameterEncoding.urlEncode(urlRequest: &urlRequest, with: parameters)
                case .MULTIPARTEncoding:
                    try? ParameterEncoding.multipartEncode(urlRequest: &urlRequest, with: parameters)
            }
        }
        return urlRequest
    }
}
