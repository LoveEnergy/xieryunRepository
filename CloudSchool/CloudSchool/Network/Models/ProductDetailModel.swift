
//
//  ProductDetailModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 "address" : "",
 "productID" : 85,
 "seriesName" : "碳交易",
 "webIntroduce" : "<p><\/p><div class=\"media-wrap image-wrap\"><img src=\"http:\/\/47.92.168.211\/images\/product\/1544406304874.png\"\/><\/div><p><\/p>",
 "parentSeriesName" : "张娜TEST",
 "buyCount" : 0,
 "teacherName" : "张娜测试教师",
 "streetName" : "",
 "productType" : 1,
 "closeTime" : "",
 "provinceName" : "",
 "countyName" : "",
 "couponList" : [
 
 ],
 "activityList" : [
 {
 "ruleType" : 2,
 "count" : null,
 "ruleList" : [
 {
 "ruleID" : 11,
 "discountRate" : 8,
 "promotionID" : 20,
 "totalPrice" : 300
 },
 {
 "ruleID" : 12,
 "discountRate" : 7,
 "promotionID" : 20,
 "totalPrice" : 400
 }
 ],
 "discountRate" : 8,
 "explain" : "asdfsdf",
 "promotionID" : 20,
 "userRange" : 1,
 "discountPrice" : null,
 "mode" : 1,
 "price" : null,
 "isOnly" : 0,
 "promotionName" : "优惠",
 "productRange" : null,
 "totalPrice" : 300
 }
 ],
 "isOnlyCoupon" : false,
 "isOnlyActivity" : false,
 "thumbnailUrl" : "http:\/\/47.92.168.211\/images\/product\/1544406185756.jpg",
 "courseName" : "张娜测试课程1",
 "productName" : "张娜测试课程1",
 "likeCount" : 0,
 "cityName" : "",
 "basicPrice" : 89,
 "startTime" : "",
 "previewImgUrl" : "http:\/\/47.92.168.211\/images\/product\/1544406171752.jpg"
 }
*/

class ProductDetailModel: NSObject, Mappable {
    
    var productID: Int = 0
    var address: String = ""
    var seriesName: String = ""
    var webIntroduce: String = ""
    var parentSeriesName: String = ""
    var buyCount: Int = 0
    var teacherName: String = ""
    var streetName: String = ""
    var productType: Int = 0 //1、课程3、班级
    var closeTime: String = ""
    var provinceName: String = ""
    var countyName: String = ""
    var couponList: [ActivityModel] = []
    var activityList: [ActivityModel] = []
    var isOnlyCoupon: Bool = false
    var isOnlyActivity: Bool = false
    var thumbnailUrl: String = ""
    var courseName: String = ""
    var productName: String = ""
    var basicPrice: CGFloat = 0.0
    
    var likeCount: Int = 0
    var cityName: String = ""
    var startTime: String = ""
    
    var price: CGFloat = 0.0
    
    var previewImgUrl: String = ""
    var categoryID: Int = 0
        
    var courseSeriesID: Int = 0
    var parentSeriesID: Int = 0
    
    var activityMap: ShareActivityModel?
    var playUrl: String = ""
    var isStudyCardPay : Int = 0
    var isGroup : Int = 0
    var groupBuyList : [GroupBuyModel] = [GroupBuyModel]()
    var stock: Int = 0//总库存，需要减去售出才能得到剩余库存
    var isStudy: Int = 0//1 开始学习  0 立即购买
    var titleLevel: String = ""//名头
    var applePrice: Int = 0
    var applePayID: String = ""
    var eclassID: Int = 0
    
    var trySeeVideoUrl: String = ""//
    var objectType: Int = 0//
    
    var qrCodeImageUrl: String = ""//二维码
    var wechatNumber: String = ""//微信号
    
