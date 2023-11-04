//
//  FoodResponseModel.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation

struct FoodResponseModel: Codable {
    let result: Bool?
    let message: String?
    let status: Int?
    let data: FoodDataModel?
}

struct FoodDataModel: Codable {
    let pages: Int?
    let products: [FoodItemProduct]?
}

struct FoodItemProduct: Codable {
    let id: Int?
    let name, description: String?
    let calories: Int?
    let price: Double?
    let currency: String?
    let discount, favourite: Int?
    let hasOffer: Bool?
    let offer: FoodItemOffer?
    let rating: FoodItemRating?
    let image: String?
}

struct FoodItemOffer: Codable {
    let percentage, priceAfterDiscount : Double?
    let remainingDays: Int?
}

struct FoodItemRating: Codable {
    let rate: Double?
    let count: Int?
}
