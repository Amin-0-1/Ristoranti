//
//  LoginUsecase.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine

protocol LoginUsecaseProtocol{
    func login(params:LoginParamRequest)->Future<LoginResponseModel,DomainError>
}

class LoginUsecase:LoginUsecaseProtocol{
    private var repo:RepositoryInterface!
    private var cancellables:Set<AnyCancellable> = []
    init(repo:RepositoryInterface = Repository()) {
        self.repo = repo
    }
    func login(params:LoginParamRequest) -> Future<LoginResponseModel,DomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            let request = RistorantiEndPoints.login(params)
            repo.login(endPoint: request).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        promise(.failure(error))
                }
            } receiveValue: { model in
                guard let data = model.data else {
                    let message = model.message ?? "An Error Occured"
                    let error = NSError(domain: message , code: 400)
                    promise(.failure(.customError(error.localizedDescription)))
                    return
                }
                promise(.success(model))
                if let user = data.user{
                    self.cacheLoggedIn(user: user)
                }
            }.store(in: &cancellables)
        }
    }
    
    private func cacheLoggedIn(user:UserResponseModel){
        UserdefaultManager.shared.set(object: user, forKey: .userData)
    }
}
