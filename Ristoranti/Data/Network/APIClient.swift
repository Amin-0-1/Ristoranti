//
//  APIClient.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation
import Combine

protocol APIClientProtocol {
    func execute<T: Codable>(request: EndPoint) -> Future<T, Error>
}

class APIClient: APIClientProtocol {
    static let shared = APIClient(config: .default)
    private var session: URLSession
    
    init(config: URLSessionConfiguration) {
        self.session = URLSession(configuration: config)
    }

    func execute<T: Codable>(request: EndPoint) -> Future<T, Error> {
        return Future<T, Error> { promise in
            guard let request = request.request else {
                let url = request.urlComponents.string
                promise(.failure(NetworkError.invalidURL(url)))
                return
            }
            let task = self.session.dataTask(with: request) { data, response, error in
                DispatchQueue.main.async {
                    if let error = error {
                        if let urlError = error as? URLError {
                            switch urlError.code {
                                case .notConnectedToInternet:
                                    promise(.failure(NetworkError.noInternetConnection))
                                case .timedOut:
                                    promise(.failure(NetworkError.timeout))
                                case .badURL:
                                    promise(.failure(NetworkError.invalidURL(nil)))
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
                    
                    guard let httpResponse = response as? HTTPURLResponse,
                    (200..<300).contains(httpResponse.statusCode) else {
                        self.serialize(data: data)
                        promise(.failure(NetworkError.serverError(data)))
                        return
                    }
                    
                    do {
                        let model = try JSONDecoder().decode(T.self, from: data)
                        // MARK: - success
                        promise(.success(model))
                    } catch let error as DecodingError {
                        print(error.localizedDescription, error)
                        promise(.failure(NetworkError.decodingFailed))
                    } catch {
                        print(error.localizedDescription, error)
                        promise(.failure(NetworkError.custom(error: error.localizedDescription)))
                    }
                }
            }
            task.resume()
        }
    }
    /// Serialize
    /// - Parameter data: the data object to be serialized
    private func serialize(data: Data) {
        do {
            let object = try JSONSerialization.jsonObject(with: data)
            print(object)
        } catch {
            print(error.localizedDescription, error)
        }
    }
}
