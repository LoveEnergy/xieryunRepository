//
//  SumitOrderBaseInfo.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class SumitOrderBaseInfo: NSObject, Mappable {
    var orderID: Int = 0
    var status: Int = 0
    var poNumber: String = ""
    var money: CGFloat = 0.0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        orderID <- map["orderID"]
        status <- map["status"]
        poNumber <- map["poNumber"]
        money <- map["money"]
    }
}
