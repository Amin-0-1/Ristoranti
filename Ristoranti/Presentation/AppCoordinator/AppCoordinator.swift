//
//  AppCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController? { get }
    func start()
}

struct AppCoordinator: Coordinator {
    var navigationController: UINavigationController?
    
    func start() {
        var coordinator: Coordinator
        let model: UserResponseModel? = UserdefaultManager.shared.getObject(forKey: .userData)
        if UserdefaultManager.shared.getValue(forKey: .onboarding) as? Bool != nil {
            if model != nil {
                coordinator = HomeCoordinator(navigationController: navigationController)
            } else {
                coordinator = LoginCoordinator(navigationController: navigationController)
            }
        } else {
            coordinator = OnboardingCoordinator(navigationController: navigationController)
        }
        coordinator.start()
    }
}
