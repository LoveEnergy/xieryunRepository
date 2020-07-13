//
//  NetworkHelper.swift
//  KuTing
//
//  Created by Maynard on 2018/3/26.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}

func plugins() -> [PluginType]{
    var plugins: [PluginType] = [PluginType]()
    
    #if DEBUG
    plugins.append(NetworkLoggerPlugin(verbose: true, responseDataFormatter:JSONResponseDataFormatter ))
    
    let activity =  NetworkActivityPlugin(networkActivityClosure: { (change, target) in
        print(change)
        print(target)
    })
    plugins.append(activity)
    #endif
    
    return plugins
}

class NetworkHelper: NSObject {
    static let shared = NetworkHelper()
    
//    var haveCarNumber: Variable<Bool> = Variable(false)
//    var carNumbers: Variable<[CarNumberModel]> = Variable([])
//
//    var lots: Variable<[PersonalLotModel]> = Variable([])
    
    
    fileprivate var endpointClosure = { (target: UserAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<UserAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
//        loadCarNumbers()
//        if let jsonString = UserDefaults.User.string(forKey: .personalList), let listModel = PersonalLotListModel(JSONString: jsonString) {
//
//            self.lots.value = listModel.list1 + listModel.list3
//        }
    }
    
   
    
    
    
    func updateUserInfo() {
        
        provider.rx.request(UserAPI.getUserInfo())
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable().mapObject(type: UserInfo.self)
            .subscribe(onNext: { (userInfo) in
                LoginHelper.shared.currentUser.value = userInfo
            }).disposed(by: disposeBag)
    }
}
