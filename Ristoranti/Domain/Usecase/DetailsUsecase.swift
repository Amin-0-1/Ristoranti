//
//  DetailsUsecase.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import Foundation
import Combine

protocol DetailsUsecaseProtocol{
    func fetchDetails(itemID:Int)->Future<DetailsDataModel,DomainError>
}

class DetailsUsecase:DetailsUsecaseProtocol{
    private var repo: RepositoryInterface!
    private var connectivity:ConnectivityProtocol!
    private var cancellables:Set<AnyCancellable> = []
    init(repo: RepositoryInterface = RistorantiRepository(), connectivity: ConnectivityProtocol = ConnectivityService()) {
        self.repo = repo
        self.connectivity = connectivity
    }
    func fetchDetails(itemID:Int) -> Future<DetailsDataModel, DomainError> {
        return .init { [weak self] promise in
            guard let self = self else {return}
            connectivity.isConnected { connected in
                if connected{
                    self.repo.fetchFoodItem(endPoint: RistorantiEndPoints.details(itemID)).sink { completion in
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
                        promise(.success(data))
                    }.store(in: &self.cancellables)
                    
                }else{
                    promise(.failure(.connectionError))
                }
            }
        }
    }
}
