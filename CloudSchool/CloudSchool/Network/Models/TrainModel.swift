//
//  TrainModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 startTime    "2018-11-01 16:02:11"
 countyName    "东城区"
 time    "2018.11.01-10.21"
 address    "123"
 cityName    "北京市"
 thumbnailUrl    "http://47.92.168.211/images/product/1541388207313.jpg"
 basicstartTime    12
 eclassID    5
 streetName    "东华门街道"
 provinceName    "北京"
 previewImgUrl    "http://47.92.168.211/images/product/1541388204915.jpg"
 endTime    "2018-10-21 21:46:47"
 productName    "2018年广东省重点排污单位环境守法培训班"
 productID    54
 */

class TrainModel: NSObject, Mappable {
    var startTime: String = ""
    var countyName: String = ""
    var time: String = ""
    var address: String = ""
    var cityName: String = ""
    var basicPrice: CGFloat = 0.0
    var thumbnailUrl: String = ""
    var eclassID: Int = 0
    var streetName: String = ""
    var provinceName: String = ""
    
    var previewImgUrl: String = ""
    var endTime: String = ""
    var productName: String = ""
    var productID: Int = 0
    var isGroup : Int = 0
    var objectType: Int = 0
    var buyCount: Int = 0
    var courseType: Int = 0
    var addressString: String {
        return "\(self.provinceName) \(self.cityName) \(self.address)"
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        startTime <- map["startTime"]
        countyName <- map["countyName"]
        
        time <- map["time"]
        address <- map["address"]
        cityName <- map["cityName"]
        thumbnailUrl <- map["thumbnailUrl"]
        basicPrice <- map["basicPrice"]
        eclassID <- map["eclassID"]
        
        streetName <- map["streetName"]
        provinceName <- map["provinceName"]
        previewImgUrl <- map["previewImgUrl"]
        productID <- map["productID"]
        productName <- map["productName"]
        isGroup <- map["isGroup"]
        objectType <- map["objectType"]
        buyCount <- map["buyCount"]
        courseType <- map["courseType"]
    }
}
