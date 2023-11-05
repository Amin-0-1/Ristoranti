//
//  ParameterEncoding.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation

enum ParameterEncoding {
    case URLEncoding
    case JSONEncoding
    case MULTIPARTEncoding
    
    static func jsonEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
    
    static func urlEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        guard let url = urlRequest.url else { throw NetworkError.invalidURL }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            urlRequest.url = urlComponents.url
        }
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
    
    static func multipartEncode(urlRequest: inout URLRequest, with parameters: Parameters) throws {
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let httpBody = NSMutableData()
        parameters.forEach { param in
            let key = param.key
            let value = param.value
            switch value {
                case is String:
                    guard let value = value as? String else { return }
                    var fieldString = "--\(boundary)\r\n"
                    fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
                    fieldString += "\r\n"
                    fieldString += "\(value)\r\n"
                    httpBody.appendString(fieldString)
                case is (name: String, data: Data, mimeType: String):
                    guard let value = value as? (name: String, data: Data, mimeType: String) else { return }
                    let data = NSMutableData()
                    
                    data.appendString("--\(boundary)\r\n")
                    data.appendString("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(value.name)\"\r\n")
                    data.appendString("Content-Type: \(value.mimeType)\r\n\r\n")
                    data.append(value.data)
                    data.appendString("\r\n")
                    httpBody.append(data as Data)
                default:
                    break
            }
        }
        httpBody.appendString("--\(boundary)--")
        urlRequest.httpBody = httpBody as Data
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}
