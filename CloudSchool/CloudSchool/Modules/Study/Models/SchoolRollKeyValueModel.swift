//
//  SchoolRollKeyModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/5.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class SchoolRollKeyValueModel: NSObject, Mappable {
    var isMustFill: Bool = false
    var property: String = ""
    var displayName: String = ""
    var value: String?
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        isMustFill <- map["isMustFill"]
        property <- map["property"]
        displayName <- map["displayName"]
        value <- map["value"]
    }
}
