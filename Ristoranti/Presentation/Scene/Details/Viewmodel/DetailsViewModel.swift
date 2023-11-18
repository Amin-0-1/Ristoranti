//
//  DetailsViewModel.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import Foundation
import Combine
protocol DetailsViewModelProtocol {
    var onScreenAppeared: PassthroughSubject<Bool, Never> {get}
    var onBackPressed: PassthroughSubject<Void, Never> {get}
    var dataModel: CurrentValueSubject<ProductDataModel?, Never> {get}
    
    var showError: AnyPublisher<String, Never> {get}
    var showProgress: AnyPublisher<Bool, Never> {get}
}

class DetailsViewModel: DetailsViewModelProtocol {
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var onBackPressed: PassthroughSubject<Void, Never> = .init()
    
    var dataModel: CurrentValueSubject<ProductDataModel?, Never> = .init(nil)
    var showError: AnyPublisher<String, Never> {
        return showErrorSubject.eraseToAnyPublisher()
    }
    
    var showProgress: AnyPublisher<Bool, Never> {
        return showProgressSubject.eraseToAnyPublisher()
    }
    private var showErrorSubject: PassthroughSubject<String, Never> = .init()
    private var showProgressSubject: PassthroughSubject<Bool, Never> = .init()
    
    private var coordinator: DetailsCoordinatorProtocol
    private var usecase: DetailsUsecaseProtocol
    private var cancellabels: Set<AnyCancellable> = []
    private var itemID: Int
    
    init(params: DetailsViewModelParams) {
        self.coordinator = params.coordinator
        self.usecase = params.usecase
        self.itemID = params.itemID
        bind()
    }
    private func bind() {
        onBackPressed.sink {[weak self] _ in
            guard let self = self else {return}
            self.coordinator.popVC()
        }.store(in: &cancellabels)
        
        onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            if !isPullToRefresh {
                showProgressSubject.send(true)
            }
            self.usecase.fetchDetails(itemID: itemID).sink { completion in
                self.showProgressSubject.send(false)
                switch completion {
                    case .finished: break
                    case .failure(let error):
                        self.showErrorSubject.send(error.localizedDescription)
                }
            } receiveValue: { model in
                self.dataModel.send(model.product)
            }.store(in: &cancellabels)

        }.store(in: &cancellabels)
    }
}
