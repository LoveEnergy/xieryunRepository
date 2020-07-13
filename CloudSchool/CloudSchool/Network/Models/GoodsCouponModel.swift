//
//  GoodsCouponModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/17.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class GoodsCouponModel: NSObject, Mappable {
    
    var promotionID: Int = 0
    var ruleID: Int = 0
    var mode: Int = 0
    var receiveEndTime: String = ""
    var receiveStartTime: String = ""
    var promotionName: String = ""
    var productIDList: [Int] = []
    var ruleType: Int = 0
    var receiveCount: Int = 0
    var ruleList: [RuleModel] = []
    var endTime: String = ""
    var startTime: String = ""
    var couponNo: String = ""
    var count: Int = 0
    var totalPrice: CGFloat = 0.0
    var discountRate: Int = 0
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        count <- map["count"]
        totalPrice <- map["totalPrice"]
        discountRate <- map["discountRate"]
        promotionID <- map["promotionID"]
        ruleID <- map["ruleID"]
        mode <- map["mode"]
        receiveEndTime <- map["receiveEndTime"]
        receiveStartTime <- map["receiveStartTime"]
        promotionName <- map["promotionName"]
        ruleType <- map["ruleType"]
        productIDList <- map["productIDList"]
        receiveCount <- map["receiveCount"]
        ruleList <- map["ruleList"]
        endTime <- map["endTime"]
        startTime <- map["startTime"]
        couponNo <- map["couponNo"]
    }
    
    func getActivityString() -> String {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            if let item = RuleModel(JSON: self.toJSON()) {
                return type.getString(rule: item) + mode.getString(rule: item)
            } else {
                return ""
            }
        }
        return ""
    }
    
    func getCouponString() -> String {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            if let item = RuleModel(JSON: self.toJSON()) {
                return mode.getString(rule: item)
            } else {
                return ""
            }
        }
        return ""
    }
    
    func getActivityString(rule: RuleModel) -> String {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            return type.getString(rule: rule) + mode.getString(rule: rule)
        }
        return ""
    }
    
    func countCoupon(price: CGFloat, rule: RuleModel) -> CGFloat {
        if let type = ActivityType(rawValue: self.ruleType), let mode = ActivityMode(rawValue: self.mode) {
            switch mode {
            case .backCoupon:
                return price
            case .discount:
                return CGFloat(rule.discountRate) / 10.0 * price
            case .minus:
                return price - CGFloat(rule.price)
            }
        }
        return price
    }
    
}
