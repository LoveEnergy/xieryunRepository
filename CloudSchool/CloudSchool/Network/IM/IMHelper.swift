//
//  IMHelper.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

class IMHelper: NSObject {
    static let shared = IMHelper()
    
    fileprivate var endpointClosure = { (target: IMAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<IMAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
    }
    
    func getChatRoomInfo(objectID: String) -> Observable<BaseInfoModel<IMModel>>{
        return provider.rx.request(IMAPI.getChatRoomInfo(objectID: objectID))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable()
        .mapObject(type: BaseInfoModel<IMModel>.self)
    }
    
    func getLiveClassInfo(pushUrl: String) -> Observable<BaseInfoModel<LiveClassModel>>{
        return provider.rx.request(IMAPI.getLiveClassInfo(pushUrl: pushUrl))
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable()
        .mapObject(type: BaseInfoModel<LiveClassModel>.self)
    }
    
    func getUserListData(roomID: String) -> Observable<BaseInfoModel<LiveListData>>{
       return provider.rx.request(IMAPI.getUserListData(roomID: roomID))
       .filterSuccessfulStatusCodes()
       .mapJSON()
       .asObservable()
       .mapObject(type: BaseInfoModel<LiveListData>.self)
    }
    
    func getLiveClassListData() -> Observable<SelectLiveClassArrayData>{
        return provider.rx.request(IMAPI.getLiveClassListData)
        .filterSuccessfulStatusCodes()
        .mapJSON()
        .asObservable()
        .mapObject(type: SelectLiveClassArrayData.self)
    }
}

class SelectLiveClassArrayData: NSObject, Mappable {
    var message: String = ""
    var data: [SelectLiveClassDataModel]?
    var code: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        data <- map["data"]
        code <- map["code"]
    }
    
    
}

class SelectLiveClassDataModel: NSObject, Mappable {
    var productName: String = ""
    var productID: Int = 0
    var objectID: Int = 0
    var pushUrl: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productName <- map["productName"]
        productID <- map["productID"]
        objectID <- map["objectID"]
        pushUrl <- map["pushUrl"]
    }
    
    
}

class IMModel: NSObject, Mappable {
    var username: String = ""
    var nickname: String = ""
    var password: String = ""
    var roomID: Int = 0
    var activated: Bool = true
    var uuid: String = ""
    var created: Int = 0
    var type: String = ""
    var modified: Int = 0
    var owner: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        username <- map["username"]
        nickname <- map["nickname"]
        roomID <- map["roomID"]
        password <- map["password"]
        activated <- map["activated"]
        uuid <- map["uuid"]
        created <- map["created"]
        type <- map["type"]
        modified <- map["modified"]
        owner <- map["owner"]
    }
}


class LiveClassModel: NSObject, Mappable {
    var productID: Int = 0
    var objectID: Int = 0
    var productName: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        objectID <- map["objectID"]
        productName <- map["productName"]
    }
}

class LiveListData: NSObject, Mappable {
    var onlineUserList: [LiveUserInfo]?
    var affiliations_count: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        onlineUserList <- map["onlineUserList"]
        affiliations_count <- map["affiliations_count"]
    }
}

class LiveUserInfo: NSObject, Mappable {
    
    var role: String = ""
    var nickname: String = ""
    var username: String = ""
    var isMute: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        role <- map["role"]
        nickname <- map["nickname"]
        username <- map["username"]
        isMute <- map["isMute"]//是否禁言
    }
}
