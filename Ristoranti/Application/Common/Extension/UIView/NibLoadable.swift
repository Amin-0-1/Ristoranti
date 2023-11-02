//
//  NibLoadable.swift
//  Football-Leagues
//
//  Created by Amin on 17/10/2023.
//

import UIKit

protocol NibLoadableView: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}

extension UIView: NibLoadableView{}
