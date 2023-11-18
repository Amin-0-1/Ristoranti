//
//  HomeCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit

protocol HomeCoordinatorProtocol: Coordinator {
    func logout()
    func navigateToDetails(id: Int)
}

struct HomeCoordinator: HomeCoordinatorProtocol {
    var navigationController: UINavigationController?
    
    func start() {
        let viewModel = HomeViewModel(coordinator: self)
        let vc = HomeVC(viewModel: viewModel)
        vc.viewModel = viewModel
        navigationController?.setViewControllers([vc], animated: false)
    }
    func logout() {
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start()
    }
    func navigateToDetails(id: Int) {
        let coordinator = DetailsCoordinator(navigationController: navigationController, id: id)
        coordinator.start()
    }
}
