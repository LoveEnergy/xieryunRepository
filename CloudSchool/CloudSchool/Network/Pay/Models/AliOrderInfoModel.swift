//
//  AliOrderInfoModel.swift
//  KuTing
//
//  Created by Maynard on 2018/4/12.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import Foundation
import UIKit
import ObjectMapper

class AliOrderInfoModel: NSObject, NetworkResultProtocol, Mappable {
    var code: Int = 0
    
    var message: String?
    var state: Int = 0
    var pay_params: String = ""
    var out_trade_no: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        state <- map["state"]
        message <- map["message"]
        pay_params <- map["pay_params"]
        out_trade_no <- map["out_trade_no"]
    }
}

