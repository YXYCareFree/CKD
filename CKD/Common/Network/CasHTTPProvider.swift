//
//  CasProvider.swift
//  CKD
//
//  Created by casanube on 2020/11/11.
//  Copyright © 2020 casanube. All rights reserved.
//

import Foundation
import RxSwift

@_exported import HandyJSON
@_exported import Moya
@_exported import PKHUD

//typealias CasHTTPSUC = type expression

class CasHTTPProvider<T: TargetType> {
    
    static func request<M: HandyJSON>(api: T, model: M.Type, suc: ((_ suc: M?) -> Void)? = nil, fail: ((_ res: Any) -> Void)? = nil){

        let provider = MoyaProvider<T>(plugins: [CasHTTPProviderPlugin()])
        let _ =
        provider.rx.request(api).asObservable().mapModel(model).subscribe(onNext: { (res) in
            
            if suc != nil {
                suc!(res)
            }
        }, onError: { (err) in

        }, onCompleted: {

        }) {

        }
    }
    
    static func request<M: HandyJSON>(api: T, modelList: M.Type, suc: ((_ suc: [M?]?) -> Void)? = nil, fail: ((_ res: Any) -> Void)? = nil){

        let provider = MoyaProvider<T>(plugins: [CasHTTPProviderPlugin()])
        let _ =
        provider.rx.request(api).asObservable().mapModelList(modelList).subscribe(onNext: { (res) in
            if suc != nil {
                suc!(res)
            }
        }, onError: { (err) in

        }, onCompleted: {

        }) {

        }
    }
    
    static func request(api: T, suc: ((_ suc: Any) -> Void)? = nil, fail: ((_ res: Any) -> Void)? = nil){

        let provider = MoyaProvider<T>(plugins: [CasHTTPProviderPlugin()])
        let _ =
        provider.rx.request(api).asObservable().subscribe(onNext: { (res) in
            if suc != nil {
                let obj = try? JSONSerialization.jsonObject(with: res.data, options: .allowFragments) as? NSDictionary
                if let data = res.handleResponse(dict: obj) {
                    if let dataType = data["dataType"] as? String {
                        if dataType == "data" {
                            suc!(data["data"] as Any)
                        }
                    }
                }
            }
        }, onError: { (err) in

        }, onCompleted: {

        }) {

        }
    }
}

class CasHTTPProviderPlugin: PluginType {
    
    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {

        DispatchQueue.main.async {
            HUD.show(.labeledProgress(title: "", subtitle: "正在加载中..."))
        }
        var param: [String: Any] = [:]
        if request.httpBody == nil {
            param["deviceId"] = "124"
        }else{
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: request.httpBody ?? Data(), options: .allowFragments)
                if let json = jsonObject as? [String: Any] {
                    param = json
                    param["deviceId"] = "123"
                }
            } catch let e {
                print(e)
            }
        }
        var resq = request
        resq.httpBody = try! JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
        return resq;
    }
    
    func willSend(_ request: RequestType, target: TargetType) {
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
        DispatchQueue.main.async {
            HUD.flash(.success)
            HUD.hide()
        }
    }
    
    
}


extension ObservableType where Element == Response{
    public func mapModel<M: HandyJSON>(_ type: M.Type) -> Observable<M?> {
        return flatMap({ (response) -> Observable<M?> in
            return Observable.just(response.mapModel(M.self))
        })
    }
    
    public func mapModelList<M: HandyJSON>(_ type: M.Type) -> Observable<[M?]?>{
        return flatMap { (res) -> Observable<[M?]?> in
            return Observable.just(res.mapModelList(M.self))
        }
    }
}

extension Response{
    func mapModel<T: HandyJSON>(_ type: T.Type) -> T? {
//        throw "error"
        // 没有数据返回
        if data.count < 1 {
            return nil
        }
        // 获取请求response的data转成json
        let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
        if let data = handleResponse(dict: obj) {
            if let dataType = data["dataType"] as? String {
                if dataType == "data" {
                    if let model = JSONDeserializer<T>.deserializeFrom(dict: data, designatedPath: "data") {
                        return model
                    }
                }
                
            }
        }
        
        return nil
    }
    
    func mapModelList<T: HandyJSON>(_ type: T.Type) -> [T?]? {
        if data.count < 1 {
            return nil
        }
        // 获取请求response的data转成json
        let obj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
        if let data = handleResponse(dict: obj) {
            if let dataType = data["dataType"] as? String {
                if dataType == "list" {
                    if let list = data["dataList"] as? Array<Any>, let model: [T?] = JSONDeserializer<T>.deserializeModelArrayFrom(array: list)  {
                        return model
                    }
                }
            }
        }
        return nil
    }
    
    func handleResponse(dict: NSDictionary?) -> NSDictionary? {
        if let meta = dict?["meta"] as? NSDictionary {
            if let code = meta["statusCode"] as? String{
                if code == "0" {
                    return dict
                }
                if code == "-403" {
                    print("用户无权限，请重新登录")
                    return nil
                }
                return nil
            }
        }
        return nil
    }
}
