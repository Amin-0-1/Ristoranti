//
//  RoundedTextfield.swift
//  Ristoranti
//
//  Created by Amin on 01/11/2023.
//

import UIKit

@IBDesignable
class RoundedTextfield: UIView {
    
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var uiTextfield: UITextField!
    @IBOutlet private weak var uiActionButton: UIButton!
    //    private enum PasswordStates: String {
    //        case hidden = "eye.fill"
    //        case shown = "eye.slash.fill"
    //    }
    
    private enum PasswordStates {
        case hidden
        case shown
    }
    private var currentPasswordState: PasswordStates? {
        willSet {
            guard let value = newValue else {return}
            //            let image = UIImage(systemName: value.rawValue)
            //            self.uiActionButton.setImage(image, for: .normal)
            self.uiTextfield.isSecureTextEntry = value == .hidden
        }
    }
    var delegate: RoundedTextfieldDelegate?
    var text: String? {
        return uiTextfield.text
    }
    var borderColor: UIColor?
    var borderWidth: CGFloat?
    
    var isRequired = false {
        willSet(value) {
            setBoarded(color: value ? .systemRed : borderColor)
            if value {
                self.contentView.layer.borderWidth = 1
                self.uiTextfield.becomeFirstResponder()
            } else {
                self.contentView.layer.borderWidth = borderWidth ?? 0
                self.uiTextfield.resignFirstResponder()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    private func loadView() {
        
        let bundle = Bundle.init(for: RoundedTextfield.self)
        bundle.loadNibNamed(RoundedTextfield.nibName, owner: self)
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.border_width = 0.1
        self.border_color = .gray
        self.addSubview(self.contentView)
        uiTextfield.delegate = self
        uiTextfield.addTarget(self, action: #selector(textfieldDidEndEditing(sender: )), for: .editingDidEnd)
        uiTextfield.addTarget(self, action: #selector(textfieldValueChanged(sender: )), for: .editingChanged)
    }
    
    private func setBoarded(color: UIColor?) {
        self.contentView.layer.borderColor = color?.cgColor
    }
    
    func sendAction(for element: UIControl.Event) {
        uiTextfield.sendActions(for: element)
        
    }
    @IBAction private func uiActionButtonTapped(_ sender: Any) {
        UIView.transition(with: uiTextfield, duration: 0.2, options: .transitionCrossDissolve) {[weak self] in
            guard let self = self else {return}
            if let isPasswordField = currentPasswordState {
                currentPasswordState = isPasswordField == .hidden ? .shown : .hidden
            } else {
                uiTextfield.text = ""
                delegate?.textFieldDidClearText(textfield: self)
            }
        }
    }
    
    @objc func textfieldDidEndEditing(sender: UITextField) {
        delegate?.textFieldDidEndEditing(textfield: self)
        self.endEditing(true)
    }
    @objc private func textfieldValueChanged(sender: UITextField) {
        delegate?.textFieldDidChange(text: sender.text, textfield: self)
    }
    
    @IBInspectable
    var placeholder: String? {
        get {return self.uiTextfield.placeholder}
        set(placeholder) {
            self.uiTextfield.placeholder = placeholder
        }
    }
    
    @IBInspectable
    var background_color: UIColor? {
        get {return self.contentView.backgroundColor}
        set(color) {
            self.contentView.backgroundColor = color
        }
    }
    @IBInspectable
    var border_color: UIColor? {
        get {
            guard let color = self.contentView.layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
        set(color) {
            self.borderColor = color
            self.setBoarded(color: color)
        }
    }
    @IBInspectable
    var border_width: CGFloat {
        get {return self.contentView.layer.borderWidth}
        set(width) {
            self.borderWidth = CGFloat(width)
            self.contentView.layer.borderWidth = width
        }
    }
    @IBInspectable
    var cornerRadius: Float {
        get {return Float(self.contentView.layer.cornerRadius)}
        set {
            self.contentView.layer.cornerRadius = CGFloat(newValue)
        }
    }
    @IBInspectable
    var disableAction: Bool {
        get {return false}
        set(value) {
            if value {
                self.uiActionButton.isHidden = true
            }
        }
    }
    
    @IBInspectable
    var secureTextfield: Bool {
        get {return false}
        set(value) {
            if value {
                self.currentPasswordState = .hidden
                self.uiTextfield.isSecureTextEntry = true
            }
        }
    }
    @IBInspectable
    var secureImage: UIImage? {
        get {
            return uiActionButton.image(for: .normal)
        }
        
        set {
            guard let image = newValue else {return}
            self.uiActionButton.setImage(image, for: .normal)
            self.uiActionButton.setImage(image, for: .selected)
            self.uiActionButton.setImage(image, for: .highlighted)
        }
    }
    
}

extension RoundedTextfield: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        delegate?.textFieldDidBeginEditing(textfield: self)
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        self.endEditing(true)
        switch reason {
            case .committed:
                break
            case .cancelled:
                delegate?.textFieldDidEndEditing(textfield: self)
            @unknown default:
                break
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.textFieldDidEndEditing(textfield: self)
        self.endEditing(true)
        return true
    }
}

protocol RoundedTextfieldDelegate: AnyObject {
    func textFieldDidChange(text: String?, textfield: RoundedTextfield)
    func textFieldDidBeginEditing(textfield: RoundedTextfield)
    func textFieldDidEndEditing(textfield: RoundedTextfield)
    func textFieldDidClearText(textfield: RoundedTextfield)
}

extension RoundedTextfieldDelegate {
    func textFieldDidChange(text: String?, textfield: RoundedTextfield) {}
    func textFieldDidBeginEditing(textfield: RoundedTextfield) {}
    func textFieldDidEndEditing(textfield: RoundedTextfield) {}
    func textFieldDidClearText(textfield: RoundedTextfield) {}
}
