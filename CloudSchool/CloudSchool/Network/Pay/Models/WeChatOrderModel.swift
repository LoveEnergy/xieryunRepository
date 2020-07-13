//
//  WeChatOrderModel.swift
//  KuTing
//
//  Created by 彭显鹤 on 2018/3/9.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import ObjectMapper

class WeChatOrderModel: NSObject, NetworkResultProtocol, Mappable {
    var code: Int = 0
    
    var message: String?
    var state: Int = 0
    var result_code: String = ""
    var mch_id: String = ""
    var appid: String = ""
    var return_code: String = ""
    var nonce_str: String = ""
    var trade_type: String = ""
    var return_msg: String = ""
    var partnerid: String = ""
    var prepay_id: String = ""
    var package: String = ""
    
    var timestamp: String = ""
    var sign: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        state <- map["state"]
        message <- map["message"]
        appid <- map["appid"]
        partnerid <- map["partnerid"]
        prepay_id <- map["prepay_id"]
        package <- map["package"]
        nonce_str <- map["nonce_str"]
        timestamp <- map["timestamp"]
        sign <- map["sign"]
        
        result_code <- map["result_code"]
        mch_id <- map["mch_id"]
        return_msg <- map["return_msg"]
        trade_type <- map["trade_type"]
        return_code <- map["return_code"]
    }
}
