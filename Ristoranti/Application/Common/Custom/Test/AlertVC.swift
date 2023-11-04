//
//  AlertVC.swift
//  Ristoranti
//
//  Created by Amin on 04/11/2023.
//

import UIKit

class AlertVC: UIViewController {

    @IBOutlet private weak var uiAlertTitle: UILabel!
    @IBOutlet private weak var uiAlertDescription: UILabel!
    var alertTitle:String?
    var alertDescription:String?
    var successCompletion:()->Void = { }
    var failureCompletion:()->Void = { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiAlertTitle.isHidden = true
        uiAlertDescription.isHidden = true
        
        if let title = alertTitle{
            uiAlertTitle.isHidden = false
            uiAlertTitle.text = title
        }
        
        if let desc = alertDescription{
            uiAlertDescription.isHidden = false
            uiAlertDescription.text = desc
        }
    }
    
    @IBAction func uiCancel(_ sender: UIButton) {
        failureCompletion()
        dismiss(animated: true)
    }
    
    @IBAction func uiOkay(_ sender: UIButton) {
        successCompletion()
        dismiss(animated: true)
    }
    
}
