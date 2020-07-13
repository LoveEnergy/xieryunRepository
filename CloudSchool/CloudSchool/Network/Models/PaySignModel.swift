//
//  PaySignModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/12.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class PaySignModel: NSObject, Mappable {
    var weixinParmeter: WeChatOrderModel?
    var alipayParmeter: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        weixinParmeter <- map["weixinParmeter"]
        alipayParmeter <- map["alipayParmeter"]
    }
}

