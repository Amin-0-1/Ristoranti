//
//  UIColor.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit
extension UIColor {
    static func random() -> UIColor {
        let red = CGFloat.random(in: 0.0...1.0)
        let green = CGFloat.random(in: 0.0...1.0)
        let blue = CGFloat.random(in: 0.0...1.0)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
