//
//  UserInfo.swift
//  KuTing
//
//  Created by Maynard on 2018/3/23.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import ObjectMapper

class BaseModel: NSObject, Mappable, NetworkResultProtocol {
    var code: Int = 0
    
    var message: String?
    
    var state: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        state <- map["state"]
        message <- map["message"]
    }
}

class LoginInfoModel: NSObject, Mappable, NetworkResultProtocol{
    required init?(map: Map) {
        
    }
    
    var message: String?
    
    var code: Int = 0
    
    var data: UserInfo?
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        message <- map["message"]
    }
    
    
}

class UserInfo: NSObject, Mappable {
    
    var userID: Int = 0
    var phone: String = ""
    var headUrl: String = ""
    var introduction: String = ""
    var loginName: String = ""
    var birthday: String = ""
    var email: String = ""
    var loginCount: Int = 0
    var sex: Int = 0
    var nickName: String = ""
    var token : String = ""
    var wxThirdLoginID: String = ""
    var qqThirdLoginID: String = ""
    var isMember: Int = 0//0.非会员   1.会员
    var money: CGFloat = 0//剩余学点
    var isExpired: Int = 0//会员：0.已过期   1.未过期
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        userID <- map["userID"]
        phone <- map["phone"]
        headUrl <- map["headUrl"]
        introduction <- map["introduction"]
        loginName <- map["loginName"]
        birthday <- map["birthday"]
        email <- map["email"]
        loginCount <- map["loginCount"]
        sex <- map["sex"]
        nickName <- map["nickName"]
        token <- map["token"]
        wxThirdLoginID <- map["wxThirdLoginID"]
        qqThirdLoginID <- map["qqThirdLoginID"]
        isMember <- map["isMember"]
        money <- map["money"]
        isExpired <- map["isExpired"]
    }

}


class VersionModel: NSObject, Mappable, NetworkResultProtocol {
    var code: Int = 0
    
    var message: String?
    
    var data: VersionDetailModel?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        message <- map["message"]
    }
}

class VersionDetailModel: NSObject, Mappable {
    var versionID: String = ""
    var versionInfo: String = ""
    var clientVersion: String = ""
    var createDate: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        versionID <- map["versionID"]
        versionInfo <- map["versionInfo"]
        clientVersion <- map["clientVersion"]
        createDate <- map["createDate"]
    }
}


