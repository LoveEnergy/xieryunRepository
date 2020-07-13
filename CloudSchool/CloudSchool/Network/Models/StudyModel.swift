//
//  StudyModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

//"schedule": "0",
//"coursewareID": 2,
//"thumbnailUrl": "http://47.92.168.211/images/product/2/smallPic.png",
//"classCategoryName": "西尔课程",
//"previewImgUrl": "http://47.92.168.211/images/product/2/bigPic.png",
//"productName": "企业能源管理概述",
//"cityID": 2

class StudyModel: NSObject, Mappable {
    var objectID: Int = 0
    var productID: Int = 0
    var productName: String = ""
    var userStudyID: Int = 0
    var schedule: String = ""
    var coursewareID: Int = 0
    var thumbnailUrl: String = ""
    var classCategoryName: String = ""
    var previewImgUrl: String = ""
    var cityID: Int = 0
    
    var type: Int = 0
    var validTime: String = ""
    var mediaType: Int = 0//0.视频  1.音频
    var courseID: Int = 0//
    var teacherName: String = ""
    var smallPhotoUrl: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        schedule <- map["schedule"]
        coursewareID <- map["coursewareID"]
        userStudyID <- map["userStudyID"]
        thumbnailUrl <- map["thumbnailUrl"]
        classCategoryName <- map["classCategoryName"]
        previewImgUrl <- map["previewImgUrl"]
        cityID <- map["cityID"]
        productName <- map["productName"]
        objectID <- map["objectID"]
        productID <- map["productID"]
        type <- map["type"]
        validTime <- map["validTime"]
        mediaType <- map["mediaType"]
        courseID <- map["courseID"]
        teacherName <- map["teacherName"]
        smallPhotoUrl <- map["smallPhotoUrl"]
    }
}

/* 班级 */
class ClassModel: NSObject, Mappable {
    var objectID: Int = 0
    var productID: Int = 0
    var productName: String = ""
    var userStudyID: Int = 0
    var thumbnailUrl: String = ""
    var type: Int = 0
    var tips: String = ""
    var previewImgUrl: String = ""
    var classType: String = ""
    var closeTime: String = ""
    var startTime: String = ""
    var schedule: String = ""
    var isNeedSchoolRoll: Bool = false
    var isHasSchoolRoll: Bool = false
    var teacherID: Int = 0
    var status: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        schedule <- map["schedule"]
        userStudyID <- map["userStudyID"]
        thumbnailUrl <- map["thumbnailUrl"]
        tips <- map["tips"]
        previewImgUrl <- map["previewImgUrl"]
        classType <- map["classType"]
        productName <- map["productName"]
        objectID <- map["objectID"]
        productID <- map["productID"]
        type <- map["type"]
        startTime <- map["startTime"]
        closeTime <- map["closeTime"]
        isNeedSchoolRoll <- map["isNeedSchoolRoll"]
        isHasSchoolRoll <- map["isHasSchoolRoll"]
        teacherID <- map["teacherID"]
        status <- map["status"]
    }
}



