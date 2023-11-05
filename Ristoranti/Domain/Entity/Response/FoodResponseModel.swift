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

struct FoodItemProduct: Codable,Hashable {
    static func == (lhs: FoodItemProduct, rhs: FoodItemProduct) -> Bool {
        return lhs.id == rhs.id
    }
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
    func hash(into hasher: inout Hasher) {
        if let id = id {
            hasher.combine(id)
        }
    }
    
    static var fakeModel:FoodItemProduct{
        return .init(id: nil, name: nil, description: nil, calories: nil, price: nil, currency: nil, discount: nil, favourite: nil, hasOffer: nil, offer: nil, rating: nil, image: nil)
    }
}

struct FoodItemOffer: Codable {
    let percentage, priceAfterDiscount : Double?
    let remainingDays: Int?
}

struct FoodItemRating: Codable {
    let rate: Double?
    let count: Int?
}
