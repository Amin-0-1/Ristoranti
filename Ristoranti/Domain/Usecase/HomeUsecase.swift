//
//  HomeUsecase.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine
protocol HomeUsecaseProtocol{
    func fetchData()->Future<FoodResponseModel,DomainError>
}

class HomeUsecase:HomeUsecaseProtocol{
    private var repo:RepositoryInterface!
    
    private var cancellabels:Set<AnyCancellable> = []
    init(repo: RepositoryInterface = Repository()) {
        self.repo = repo
    }
    
    func fetchData() -> Future<FoodResponseModel, DomainError> {
        return .init {[weak self] promise in
            guard let self = self else {return}
            repo.fetchFood(endPoint: RistorantiEndPoints.fetchFood).sink { completion in
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
            }.store(in: &self.cancellabels)
        }
    }
}
