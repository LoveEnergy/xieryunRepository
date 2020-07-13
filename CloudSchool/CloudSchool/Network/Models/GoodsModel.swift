//
//  GoodsModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class CartListModel: NSObject, Mappable {
    var ruleType: Int = 0
    var promotionType: Int = 0
    var discountPrice: CGFloat = 0.0
    var promotionID: Int = 0
    var mode: Int = 0
    var productList: [CartGoodsModel] = []
    var ruleList: [RuleModel] = []
    var totalAmount: CGFloat = 0.0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        ruleType <- map["ruleType"]
        promotionType <- map["promotionType"]
        totalAmount <- map["totalAmount"]
        discountPrice <- map["discountPrice"]
        discountPrice <- map["discountPrice"]
        promotionID <- map["promotionID"]
        mode <- map["mode"]
        productList <- map["productList"]
        ruleList <- map["ruleList"]
    }
    
    func getActivityString() -> String? {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            let string = self.ruleList.map { (item) -> String in
                return type.getString(rule: item) + mode.getString(rule: item)
                }.joined(separator: ",")
            return string
        }
        return nil
    }
    
}

/*
 "price": 299.9,
 "count": 1,
 "cardID": 12,
 "thumbnailUrl": "http://47.92.168.211/images/product/4/smallPic.png",
 "previewImgUrl": "http://47.92.168.211/images/product/4/bigPic.png",
 "type": 2,
 "productName": "空调系统节能",
 "productID": 4
*/

class GoodsModel: NSObject, Mappable {
    var price: CGFloat = 0.0
    var count: Int = 0
    var thumbnailUrl: String = ""
    var type: Int = 0
    var previewImgUrl: String = ""
    var productID: Int = 0
    var productName: String = ""
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        price <- map["price"]
        count <- map["count"]
        
        thumbnailUrl <- map["thumbnailUrl"]
        type <- map["type"]
        previewImgUrl <- map["previewImgUrl"]
        productID <- map["productID"]
        productName <- map["productName"]
    }
}

import RxSwift

class CartGoodsModel: NSObject, Mappable {
    
    var price: CGFloat = 0.0
    var count: Int = 0
    var cardID: Int = 0
    var thumbnailUrl: String = ""
    var type: Int = 0  //产品类型（1、课程3、班级）
    var previewImgUrl: String = ""
    var productID: Int = 0
    var productName: String = ""
    var productType: Int = 0
    var isChoosed: Variable<Bool> = Variable(false)
    var applePrice: Int = 0
    var applePayID: String = ""
    var isStudyCardPay: Int = 0//0 不可用  1 可以用
    var vipPrice: CGFloat = 0.0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cardID <- map["cardID"]
        previewImgUrl <- map["previewImgUrl"]
        
        thumbnailUrl <- map["thumbnailUrl"]
        price <- map["price"]
        count <- map["count"]
        productID <- map["productID"]
        productName <- map["productName"]
        type <- map["type"]
        productType <- map["productType"]
        
        applePrice <- map["applePrice"]
        applePayID <- map["applePayID"]
        isStudyCardPay <- map["isStudyCardPay"]
        vipPrice <- map["vipPrice"]
    }
}

class RuleModel: NSObject, Mappable {
    var count: Int = 0
    var ruleID: Int = 0
    var discountRate: Int = 0
    var promotionID: Int = 0
    var totalPrice: Int = 0
    var price: Int = 0
    var surplusNum: Int = 0
    var isHave: Int = 0
    var ruleType: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        price <- map["price"]
        ruleID <- map["ruleID"]
        count <- map["count"]
        discountRate <- map["discountRate"]
        promotionID <- map["promotionID"]
        totalPrice <- map["totalPrice"]
        surplusNum <- map["surplusNum"]
        isHave <- map["isHave"]
        ruleType <- map["ruleType"]
    }
}
