//
//  LoaderButton.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import UIKit

@IBDesignable
class LoaderButton: UIButton {

    var spinner = UIActivityIndicatorView()
    private var latestImage: UIImage?
    private var latestTitle: String?
    
    @IBInspectable
    var isLargeIndicator: Bool {
        get {return spinner.style == .large}
        set {
            spinner.style = newValue ? .large : .medium
        }
    }
    
    @IBInspectable
    var indicatorColor: UIColor {
        get {return spinner.color}
        set {
            spinner.color = newValue
        }
    }
    
    var isLoading = false {
        didSet {
            // whenever `isLoading` state is changed, update the view
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    func setupView() {
        spinner.hidesWhenStopped = true
        addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func updateView() {
        if isLoading {
            spinner.startAnimating()
            self.latestImage = imageView?.image
            self.latestTitle = titleLabel?.text
            setImage(nil, for: .normal)
            setTitle("", for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                self.layer.shadowPath = UIBezierPath(
                    roundedRect: self.bounds,
                    cornerRadius: self.layer.cornerRadius
                ).cgPath
            }
            isEnabled = false
        } else {
            spinner.stopAnimating()
            setImage(latestImage, for: .normal)
            setTitle(latestTitle, for: .normal)
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
                self.layer.shadowPath = UIBezierPath(
                    roundedRect: self.bounds,
                    cornerRadius: self.layer.cornerRadius
                ).cgPath
            }
            isEnabled = true
        }
    }
}
