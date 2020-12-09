//
//  FindAPI.swift
//  CKD
//
//  Created by casanube on 2020/12/9.
//  Copyright © 2020 casanube. All rights reserved.
//

import Foundation

enum FindAPI {
    case foodType
    case foodListByType(param: Parameters)
    case news(param: Parameters)
}

extension FindAPI: TargetType{
    
    var path: String{
        switch self {
            case .foodType: return "RenalApp/SearchFoodTypeList"
            case .foodListByType(_): return "RenalApp/FoodListSearch"
            case .news(_): return "RenalApp.KidneyDiseaseBaike"
        }
    }
    
    var task: Task{
        switch self {
        case .foodType:
            return .requestPlain
        case .foodListByType(let param), .news(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
}
