//
//  ClassCourseModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/1.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class ClassCourseModel: NSObject, Mappable {
    var schedule: String = ""
    var thumbnailUrl: String = ""
    var previewImgUrl: String = ""
    var day: Int = 0
    var learnedTime: Int = 0
    var userStudyID: Int = 0
    var closeTime: String = ""
    var courseName: String = ""
    var startTime: String = ""
    var courseID: Int = 0
    var eclassID: Int = 0
    var teacherName: String = ""
    var mediaType: Int = 0
    var smallPhotoUrl: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        schedule <- map["schedule"]
        day <- map["day"]
        thumbnailUrl <- map["thumbnailUrl"]
        learnedTime <- map["learnedTime"]
        userStudyID <- map["userStudyID"]
        startTime <- map["startTime"]
        closeTime <- map["closeTime"]
        previewImgUrl <- map["previewImgUrl"]
        courseName <- map["courseName"]
        courseID <- map["courseID"]
        eclassID <- map["eclassID"]
        teacherName <- map["teacherName"]
        mediaType <- map["mediaType"]
        smallPhotoUrl <- map["smallPhotoUrl"]
    }
}