    var characteristicList: String = ""//特色
    var openingName: String = ""//所属机构
    var certificateAuthority: String = ""//证书
    var courseCount: Int = 0
    var teachersName: String = ""
    var mobileIntroduce: String = ""
    var mode: Int = 0
    var isPay: Int = 0
    var freeShippingPrice: Int = 0
    var courseType: Int = 0//0.精品课  1.VIP课
    var vipPrice: CGFloat = 0.0
    var originalPrice: CGFloat = 0.0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        address <- map["address"]
        seriesName <- map["seriesName"]
        buyCount <- map["buyCount"]
        price <- map["price"]
        teacherName <- map["teacherName"]
        streetName <- map["streetName"]
        parentSeriesName <- map["parentSeriesName"]
        productType <- map["productType"]
        closeTime <- map["closeTime"]
        provinceName <- map["provinceName"]
        countyName <- map["countyName"]
        couponList <- map["couponList"]
        activityList <- map["activityList"]
        isOnlyCoupon <- map["isOnlyCoupon"]
        isOnlyActivity <- map["isOnlyActivity"]
        
        categoryID <- map["categoryID"]
        thumbnailUrl <- map["thumbnailUrl"]
        courseName <- map["courseName"]
        likeCount <- map["likeCount"]
        cityName <- map["cityName"]
        startTime <- map["startTime"]
        basicPrice <- map["basicPrice"]
        webIntroduce <- map["webIntroduce"]
        
        courseSeriesID <- map["courseSeriesID"]
        parentSeriesID <- map["parentSeriesID"]
        previewImgUrl <- map["previewImgUrl"]
        productID <- map["productID"]
        productName <- map["productName"]
        activityMap <- map["activityMap"]
        playUrl <- map["playUrl"]
        isStudyCardPay <- map["isStudyCardPay"]
        isGroup <- map["isGroup"]
        groupBuyList <- map["groupBuyList"]
        stock <- map["stock"]
        isStudy <- map["isStudy"]
        titleLevel <- map["titleLevel"]
        applePrice <- map["applePrice"]
        applePayID <- map["applePayID"]
        eclassID <- map["eclassID"]
        trySeeVideoUrl <- map["trySeeVideoUrl"]
        objectType <- map["objectType"]
        qrCodeImageUrl <- map["qrCodeImageUrl"]
        wechatNumber <- map["wechatNumber"]
        
        characteristicList <- map["characteristicList"]
        openingName <- map["openingName"]
        certificateAuthority <- map["certificateAuthority"]
        courseCount <- map["courseCount"]
        teachersName <- map["teachersName"]
        
        mobileIntroduce <- map["mobileIntroduce"]
        mode <- map["mode"]
        isPay <- map["isPay"]
        freeShippingPrice <- map["freeShippingPrice"]
        vipPrice <- map["vipPrice"]
        courseType <- map["courseType"]
        originalPrice <- map["originalPrice"]
    }
}
class GroupBuyModel: NSObject, Mappable {
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        cashBackAmount <- map["cashBackAmount"]
        peopleNum <- map["peopleNum"]
        groupBuyName <- map["groupBuyName"]
        endTime <- map["endTime"]
        groupBuyID <- map["groupBuyID"]
        productDescription <- map["description"]
        startTime <- map["startTime"]
        leastPeopleNum <- map["leastPeopleNum"]
        detailedTime <- map["detailedTime"]
    }
    
    var cashBackAmount : Int = 0
    var peopleNum : Int = 0
    var groupBuyName : String = ""
    var endTime : String = ""
    var groupBuyID : Int = 0
    var productDescription : String = ""
    var startTime : String = ""
    var leastPeopleNum : Int = 0
    var detailedTime : Int = 0
}
//class CouponRuleModel : NSObject, Mappable{
//    var totalPrice : Int = 0
//    var ruleID : Int = 0
//    var promotionID : Int = 0
//    var price : Int = 0
//    var surplusNum : Int = 0
//    var isHave : Int = 0
//
//    required init?(map: Map) {
//    }
//
//    func mapping(map: Map) {
//        totalPrice <- map["totalPrice"]
//        ruleID <- map["ruleID"]
//        promotionID <- map["promotionID"]
//        price <- map["price"]
//        surplusNum <- map["surplusNum"]
//        isHave <- map["isHave"]
//    }
//}

class ShareActivityModel: NSObject, Mappable {
    var activityID: Int = 0
    var activityScope: Int = 0
    var activityCategoryID: Int = 0
    
    var activityDescription: String = ""
    var activityEndDate: String = ""
    var activityStartDate: Int = 0 //1、课程3、班级
    var activityAbbreviation: String = ""
    var activityName: String = ""
    var activityCategoryName: String = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        activityID <- map["activityID"]
        activityDescription <- map["activityDescription"]
        activityScope <- map["activityScope"]
        
