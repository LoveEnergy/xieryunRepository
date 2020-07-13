//
//  LoginModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/15.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class LoginModel: NSObject, Mappable {
    var token: String = ""
    var loginName: String = ""
    var isMember: Int = 0
    var isExpired: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        token <- map["token"]
        loginName <- map["loginName"]
        isMember <- map["isMember"]
        isExpired <- map["isExpired"]
    }
}
