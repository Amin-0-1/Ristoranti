//
//  OnboardingViewDataModel.swift
//  Ristoranti
//
//  Created by Amin on 31/10/2023.
//

import Foundation

enum OnboardingViewDataModel:Int,CustomStringConvertible{
    case first = 0
    case second
    case third
    
    var description: String{
        switch self {
            case .first:
                return "Browse your  menu and order directly"
            case .second:
                return "Even to space with us! Together"
            case .third:
                return "Pickup delivery at your door"
        }
    }
    var coverImage:String{
        switch self {
            case .first:
                return "onboarding1"
            case .second:
                return "onboarding2"
            case .third:
                return "onboarding3"
        }
    }
    var stepImgage:String{
        switch self {
            case .first:
                return "1st"
            case .second:
                return "2nd"
            case .third:
                return "3rd"
        }
    }
}
