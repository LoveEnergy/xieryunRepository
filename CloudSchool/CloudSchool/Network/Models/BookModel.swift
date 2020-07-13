//
//  BookModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

/*
 "basicPrice" : 11,
 "categoryName" : "历史",
 "seriesName" : "碳交易",
 "bookID" : 23,
 "productID" : 77,
 "productName" : "mmmmmm",
 "thumbnailUrl" : "http:\/\/47.92.168.211\/images\/product\/1544346071813.png",
 "price" : 22,
 "parentSeriesName" : "张娜TEST",
 "previewImgUrl" : "http:\/\/47.92.168.211\/images\/product\/1544346068495.png",
 "categoryID" : 11,
 "courseSeriesID" : 61,
 "parentSeriesID" : 60
 */

class BookModel: NSObject, Mappable {
    var basicPrice: CGFloat = 0.0
    var categoryName: String = ""
    var seriesName: String = ""
    var bookID: Int = 0
    var productID: Int = 0
    var productName: String = ""
    var thumbnailUrl: String = ""
    var price: CGFloat = 0.0
    var parentSeriesName: String = ""
    var previewImgUrl: String = ""
    var categoryID: Int = 0
    var buyCount: Int = 0
    
    
    var courseSeriesID: Int = 0
    var parentSeriesID: Int = 0
    
    var courseType: Int = 0
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        categoryName <- map["categoryName"]
        seriesName <- map["seriesName"]
        
        price <- map["price"]
        parentSeriesName <- map["parentSeriesName"]
        categoryID <- map["categoryID"]
        thumbnailUrl <- map["thumbnailUrl"]
        basicPrice <- map["basicPrice"]
        bookID <- map["bookID"]
        
        courseSeriesID <- map["courseSeriesID"]
        parentSeriesID <- map["parentSeriesID"]
        previewImgUrl <- map["previewImgUrl"]
        productID <- map["productID"]
        productName <- map["productName"]
        buyCount <- map["buyCount"]
        courseType <- map["courseType"]
    }
    
}

/*
 var basicPrice: CGFloat = 0.0
 var categoryName: String = ""
 var seriesName: String = ""
 var bookID: Int = 0
 var productID: Int = 0
 var productName: String = ""
 var thumbnailUrl: String = ""
 var price: CGFloat = 0.0
 var parentSeriesName: String = ""
 var previewImgUrl: String = ""
 var categoryID: Int = 0
 
 
 
 var courseSeriesID: Int = 0
 var parentSeriesID: Int = 0
 
 
 required init?(map: Map) {
 }
 
 func mapping(map: Map) {
 categoryName <- map["categoryName"]
 seriesName <- map["seriesName"]
 
 price <- map["price"]
 parentSeriesName <- map["parentSeriesName"]
 categoryID <- map["categoryID"]
 thumbnailUrl <- map["thumbnailUrl"]
 basicPrice <- map["basicPrice"]
 bookID <- map["bookID"]
 
 courseSeriesID <- map["courseSeriesID"]
 parentSeriesID <- map["parentSeriesID"]
 previewImgUrl <- map["previewImgUrl"]
 productID <- map["productID"]
 productName <- map["productName"]
 }
 */

