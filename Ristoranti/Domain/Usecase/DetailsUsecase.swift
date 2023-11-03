//
//  DetailsUsecase.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import Foundation
protocol DetailsUsecaseProtocol{
    
}

struct DetailsUsecase:DetailsUsecaseProtocol{
    private var repo: RepositoryInterface!
    private var connectivity:ConnectivityProtocol!
    
    init(repo: RepositoryInterface = RistorantiRepository(), connectivity: ConnectivityProtocol = ConnectivityService()) {
        self.repo = repo
        self.connectivity = connectivity
    }
}
