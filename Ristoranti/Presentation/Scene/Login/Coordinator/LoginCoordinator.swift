//
//  LoginCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

protocol LoginCoordinatorProtocol: Coordinator {
    func navigateToHome()
}
struct LoginCoordinator: LoginCoordinatorProtocol {
    var navigationController: UINavigationController?
    
    func start() {
        
        let viewModel = LoginViewModel(coordinator: self)
        let vc = LoginVC(viewModel: viewModel)
        vc.viewModel = viewModel
        navigationController?.setViewControllers([vc], animated: true)
        navigationController?.navigationBar.isHidden = true
    }
    func navigateToHome() {
        let coordinator = HomeCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
