//
//  MonthProfitModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class MonthProfitModel: NSObject, Mappable {
    var month: String = ""
    var money: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        month <- map["saleDate"]
        money <- map["rewardAmount"]
    }
}
