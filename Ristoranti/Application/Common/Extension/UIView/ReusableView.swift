//
//  ReusableView.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

protocol ReusableView: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UIView: ReusableView {}
