//
//  LoingViewModel.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import Foundation
import Combine
protocol LoginViewModelProtocol {
    var publishMail: CurrentValueSubject<String, Never> {get}
    var publishPassword: CurrentValueSubject<String, Never> {get}
    var publishableSubmit: PassthroughSubject<Void, Never> {get}
    
    var bindableError: AnyPublisher<String, Never> {get}
    var bindableMailNotValid: AnyPublisher<Void, Never> {get}
    var bindablePasswordNotValid: AnyPublisher<Void, Never> {get}
}

class LoginViewModel: LoginViewModelProtocol {
    
    var publishMail: CurrentValueSubject<String, Never> = .init("")
    var publishPassword: CurrentValueSubject<String, Never> = .init("")
    var publishableSubmit: PassthroughSubject<Void, Never> = .init()
    
    var bindableError: AnyPublisher<String, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    var bindableMailNotValid: AnyPublisher<Void, Never> {
        return mailNotValidSubject.eraseToAnyPublisher()
    }
    var bindablePasswordNotValid: AnyPublisher<Void, Never> {
        return passwordNotValidSubject.eraseToAnyPublisher()
    }
    
    private var errorSubject: PassthroughSubject<String, Never> = .init()
    private var mailNotValidSubject: PassthroughSubject<Void, Never> = .init()
    private var passwordNotValidSubject: PassthroughSubject<Void, Never> = .init()
    
    var coordinator: LoginCoordinatorProtocol?
    var usecase: LoginUsecaseProtocol
    private var cancellables: Set<AnyCancellable> = []
    
    init(coordinator: LoginCoordinatorProtocol? = nil, usecase: LoginUsecaseProtocol = LoginUsecase()) {
        self.coordinator = coordinator
        self.usecase = usecase
        bind()
    }
    private func bind() {
        Publishers.CombineLatest(publishMail, publishPassword).sink { mail, password in
            print(mail, password)
        }.store(in: &cancellables)
        
        publishableSubmit.sink { [weak self] _ in
            guard let self = self else {return}
            let mail = publishMail.value
            let password = publishPassword.value
            guard !mail.isEmpty else {
                mailNotValidSubject.send()
                return
            }
            guard !password.isEmpty else {
                passwordNotValidSubject.send()
                return
            }
            usecase.login(params: .init(phone: mail, password: password)).sink {[weak self] completion in
                guard let self = self else {return}
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        print(error.localizedDescription)
                        errorSubject.send(error.localizedDescription)
                }
            } receiveValue: { _ in
                self.coordinator?.navigateToHome()
            }.store(in: &cancellables)

        }.store(in: &cancellables)
    }
    
}
