//
//  NetworkError.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import Foundation

public enum NetworkError: Error, Equatable {
    case noInternetConnection
    case timeout
    case invalidURL(String?)
    case requestFailed
    case encodingFailed
    case invalidResponse
    case decodingFailed
    case serverError(Data)
    case custom(error: String)
    public var localizedDescription: String {
        switch self {
            case .noInternetConnection:
                return "Oops! It seems you're not connected to the internet. " +
                "Please check your internet connection and try again."
            case .timeout:
                return "Sorry, the operation took longer than expected. " +
                "Please check your internet connection and try again. If the issue persists, please contact support."
            case .invalidURL(let url):
                var urlString: String = "Invalid URL provided. Please double-check the URL and try again."
                if let url {
                    urlString = "Invalid URL provided \(url). Please double-check the URL and try again."
                }
                return urlString
            case .requestFailed:
                return "Oops, something went wrong with the network. Please check your connection, " +
                "try again later, or contact support if the issue persists."
            case .encodingFailed:
                return "Unable to encode request data"
            case .invalidResponse:
                return "Empty Response: No Available Data"
            case .decodingFailed:
                return "Oops, an error occured in server data please try again later."
            case .serverError:
                return "Oops, we've encountered a server response error, please try again later"
            case .custom(let error):
                return error
        }
    }
}
