//
//  DetailsViewModelParams.swift
//  Ristoranti
//
//  Created by Amin on 03/11/2023.
//

import Foundation

struct DetailsViewModelParams{
    let coordinator: DetailsCoordinatorProtocol
    let usecase: DetailsUsecaseProtocol = DetailsUsecase()
    let itemID:Int
}
