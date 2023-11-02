//
//  LoginCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

protocol LoginCoordinatorProtocol:Coordinator{
    func navigateToHome()
}
struct LoginCoordinator:LoginCoordinatorProtocol{
    var navigationController: UINavigationController?
    
    func start() {
        let vc = LoginVC()
        let viewModel = LoginViewModel(coordinator: self)
        vc.viewModel = viewModel
        navigationController?.setViewControllers([vc], animated: true)
    }
    func navigateToHome() {
        
    }
}
