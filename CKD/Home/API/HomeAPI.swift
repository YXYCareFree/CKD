//
//  HomeAPI.swift
//  CKD
//
//  Created by casanube on 2020/11/11.
//  Copyright © 2020 casanube. All rights reserved.
//

import Foundation

public typealias Parameters = [String: Any]

extension TargetType {
    var baseURL: URL {
        return URL(string: "https://registry.casanubeserver.com/mockServer/RestService/Call/")!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return "".data(using: .utf8)!
   }
}

enum HomeAPI {
    
    case homeData
    case newsList(param: Parameters)
    case newsDetail(param: Parameters)
    case newsOperation(param: Parameters)
    case toolList
}

extension HomeAPI: TargetType{
    
    var path: String {
        switch self {
        case .homeData: return "RenalApp/GetHomePage"
        case .newsDetail(_): return "RenalApp/InformationDetailsSearch"
        case .newsList(_): return "RenalApp/GetHomePageInformation"
        case .newsOperation(_): return "RenalApp/InformationOperation"
        case .toolList: return "UniversalConfig.ToolSearch"
        }
    }
    
    var task: Task{
        switch self {
        case .homeData, .toolList:
            return .requestPlain
        case .newsList(let param), .newsDetail(let param), .newsOperation(let param):
            return .requestParameters(parameters: param, encoding: JSONEncoding.default)
        }
    }
}


