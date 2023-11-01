//
//  OnboardingCoordinator.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import UIKit

protocol OnboardingCoordinatorProtocol:Coordinator{
    func onFinishedOnboarding()
}
struct OnboardingCoordinator:OnboardingCoordinatorProtocol{
    var navigationController: UINavigationController?
    
    func start() {
        let vc = OnboardingVC()
        vc.coordinator = self
        navigationController?.pushViewController(vc, animated: true)
    }
    func onFinishedOnboarding() {
        UserdefaultManager.shared.set(value: true, forKey: .onboarding)
        let coordinator = LoginCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
