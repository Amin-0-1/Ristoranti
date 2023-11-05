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
    var onTapCell: PassthroughSubject<Int,Never>{get}
    var onChangedSegment:PassthroughSubject<Int,Never>{get}
    var onSearching:PassthroughSubject<String?,Never> {get}
    
    var profileData:CurrentValueSubject<UserResponseModel?,Never>{get}
    var modelData:CurrentValueSubject<[FoodItemProduct],Never>{get}
    var onLogout:PassthroughSubject<Void,Never> {get}
    var showError:AnyPublisher<String,Never>{get}
    var showProgress:AnyPublisher<Bool,Never>{get}
    var selectSegment:Int {get}
    var searchText:String {get}
    
}
class HomeViewModel:HomeViewModelProtocol{
    
    var onScreenAppeared: PassthroughSubject<Bool, Never> = .init()
    var onTapCell: PassthroughSubject<Int, Never> = .init()
    var onChangedSegment: PassthroughSubject<Int, Never> = .init()
    var onSearching: PassthroughSubject<String?, Never> = .init()
    
    var modelData: CurrentValueSubject<[FoodItemProduct], Never> = .init([])
    var onLogout: PassthroughSubject<Void, Never> = .init()
    var profileData: CurrentValueSubject<UserResponseModel?, Never> = .init(nil)
    
    var showError: AnyPublisher<String, Never>{
        return showErrorSubject.eraseToAnyPublisher()
    }
    var showProgress: AnyPublisher<Bool, Never>{
        return showProgressSubject.eraseToAnyPublisher()
    }
    
    @Published var selectSegment: Int = 0
    @Published var searchText: String = ""
    
    
    private var showErrorSubject:PassthroughSubject<String,Never> = .init()
    private var showProgressSubject:PassthroughSubject<Bool,Never> = .init()
    
    private var currentState:[FoodItemProduct] = []
    
    private var usecase:HomeUsecaseProtocol!
    private var coordinator:HomeCoordinatorProtocol!
    private var cancellabels:Set<AnyCancellable> = []
    
    init(usecase: HomeUsecaseProtocol = HomeUsecase(),coordinator:HomeCoordinatorProtocol) {
        self.usecase = usecase
        self.coordinator = coordinator
        bind()
    }
    private func bind(){
        bindOnScreenAppeared()
        bindLogout()
        bindOnTapCell()
        bindOnChangedSegment()
        bindOnSearching()
    }
    
    private func bindOnScreenAppeared(){
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
                
                let model = [FoodItemProduct.fakeModel] + products
                self.currentState = model
                self.modelData.send(model)
            }.store(in: &self.cancellabels)
            
            
        }.store(in: &self.cancellabels)
    }
    private func bindLogout(){
        onLogout.sink {[weak self] _ in
            guard let self = self else {return}
            UserdefaultManager.shared.truncate()
            self.coordinator.logout()
        }.store(in: &cancellabels)
    }
    
    private func bindOnTapCell(){
        onTapCell.sink {[weak self] index in
            guard let self = self else {return}
            guard let id = modelData.value[index].id else {
                showErrorSubject.send("an error occurred, please try again later.")
                return
            }
            self.coordinator.navigateToDetails(id: id)
        }.store(in: &cancellabels)
    }
    private func bindOnChangedSegment(){
        onChangedSegment.sink { [weak self] segment in
            guard let self = self else {return}
            let origin = modelData.value.dropFirst()
            let shuffled = origin.shuffled()
            let data = [FoodItemProduct.fakeModel] + shuffled
            selectSegment = segment
            self.modelData.send(data)
        }.store(in: &cancellabels)
    }
    
    
    private func bindOnSearching(){
//        throttle(for: 1.5, scheduler: DispatchWorkloop.main, latest: true)
        onSearching.debounce(for: 1.5, scheduler: DispatchWorkloop.main, options: .init(qos: .userInteractive)).sink {[weak self] query in
            guard let self = self else {return}
            guard let query = query,!query.isEmpty else {
                searchText = ""
                self.modelData.send(self.currentState)
                return
            }
            self.search(query: query)
        }.store(in: &cancellabels)
    }
    
    private func prepareProfileData(){
        guard let data:UserResponseModel = UserdefaultManager.shared.getObject(forKey: .userData) else {return}
        profileData.send(data)
    }
    
    private func search(query:String){
        self.searchText = query
        let data = currentState
        var searchList:[FoodItemProduct] = []
        data.forEach {item in
            if let contains = item.description?.contains(query), contains{
                searchList.append(item)
            }
        }
        let result = [FoodItemProduct.fakeModel] + searchList
        self.modelData.send(result)
    }
}
