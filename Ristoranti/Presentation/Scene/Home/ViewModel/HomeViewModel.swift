//
//  HomeViewModel.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine

protocol HomeViewModelProtocol{
    var onScreenAppeared:PassthroughSubject<Bool,Never>{get}
    var showError:AnyPublisher<String,Never>{get}
    var showProgress:AnyPublisher<Bool,Never>{get}
    var modelData:CurrentValueSubject<[FoodItemProduct],Never>{get}
}
class HomeViewModel:HomeViewModelProtocol{
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var modelData: CurrentValueSubject<[FoodItemProduct], Never> = .init([])
    
    var showError: AnyPublisher<String, Never>{
        return showErrorSubject.eraseToAnyPublisher()
    }
    var showProgress: AnyPublisher<Bool, Never>{
        return showProgressSubject.eraseToAnyPublisher()
    }
    
    
    private var showErrorSubject:PassthroughSubject<String,Never> = .init()
    private var showProgressSubject:PassthroughSubject<Bool,Never> = .init()
    
    private var usecase:HomeUsecaseProtocol!
    private var coordinator:HomeCoordinatorProtocol!
    private var cancellabels:Set<AnyCancellable> = []
    init(usecase: HomeUsecaseProtocol = HomeUsecase(),coordinator:HomeCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        bind()
    }
    private func bind(){
        onScreenAppeared.sink {[weak self] isPullToRefresh in
            guard let self = self else {return}
            self.prepareProfileData()
            if !isPullToRefresh{
                self.showProgressSubject.send(true)
            }
            usecase.fetchData().sink { completion in
                self.showProgressSubject.send(false)
                switch completion{
                    case .finished: break
                    case .failure(let error):
                        print(error)
                        self.showErrorSubject.send(error.localizedDescription)
                }
            } receiveValue: { model in
                guard let products = model.data?.products else {
                    self.showErrorSubject.send("There is no data found, please tray agina later.")
                    return
                }
                self.modelData.send(products)
            }.store(in: &self.cancellabels)

        }.store(in: &self.cancellabels)
    }
    
    private func prepareProfileData(){
//        let data:LoginResponseModel = UserdefaultManager.shared.getObject(forKey: .userData)
        
    }
}
