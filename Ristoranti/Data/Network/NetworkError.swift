//
//  NetworkError.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import Foundation
public enum NetworkError: Error,Equatable{
    
    case noInternetConnection
    case timeout
    case invalidURL
    case requestFailed
    case encodingFailed
    case invalidResponse
    case decodingFailed
    case serverError(Data)
    
    public var localizedDescription: String {
        switch self {
            case .noInternetConnection:
                return "Oops! It seems you're not connected to the internet. Please check your internet connection and try again."
            case .timeout:
                return "Sorry, the operation took longer than expected. Please check your internet connection and try again. If the issue persists, please contact support."
            case .invalidURL:
                return "Invalid URL provided. Please double-check the URL and try again."
            case .requestFailed:
                return "Oops, something went wrong with the network. Please check your connection, try again later, or contact support if the issue persists.";
            case .encodingFailed:
                return "Unable to encode request data"
            case .invalidResponse:
                return "Empty Response: No Available Data"
            case .decodingFailed:
                return "an error occured in the server please try again later."
            case .serverError:
                return "Oops, server error encountered while loading data"
        }
    } 
}
