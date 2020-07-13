//
//  QuestionInfoModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class QuestionListInfoModel: NSObject, Mappable {
    var paperID: Int = 0
    var questionTypeList: [QuestionTypeModel] = []
    var paperNo: Int = 0
    var paperTitle: String = ""
    var limitTime: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        paperID <- map["paperID"]
        questionTypeList <- map["questionTypeList"]
        paperNo <- map["paperNo"]
        paperTitle <- map["paperTitle"]
        limitTime <- map["limitTime"]
    }

}

class QuestionTypeModel: NSObject, Mappable {
    var basicType: Int = 0
    var questionList: [QuestionModel] = []
    var questionTypeID: Int = 0
    var questionTypeName: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        basicType <- map["basicType"]
        questionList <- map["questionList"]
        questionTypeID <- map["questionTypeID"]
        questionTypeName <- map["questionTypeName"]
        
    }
}

class QuestionModel: NSObject, Mappable {
    var score: Int = 0
    var optionList: [AnswerModel] = []
    var questionID: Int = 0
    var questionTitle: String = ""
    var answer: String = ""
    var isRight: Bool = false
    var chooseAnswerModel: ChooseAnswerModel = ChooseAnswerModel()
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        score <- map["score"]
        optionList <- map["optionList"]
        questionID <- map["questionID"]
        questionTitle <- map["questionTitle"]
        answer <- map["answer"]
        isRight <- map["isRight"]
    }
}

class AnswerModel: NSObject, Mappable {
    var questionID: Int = 0
    var serialNumber: String = ""
    var optionID: Int = 0
    var optionContent: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        questionID <- map["questionID"]
        serialNumber <- map["serialNumber"]
        optionID <- map["optionID"]
        optionContent <- map["optionContent"]
        
    }
}

//用户选择结果，用于提交答案

/*
 paperID     是     int     试卷ID
 questionID     是     int     试题ID
 paperNo     是     int     试卷套数
 type     是     int     题型（1、单选2、多选3、问答4、复合）
 content     是     string     答题内容（单选：A多选：A,C）
 */
class ChooseAnswerModel: NSObject {
    var paperID: Int = 0
    var paperNo: Int = 0
    var type: Int = 0
    var questionID: Int = 0
    var content: [String] = []
}


