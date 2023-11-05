//
//  Double.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
extension Double {
    func rounded(toPlaces places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        return (self * multiplier).rounded() / multiplier
    }
}
