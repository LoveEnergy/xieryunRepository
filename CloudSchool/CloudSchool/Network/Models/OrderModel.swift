//
//  OrderModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

class OrderModel: NSObject, Mappable {
    var status: Int = 0
    var createTime: String = ""
    var poNumber: String = ""
    var detailList: [OrderGoodsModel] = []
    var orderID: Int = 0
    var price: CGFloat = 0.0
    var applePayID: String = ""
    var objectType: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        createTime <- map["createTime"]
        poNumber <- map["poNumber"]
        
        price <- map["price"]
       
        status <- map["status"]
        detailList <- map["detailList"]
        orderID <- map["orderID"]
        
        applePayID <- map["applePayID"]
        objectType <- map["objectType"]
    }
}




class OrderGoodsModel: NSObject, Mappable {
    var count: Int = 0
    var productName: String = ""
    var thumbnailUrl: String = ""
    var previewImgUrl: String = ""
    var price: CGFloat = 0.0
    var productType: Int = 0
    var productID: Int = 0
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        price <- map["price"]
        count <- map["count"]
        productName <- map["productName"]
        thumbnailUrl <- map["thumbnailUrl"]
        previewImgUrl <- map["previewImgUrl"]
        productType <- map["productType"]
        productID <- map["productID"]
    }
}


class OrderDetailModel: NSObject, Mappable {
    var status: Int = 0
    var distributionMode: Int = 0
    var createTime: String = ""
    var number: String = ""
    var addressInfo: AddressModel?
    var invoiceInfo: InvoiceInfoModel?
    var totalPrice: CGFloat = 0.0
    var paymentAmount: CGFloat = 0.0
    var orderDetailList: [CartGoodsModel] = []
    var orderID: Int = 0
    var price: CGFloat = 0.0
    var courierNumber: String = ""
    var carrierID: Int = 0
    var goodsStatus: Int = 0//发货状态（0 未发货 1 已发货）
    var carrierPhone: String = ""
    var carrier: String = ""//快递商
    var poNumber: String = ""//苹果订单号
    var applePayID: String = ""
    var productType: Int = 0
    var qrCodeImageUrl: String = ""
    var wechatNumber: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        createTime <- map["createTime"]
        number <- map["number"]
        distributionMode <- map["distributionMode"]
        invoiceInfo <- map["invoiceInfo"]
        price <- map["price"]
        totalPrice <- map["totalPrice"]
        paymentAmount <- map["paymentAmount"]
        addressInfo <- map["addressInfo"]
        status <- map["status"]
        orderDetailList <- map["orderDetailList"]
        orderID <- map["orderID"]
        courierNumber <- map["courierNumber"]
        carrierID <- map["carrierID"]
        goodsStatus <- map["goodsStatus"]
        carrierPhone <- map["carrierPhone"]
        carrier <- map["carrier"]
        poNumber <- map["poNumber"]
        applePayID <- map["applePayID"]
        productType <- map["productType"]
        qrCodeImageUrl <- map["qrCodeImageUrl"]
        wechatNumber <- map["wechatNumber"]
    }
}

class LogisticsModel: NSObject, Mappable {
    var State: Int = 0
    var Traces: [LogisticsDetailModel] = []
    var msg: String = ""
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        State <- map["State"]
        Traces <- map["Traces"]
        msg <- map["msg"]
    }
}
class LogisticsDetailModel: NSObject, Mappable {
    var AcceptTime: String = ""
    var AcceptStation: String = ""
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        AcceptTime <- map["AcceptTime"]
        AcceptStation <- map["AcceptStation"]
    }
}
