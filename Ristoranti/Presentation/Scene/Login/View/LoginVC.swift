//
//  LoginVC.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit
import Combine

class LoginVC: UIViewController{
    
    @IBOutlet weak var uiScrollView: UIScrollView!
    @IBOutlet private weak var uiMail: RoundedTextfield!
    @IBOutlet private weak var uiPassword: RoundedTextfield!
    @IBOutlet private weak var uiLoginButton: LoaderButton!
    @IBOutlet private weak var uiHaveAccountButton: UIButton!
    
    
    var viewModel:LoginViewModelProtocol!
    private var cancellables:Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
         
    }
    private func configure(){
        registerKeyboardDismissel()
        uiLoginButton.layer.shadowColor = UIColor.accent.cgColor
        uiLoginButton.layer.shadowPath = UIBezierPath(roundedRect: uiLoginButton.bounds, cornerRadius: uiLoginButton.layer.cornerRadius).cgPath

        uiMail.delegate = self
        uiPassword.delegate = self
        configureAttributedString()
        bind()
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
//        viewModel.publishMail.send("01287864053")
//        viewModel.publishPassword.send("12345678")
        
        sender.isLoading = true
        [uiMail,uiPassword].forEach{$0?.isRequired = false}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1){ [weak self] in
            guard let self = self else {return}
            self.viewModel.publishableSubmit.send()
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
    
    private func bind(){
        viewModel.bindableError.sink {[weak self] message in
            guard let self = self else {return}
            self.showError(message: message)
        }.store(in: &cancellables)
        
        viewModel.bindableMailNotValid.sink {[weak self] _ in
            guard let self = self else {return}
            self.uiMail.isRequired = true
        }.store(in: &cancellables)
        
        viewModel.bindablePasswordNotValid.sink { [weak self] _ in
            guard let self = self else {return}
            self.uiPassword.isRequired = true
        }.store(in: &cancellables)
    }
    
}
extension LoginVC:RoundedTextfieldDelegate{
    func textFieldDidChange(text: String?, textfield: RoundedTextfield) {
        guard let text = text else {return}
        if textfield == uiMail{
            viewModel.publishMail.send(text)
        }else{
            viewModel.publishPassword.send(text)
        }
    }
    func textFieldDidClearText(textfield: RoundedTextfield) {
        if textfield == uiMail{
            viewModel.publishMail.send("")
        }else{
            viewModel.publishPassword.send("")
        }
    }
}
