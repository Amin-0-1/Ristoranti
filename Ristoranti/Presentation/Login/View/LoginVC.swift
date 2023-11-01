//
//  LoginVC.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

class LoginVC: UIViewController ,RoundedTextfieldDelegate{
    
    @IBOutlet weak var uiScrollView: UIScrollView!
    @IBOutlet private weak var uiMail: RoundedTextfield!
    @IBOutlet private weak var uiPassword: RoundedTextfield!
    @IBOutlet private weak var uiLoginButton: LoaderButton!
    @IBOutlet private weak var uiHaveAccountButton: UIButton!
    var viewModel:LoginViewModelProtocol!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
         
    }
    private func configure(){
        uiLoginButton.layer.shadowColor = UIColor.accent.cgColor
        uiMail.delegate = self
        uiPassword.delegate = self
        configureAttributedString()
    }
    private func configureAttributedString(){
        let font:UIFont = UIFont(name: "SofiaProRegular", size: 14) ?? .systemFont(ofSize: 20)
        let defaultAttr : [NSAttributedString.Key:Any] = [.font:font,.foregroundColor:UIColor.black]
        let specialAttr: [NSAttributedString.Key:Any] = [.font:font,.foregroundColor:UIColor.accent]
        
        
        let first = NSMutableAttributedString(string: "Don’t have an account? ",attributes: defaultAttr)
        let second = NSMutableAttributedString(string: "Sign up",attributes: specialAttr)
        
        first.append(second)
        uiHaveAccountButton.setAttributedTitle(first, for: .normal)
    }
    @IBAction func uiLoginButtonPressed(_ sender: LoaderButton) {
        sender.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            sender.isLoading = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.uiScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        uiScrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        uiScrollView.contentInset = contentInset
    }
    
}
