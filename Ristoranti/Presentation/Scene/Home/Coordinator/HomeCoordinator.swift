//
//  HomeCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import UIKit

protocol HomeCoordinatorProtocol:Coordinator{
    
}

struct HomeCoordinator:HomeCoordinatorProtocol{
    var navigationController: UINavigationController?
    
    func start() {
        let vc = HomeVC()
        let viewModel = HomeViewModel(coordinator: self)
        vc.viewModel = viewModel
        navigationController?.setViewControllers([vc], animated: false)
    }
}
