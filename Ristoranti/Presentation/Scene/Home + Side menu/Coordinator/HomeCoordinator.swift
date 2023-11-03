//
//  HomeCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit

protocol HomeCoordinatorProtocol:Coordinator{
    func logout()
    func navigateToDetails(id:Int)
}

struct HomeCoordinator:HomeCoordinatorProtocol{
    var navigationController: UINavigationController?
    
    func start() {
        let vc = HomeVC()
        let viewModel = HomeViewModel(coordinator: self)
        vc.viewModel = viewModel
        navigationController?.setViewControllers([vc], animated: false)
    }
    func logout() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    func navigateToDetails(id: Int) {
        let coordinator = DetailsCoordinator(id: id)
        
    }
}
