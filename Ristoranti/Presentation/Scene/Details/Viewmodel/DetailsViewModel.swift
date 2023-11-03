//
//  DetailsViewModel.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import Foundation

protocol DetailsViewModelProtocol{
    
}

class DetailsViewModel:DetailsViewModelProtocol{
    
    private var coordinator:DetailsCoordinatorProtocol!
    private var usecase:DetailsUsecaseProtocol!
    private var itemID:Int!
    init(params:DetailsViewModelParams) {
        self.coordinator = params.coordinator
        self.usecase = params.usecase
        self.itemID = params.itemID
    }
}
