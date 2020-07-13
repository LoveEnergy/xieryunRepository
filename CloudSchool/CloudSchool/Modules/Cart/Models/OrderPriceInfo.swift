//
//  OrderPriceInfo.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class OrderPriceInfo: NSObject, ValueInfoProtocol {
    var value: String
    
    var name: String
    
    init(name: String, value: String) {
        self.value = value
        self.name = name
        super.init()
    }
}
