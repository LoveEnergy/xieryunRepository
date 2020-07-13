//
//  ExamBaseInfoModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 userID     int     用户ID
 paperID     int     试卷ID
 isStart     int     是否考试
 score     double     成绩
 paperTitle     string     试卷标题
 paperCount     int     试卷数量
 examTime     int     考试时长
 examCount     int     试卷考试次数
 closeTime     String     关闭时间
 surplusCount     int     剩余考试次数
 */

class ExamBaseInfoModel: NSObject, Mappable {
    var examCount: Int = 0
    var userID: Int = 0
    var examTime: Int = 0
    var examID: Int = 0
    var limitTime: Int = 0
    var paperCount: Int = 0
    var isStart: Bool = false
    var paperTitle: String = ""
    var closeTime: String = ""
    var detailList: [OrderGoodsModel] = []
    var paperID: Int = 0
    var surplusCount: Int = 0
    var score: CGFloat = 0.0
    var status: Int = 0
    var haveTest: Int = 0
    var objectID: Int = 0
    var examTitle: String = ""
    var endTime: String = ""
    var startTime: String = ""
    var eclassID: Int = 0
    var haveScore: Int = 0//0.未测试  1.已测试
    var isAllowViewAnswer: Int = 0//0.不让看答卷 1.让看答卷
    var isAllowViewRight: Int = 0//0.不让看答案 1.让看答案
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        surplusCount <- map["surplusCount"]
        examCount <- map["examCount"]
        examTime <- map["examTime"]
        examID <- map["examID"]
        limitTime <- map["limitTime"]
        paperCount <- map["paperCount"]
        isStart <- map["isStart"]
        paperTitle <- map["examTitle"]
        closeTime <- map["closeTime"]
        
        score <- map["score"]
        
        userID <- map["userID"]
        detailList <- map["detailList"]
        paperID <- map["paperID"]
        status <- map["status"]
        haveTest <- map["haveTest"]
        objectID <- map["objectID"]
        examTitle <- map["examTitle"]
        endTime <- map["endTime"]
        startTime <- map["startTime"]
        eclassID <- map["eclassID"]
        haveScore <- map["haveScore"]
        isAllowViewAnswer <- map["isAllowViewAnswer"]
        isAllowViewRight <- map["isAllowViewRight"]
    }
}

class ExamResultInfoModel: NSObject, Mappable {
    var paperNo: Int = 0
    var createTime: String = ""
    var paperID: Int = 0
    var userPaperID: Int = 0
    var score: CGFloat = 0.0
    var examID: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        paperNo <- map["paperNo"]
        paperID <- map["paperID"]
        userPaperID <- map["userPaperID"]
        createTime <- map["createTime"]
        score <- map["score"]
        examID <- map["examID"]
    }
}
