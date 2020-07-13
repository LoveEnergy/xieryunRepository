//
//  CardInfo.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

protocol CardInfo {
    var cardNo: String { get }
    var createTime: String { get }
    var productName: String { get }
    var status: Int { get }
    var code: String { get }
//    var cardNumber: String {}
}


import ObjectMapper

class CourseCardModel: NSObject, Mappable, CardInfo {
    var cardNo: String {
        return "卡号：\(self.cardNumber)"
    }
    var createTime: String {
        return "有效期：\(self.createDate)"
    }
    var productName: String {
        return "关联班级:\(self.descriptionString)"
    }
    
    var cardNumber: String = ""
    var createDate: String = ""
    var descriptionString: String = ""
    var status: Int = 0
    var code: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        cardNumber <- map["cardNo"]
        createDate <- map["createTime"]
        descriptionString <- map["productName"]
        status <- map["status"]
        code <- map["code"]
    }
}

class GetCourseCardModel: NSObject, Mappable, CardInfo {
    var cardNo: String {
        return "卡号：\(self.cardNoKey)\n\n密钥：\(self.code)"
    }
    var productName: String {
        return "有效期：\(self.validDate)"
    }
    var createTime: String {
        return "关联班级:\(self.productNameKey)"
    }
    
    var code: String = ""
    var cardNoKey: String = ""
    var productNameKey: String = ""
    var batchID: Int = 0
    var validDate: String = ""
    var courseCardID: Int = 0
    var status: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        code <- map["code"]
        productNameKey <- map["productName"]
        cardNoKey <- map["cardNo"]
        batchID <- map["batchID"]
        validDate <- map["validDate"]
        courseCardID <- map["courseCardID"]
        status <- map["status"]
    }
}

class StudyCardListModel: NSObject, Mappable {
    var pageNo: Int = 0
    var rows: [StudyCardModel] = [StudyCardModel]()
    var totalRows: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        pageNo <- map["pageNo"]
        rows <- map["rows"]
        totalRows <- map["totalRows"]
    }
}

class StudyCardModel: NSObject, Mappable, CardInfo {
    var cardNo: String {
        return "卡号：\(self.learnCardNo)"
    }
    
    var createTime: String {
        return "有效期：\(self.validDate)"
    }
    
    var productName: String {
        return "余额：\(surplusAmount.numberFormat(length: 2))"
    }
    
    var learnCardNo: String = ""
    var validDate: String = ""
    var learnCardID: Int = 0
    var surplusAmount: CGFloat = 0.0
    var status: Int = 0
    var code: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        learnCardID <- map["learnCardID"]
        learnCardNo <- map["learnCardNo"]
        surplusAmount <- map["surplusAmount"]
        validDate <- map["validDate"]
        status <- map["status"]
        code <- map["code"]
    }
}

class LearnCardAmountModel: NSObject, Mappable {
    
    var totalAmount: CGFloat = 0.0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        totalAmount <- map["totalAmount"]
    }
}

class InvoiceIDModel: NSObject, Mappable {
    
    var invoiceID: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        invoiceID <- map["invoiceID"]
    }
}

class InvoiceInfoModel: NSObject, Mappable {
    
    var userID: Int = 0
    var taxpayerNo: String = ""
    var invoiceType: Int = 0
    var contentType: Int = 0
    var invoiceID: Int = 0
    
    var surplusAmount: CGFloat = 0.0
    var companyName: String = ""
    var createTime: String = ""
    var updateTime: String = ""
    var invoiceIDs: String = ""
    var remarks: String = ""
    var invoiceRise: Int = 1
    
    var isValid: Bool = true
    var email: String = ""
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userID <- map["userID"]
        invoiceType <- map["invoiceType"]
        taxpayerNo <- map["taxpayerNo"]
        contentType <- map["contentType"]
        createTime <- map["createTime"]
        invoiceID <- map["invoiceID"]
        companyName <- map["companyName"]
        isValid <- map["isValid"]
        invoiceIDs <- map["invoiceIDs"]
        remarks <- map["remarks"]
        invoiceRise <- map["invoiceRise"]
        updateTime <- map["updateTime"]
        email <- map["email"]
    }
    
    var invoiceString: String {
        let type = self.invoiceRise == 1 ? "个人" : self.companyName
        let  content = self.contentType == 1 ? "商品明细" : "商品类别"
        return "电子发票（\(content) - \(type)）"
    }
}



