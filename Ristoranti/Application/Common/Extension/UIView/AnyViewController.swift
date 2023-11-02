//
//  AnyViewController.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import UIKit
protocol test:UIViewController{
    
}
extension UIViewController{
    var indicator:UIActivityIndicatorView{
        let indicator = ActivityIndicator.shared.set(color: .systemGreen).build()
        DispatchQueue.main.async {
            self.view.addSubview(indicator)
            indicator.center = self.view.center
        }
        return indicator
    }
    
    func showProgress(){
        DispatchQueue.main.async {
            self.indicator.startAnimating()
            self.indicator.isHidden = false
            self.view.isUserInteractionEnabled = false
        }
    }
    
    func hideProgress(){
        DispatchQueue.main.async {
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.view.isUserInteractionEnabled = true
        }
    }
    
    func showError(message:String,completion:@escaping()->Void = {}){
        DispatchQueue.main.async {
            let controller = UIAlertController(title: "Opps!!", message: message , preferredStyle: .alert)
            controller.addAction(.init(title: "OK", style: .default,handler: { _ in
                completion()
            }))
            self.present(controller, animated: true)
        }
    }
    func setupKeyboardDismissal() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}


class ActivityIndicator{
    static let shared = ActivityIndicator()
    private let indicator: UIActivityIndicatorView!
    private init(){
        indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
    }
    func set(color:UIColor = .cyan,style:UIActivityIndicatorView.Style = .large)->ActivityIndicator{
        indicator.color = color
        indicator.style = style
        return self
    }
    func build()->UIActivityIndicatorView{
        return self.indicator
    }
}
