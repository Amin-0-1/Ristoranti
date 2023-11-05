//
//  APIClient.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation
import Combine

protocol APIClientProtocol{
    func execute<T:Codable>(request:EndPoint) -> Future<T, Error>
}

class APIClient:NSObject, URLSessionDataDelegate,APIClientProtocol{
    
    static let shared = APIClient(config: .default)
    private var session: URLSession!
    
    private init(config: URLSessionConfiguration) {
        super.init()
        session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }
    
    func execute<T:Codable>(request:EndPoint) -> Future<T, Error>{
        
        return Future<T,Error>{ promise in
            let task = self.session.dataTask(with: request.request){ data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        if let urlError = error as? URLError {
                            switch urlError.code {
                                case .notConnectedToInternet:
                                    promise(.failure(NetworkError.noInternetConnection))
                                case .timedOut:
                                    promise(.failure(NetworkError.timeout))
                                case .badURL,.badURL:
                                    promise(.failure(NetworkError.invalidURL))
                                default:
                                    promise(.failure(NetworkError.requestFailed))
                                    
                            }
                        } else {
                            promise(.failure(NetworkError.requestFailed))
                        }
                        return
                    }
                    
                    guard let data = data else {
                        promise(.failure(NetworkError.invalidResponse))
                        return
                    }
                    
                    guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                        promise(.failure(NetworkError.serverError(data)))
                        return
                    }
                    
                    guard let model = try? JSONDecoder().decode(T.self, from: data)else {
                        promise(.failure(NetworkError.decodingFailed))
                        return
                    }
                    promise(.success(model))
                    
                }
            }
            task.resume()
        }
    }
}
