//
//  Repository.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine

class Repository:RepositoryInterface{
    
    let apiClient:APIClientProtocol!
    let connectivity:ConnectivityProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(apiClient: APIClientProtocol = APIClient.shared,connectivity:ConnectivityProtocol = ConnectivityService()) {
        self.apiClient = apiClient
        self.connectivity = connectivity
    }
    
    func login(endPoint: EndPoint) -> Future<LoginResponseModel, DomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            connectivity.isConnected { connected in
                if connected{
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
                }else{
                    promise(.failure(.connectionError))
                }
            }
        }
    }
}