        activityEndDate <- map["activityEndDate"]
        activityStartDate <- map["activityStartDate"]
        activityAbbreviation <- map["activityAbbreviation"]
        activityName <- map["activityName"]
        activityCategoryName <- map["activityCategoryName"]
        activityCategoryID <- map["activityCategoryID"]
    }
}

class InviteCodeModel: NSObject, Mappable {
    var invitationCode: String = ""
    var code: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        invitationCode <- map["invitationCode"]
        code <- map["code"]
    }
}


class SubmitOrderGoodsModel: NSObject, Mappable {
    var productID: Int = 0
    var type: Int = 0
    var count: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        type <- map["type"]
        count <- map["count"]
    }
}

class SubmitOrderGoodsNewModel: NSObject, Mappable {
    var productID: Int = 0
    var type: Int = 0
    var count: Int = 0
    
    var isStudyCardPay : String = ""
    var previewImgUrl : String = ""
    var productName : String = ""
    var thumbnailUrl : String = ""
    var price: CGFloat = 0.0
    var vipPrice: CGFloat = 0.0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        type <- map["type"]
        count <- map["count"]
        
        isStudyCardPay <- map["isStudyCardPay"]
        previewImgUrl <- map["previewImgUrl"]
        productName <- map["productName"]
        thumbnailUrl <- map["thumbnailUrl"]
        
        price <- map["price"]
        vipPrice <- map["vipPrice"]
    }
}

class SubmitOrderGoodsNewWithVIPModel: NSObject, Mappable {
    var productID: Int = 0
    var type: Int = 0
    var count: Int = 0
    
    var isStudyCardPay : String = ""
    var previewImgUrl : String = ""
    var productName : String = ""
    var thumbnailUrl : String = ""
    var vipPrice: CGFloat = 0.0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        type <- map["type"]
        count <- map["count"]
        
        isStudyCardPay <- map["isStudyCardPay"]
        previewImgUrl <- map["previewImgUrl"]
        productName <- map["productName"]
        thumbnailUrl <- map["thumbnailUrl"]
        
        vipPrice <- map["vipPrice"]
    }
}

class SubmitOrderGoodsNewWithoutVIPModel: NSObject, Mappable {
    var productID: Int = 0
    var type: Int = 0
    var count: Int = 0
    
    var isStudyCardPay : String = ""
    var previewImgUrl : String = ""
    var productName : String = ""
    var thumbnailUrl : String = ""
    var price: CGFloat = 0.0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        productID <- map["productID"]
        type <- map["type"]
        count <- map["count"]
        
        isStudyCardPay <- map["isStudyCardPay"]
        previewImgUrl <- map["previewImgUrl"]
        productName <- map["productName"]
        thumbnailUrl <- map["thumbnailUrl"]
        
        price <- map["price"]
    }
}

class CouponModel: NSObject, Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        
    }

}

class ActivityModel: NSObject, Mappable {
    var ruleList: [RuleModel] = []
    //
    var ruleType: Int = 0
    var count: Int = 0
    var discountRate: Int = 0
    var explain: String = ""
    var promotionID: Int = 0
    var userRange: Int = 0
    var discountPrice: CGFloat = 0.0
    var mode: Int = 0
    var price: Int = 0
    var isOnly: Int = 0
    var promotionName: String = ""
    var productRange: Int = 0
    var totalPrice: Int = 0
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ruleList <- map["ruleList"]
        ruleType <- map["ruleType"]
        count <- map["count"]
        discountRate <- map["discountRate"]
        explain <- map["explain"]
        promotionID <- map["promotionID"]
        userRange <- map["userRange"]
        discountPrice <- map["discountPrice"]
        isOnly <- map["isOnly"]
        promotionName <- map["promotionName"]
        productRange <- map["productRange"]
        totalPrice <- map["totalPrice"]
        mode <- map["mode"]
    }
    
    func getActivityArray() -> [String] {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            let array = self.ruleList.map { (item) -> String in
                return type.getString(rule: item) + mode.getString(rule: item)
                }
            return array
        }
        return []
    }
    
}





