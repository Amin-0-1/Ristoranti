//
//  AnyViewController.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import UIKit

extension UIViewController {
    
    private var indicator: UIActivityIndicatorView {
        let indicator = ActivityIndicator.shared.set().build()
        DispatchQueue.main.async {
            self.view.addSubview(indicator)
            indicator.center = self.view.center
        }
        return indicator
    }
    
    /// show native activity indicator Progress and block the user interaction if enabled
    /// - Parameter disableInteractions: disableing user interaction while showing progress, default = true
    func showProgress(disableInteractions: Bool = true) {
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = false
            self.view.isUserInteractionEnabled = !disableInteractions
        }
    }
    
    /// hide the activity indicator and enable user interation
    func hideProgress() {
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    /// present native alert controller with specified message
    /// - Parameters:
    ///   - title: alert controller top title message, default = nil
    ///   - message: alert message to show in the alert
    ///   - completion: completion block of code to be executed after dismissing the alert
    func showError(
        title: String? = nil,
        message: String,
        completion: @escaping() -> Void = {}
    ) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                completion()
            }
            controller.addAction(okAction)
            self.present(controller, animated: true)
        }
    }
    
    /// add keyboard dissmissel tap gesture, so that whenever the user taps on any empy area on the screen the keyboard will be hidden
    func registerKeyboardDismissel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
// MARK: - ActivityIndicator
class ActivityIndicator {
    static let shared = ActivityIndicator()
    private let indicator: UIActivityIndicatorView
    private init() {
        indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
    }
    func set(color: UIColor = .green, style: UIActivityIndicatorView.Style = .large) -> ActivityIndicator {
        indicator.color = color
        indicator.style = style
        return self
    }
    func build() -> UIActivityIndicatorView {
        return self.indicator
    }
}
