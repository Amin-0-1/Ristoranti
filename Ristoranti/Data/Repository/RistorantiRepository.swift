//
//  Repository.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine

class RistorantiRepository:RepositoryInterface{
    
    let apiClient:APIClientProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func login(endPoint: EndPoint) -> Future<LoginResponseModel, DomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            self.apiClient.execute(request: endPoint).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        if let error = error as? NetworkError{
                            let custom = DomainError.customError(error.localizedDescription)
                            promise(.failure(custom))
                        }
                        promise(.failure(.customError(error.localizedDescription)))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    func fetchFood(endPoint: EndPoint) -> Future<FoodResponseModel, DomainError> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            self.apiClient.execute(request: endPoint).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        if let error = error as? NetworkError{
                            let custom = DomainError.customError(error.localizedDescription)
                            promise(.failure(custom))
                        }
                        promise(.failure(.customError(error.localizedDescription)))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &self.cancellables)
        }
    }
    
    func fetchFoodItem(endPoint: EndPoint) -> Future<DetailsResponseModel, DomainError> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            self.apiClient.execute(request: endPoint).sink { completion in
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        if let error = error as? NetworkError{
                            let custom = DomainError.customError(error.localizedDescription)
                            promise(.failure(custom))
                        }
                        promise(.failure(.customError(error.localizedDescription)))
                }
            } receiveValue: { model in
                promise(.success(model))
            }.store(in: &cancellables)
        }
    }
    
}
