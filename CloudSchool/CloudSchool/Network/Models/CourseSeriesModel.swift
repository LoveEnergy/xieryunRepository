//
//  CourseSeriesModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/3.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

protocol SeriesInfo {
    var seriesID: Int { get }
    var seriesName: String { get }
//    var floorName: String{get}
//    var navigationID: String { get }
    func openMore()
}

class CourseSeriesModel: NSObject, Mappable, SeriesInfo {
    var seriesID: Int = 0
    var seriesName: String = ""
//    var navigationID: String = ""
//    var floorName: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        seriesID <- map["seriesID"]
        seriesName <- map["seriesName"]
//        floorName <- map["floorName"]
//        navigationID <- map["navigationID"]
    }
    
    func openMore() {
        
    }
}
