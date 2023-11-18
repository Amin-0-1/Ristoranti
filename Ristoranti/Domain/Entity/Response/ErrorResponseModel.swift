//
//  ErrorResponseModel.swift
//  Ristoranti
//
//  Created by Amin on 05/11/2023.
//

import Foundation

struct ErrorResponseModel: Codable {
    let result: Bool?
    let message: String?
    let status: Int?
}
