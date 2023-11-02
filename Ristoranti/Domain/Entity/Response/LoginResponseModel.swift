//
//  LoginResponseModel.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation

struct LoginResponseModel: Codable {
    let result: Bool?
    let message: String?
    let status: Int?
    let data: DataResponseModel?
}

struct DataResponseModel: Codable {
    let user: UserResponseModel?
}

struct UserResponseModel: Codable {
    let id: Int?
    let name, phone, countryCode, newPhone: String?
    let newCountryCode, currency: String?
    let image: String?
    let language: String?
    let isVerified: Int?
    let address: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, phone
        case countryCode = "country_code"
        case newPhone, newCountryCode, currency, image, language
        case isVerified = "is_verified"
        case address
    }
}
