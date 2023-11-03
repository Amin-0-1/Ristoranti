//
//  DetailsCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import UIKit

protocol DetailsCoordinatorProtocol:Coordinator{
    
}

struct DetailsCoordinator:DetailsCoordinatorProtocol{
    var navigationController: UINavigationController?
    private var id:Int!
    init(navigationController: UINavigationController? = nil,id:Int) {
        self.navigationController = navigationController
        self.id = id
    }
    func start() {
        let vc = DetailsVC()
        let viewModel = DetailsViewModel(params: .init(coordinator: self, itemID: id))
        vc.viewModel = viewModel
        navigationController?.pushViewController(vc, animated: true)
    }
}
