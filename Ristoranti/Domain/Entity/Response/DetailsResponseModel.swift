//
//  DetailsResponseModel.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import Foundation

struct DetailsResponseModel: Codable {
    let result: Bool?
    let message: String?
    let status: Int?
    let data: DetailsDataModel?
}

struct DetailsDataModel: Codable {
    let product: ProductDataModel?
}

struct DrinkDataModel: Codable {
    let id: Int?
    let name: String?
    let image: String?
    let price: Double?
    
}

struct ProductDataModel: Codable {
    let id: Int?
    let name, description: String?
    let image: String?
    let images: [String]?
    let price: Double?
    let discount: Int?
    let currency: String?
    let addons: [DrinkDataModel]?
    let offer: FoodItemOffer?
    let rating: FoodItemRating?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, image, images, price, discount, currency
        case addons
        case offer, rating
    }
}

struct NutrientDataModel: Codable {
    let id: Int?
    let name, unitOfMeasurement, value: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case unitOfMeasurement = "unit_of_measurement"
        case value
    }
}
