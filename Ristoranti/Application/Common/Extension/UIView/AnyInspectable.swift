//
//  AnyInspectable.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import UIKit

extension UIView {
    
    private var shadowPath: ShadowBezier {
        return ShadowBezier.shared
    }
    // MARK: - Corner Radius
    @IBInspectable
    var _CornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var _FullRounded: Bool {
        get {
            return layer.cornerRadius == frame.height / 2
        }
        set {
            if newValue {
                layer.cornerRadius = frame.height / 2
            }
        }
    }
    
    // MARK: - Border
    @IBInspectable
    var _BorderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var _BorderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
    
    @IBInspectable
    var _MasksToBounds: Bool {
        get {return layer.masksToBounds}
        set {
            layer.masksToBounds = newValue
        }
    }
    
    // MARK: - Shadow
    @IBInspectable
    var _ShadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            updateShadowPath()
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var _ShadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            updateShadowPath()
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var _ShadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            updateShadowPath()
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var _ShadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            updateShadowPath()
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    private func updateShadowPath() {
//        shadowPath.configure(rect: bounds, cornerRadius: layer.cornerRadius )
//        layer.shadowPath = shadowPath.getPath()
    }
}

class ShadowBezier {
    static let shared = ShadowBezier()
    private var path: UIBezierPath
    
    private init() {
        path = UIBezierPath()
    }
    
    func configure(rect: CGRect, cornerRadius: CGFloat? = nil) {
        if let cornerRadius {
            path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            return
        }
        path = UIBezierPath(rect: rect)
    }
    func getPath() -> CGPath {
        return path.cgPath
    }
}
