//
//  RepositoryInterface.swift
//  Ristoranti
//
//  Created by Amin on 02/11/2023.
//

import Foundation
import Combine
protocol RepositoryInterface{
    func login(endPoint:EndPoint)->Future<LoginResponseModel,DomainError>
}
