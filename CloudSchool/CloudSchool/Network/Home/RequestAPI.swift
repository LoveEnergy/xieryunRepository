//
//  HomeAPI.swift
//  KuTing
//
//  Created by Maynard on 2018/3/26.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import Foundation
import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire
import SwifterSwift

enum RequestAPI {
    case banner()
    case teachers()
    case courses()
    case navigation(type: String, parentID: String)
    //子分类
    case subSeries(parentID: String, type: String)
    case hotSearch
    case search(name: String, pageNo: Int, pageSize: Int)
    
    //MARK: 课程体系
    case courseProductList(id: String, type: String, classType: String, seriesID: String, pageNo: String, pageSize: String)
    case thirdLevelProductList(parentID: String, seriesID: String, pageNo: String, pageSize: String)
    case productDetail(productID: String)
    //分类
    case courseSeriesList
    
    //MARK: 现场培训
    case trainList(pageNo: String, pageSize: String)
    
    case bookList(pageNo: String, pageSize: String)
    
    //MARK: 上传图片
    case uploadImage(_ image: UIImage, type: Int)
    
    //MARK: 资讯和专题
    //type:类型（1、专题页2、资讯页)
    case pageList(type: Int, pageNo: Int, pageSize: Int)
    case newsDetail(id: String)
    
    case recommendList(pageNo: Int, pageSize: Int, viewPageID: Int)
    
    case orderCoupons(productIDs: [String])
    case postInfoData
    
    //苹果支付
    case getIAPOrder(money: String, orderID: Int)
    case rechargeIAPOrder(poNumber: String, receiptData: [String: Any])
//    case rechargeIAPOrderString(poNumber: String, receiptData: String)
    //订单成功页面收到的数据
    case orderSuccess(orderID: String)
    
    //远程课程
    case remoteClass(pageNo: Int, pageSize: Int)
    case moreImageUpLoad(images: [UIImage], kind: Int)
    case welcomeInfo
    //苹果充值订单
    case iosRechargeOrder(money: String)
}

extension RequestAPI: TargetType {
    var headers: [String : String]? {
        var dic: [String: String] = [:]
        if let token = UserDefaults.User.string(forKey: .token)?.emptyToNil() {
            dic["token"] = token
        }
        switch self.method {
        case .post:
            dic["Content-type"] = "application/json"
        default:
            break
        }
        return dic
    }
    
    var baseURL: URL {
        return URL(string: Constant.serverBaseURL)!
    }
    
    var path: String {
        switch self {
        case .banner:
            return "/cei/front/get_picture_rotation"
//            return ""
        case .teachers:
            return "/cei/front/get_home_teacher"
        case .courses:
            return "/cei/front/get_floor_course_list"
        case .navigation:
//            return "/cei/front/get_navigation_list"
            return "/cei/front/get_course_series_list_by_data"
        case .subSeries:
//            return "/cei/front/get_second_series_list"
            return "/cei/front/get_course_series_list_by_data"
        case .courseProductList:
            return "/cei/front/search_series_product_list"
        case .thirdLevelProductList:
            return "/cei/front/search_navigation_child_list"
        case .trainList:
            return "/cei/front/search_train_class_list"
        case .bookList:
            return "/cei/front/get_book_list"
        case .uploadImage(_):
            return "/cei/upload_image"
        case .pageList:
            return "/cei/front/get_information_list"
        case .newsDetail:
            return "/cei/front/get_information_detail"
        case .productDetail(let productID):
            return "/cei/front/get_product_detail"
        case .recommendList:
            return "/cei/get_recommend_list"
        case .hotSearch:
            return ""
        case .orderCoupons(let productIDs):
            return "/cei/card_settlement"
        case .courseSeriesList:
            return "/cei/front/get_course_series_list"
        case .search:
            return "/cei/front/search_all_product"
        case .getIAPOrder:
            return "/cei/generate_recharge_order"
        case .rechargeIAPOrder:
            return "/cei/ios_recharge"
//        case .rechargeIAPOrderString:
//            return "/cei/ios_recharge"
        case .orderSuccess:
            return "/cei/get_order_message"
        case .remoteClass:
            return "/cei/front/search_remote_eclass_list"
        case .postInfoData:
            return "/cei/front/get_region_freight_list"
        case .moreImageUpLoad:
            return "/cei/upload_image_list"
        case .welcomeInfo:
            return "/cei/front/get_app_advertising"
        case .iosRechargeOrder:
            return "/cei/generate_recharge"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .uploadImage, .orderCoupons, .rechargeIAPOrder, .moreImageUpLoad:
            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        switch self {
        case .navigation(let type, let parentID):
            dic["parentID"] = parentID
            dic["type"] = type
        case .courseProductList(let id, let type, let classType, let seriesID, let pageNo, let pageSize):
            dic["parentID"] = id
            dic["type"] = type
            dic["classType"] = classType
            dic["seriesID"] = seriesID
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
            break
        case .thirdLevelProductList(let parentID, let seriesID, let pageNo, let pageSize):
            dic["parentID"] = parentID
            dic["seriesID"] = seriesID
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
            break
        case .subSeries(let parentID, let type):
            dic["parentID"] = parentID
            dic["type"] = type
        case .bookList(let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .pageList(let type, let pageNo, let pageSize):
//            dic["pageNo"] = pageNo
//            dic["pageSize"] = pageSize
//            dic["type"] = type
            break
        case .productDetail(let productID):
            dic["productID"] = productID
        case .recommendList(let pageNo, let pageSize, let viewPageID):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
            dic["viewPageID"] = viewPageID
            
        case .orderCoupons(let productIDs):
            dic["productIDs"] = productIDs.joined(separator: ",")
        case .newsDetail(let id):
            dic["informationID"] = id
        case .search(let name, let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
            dic["name"] = name
        case .trainList(let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .getIAPOrder(let money, let orderID):
            dic["money"] = money
            dic["orderID"] = orderID
        case .orderSuccess(let orderID):
            dic["orderID"] = orderID
        case .rechargeIAPOrder(let poNumber, let receipt_data):
            dic["poNumber"] = poNumber
            dic["receipt_data"] = receipt_data
//        case .rechargeIAPOrderString(let poNumber, let receiptData):
//            dic["poNumber"] = poNumber
//            dic["receipt_data"] = receiptData
        case .remoteClass(let pageNo, let pageSize):
            dic["pageNo"] = pageNo
            dic["pageSize"] = pageSize
        case .postInfoData:
            break
        case .iosRechargeOrder(let money):
            dic["money"] = money
            dic["mode"] = 1
        default:
            break
        }
        return dic
    }
    
    var sampleData: Data {
        return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
    }
    
    var task: Task {
        switch self {
        case .uploadImage(let image, let type):
            let data = (image.scaled(toWidth: 320)?.compressedData())!
            let imageData = MultipartFormData(provider: .data(data), name: "file", fileName: "hehe1.png", mimeType: "image/png")
            let typeData = MultipartFormData(provider: .data("1".data(using: .utf8)!), name: "kind")
            let multipartData = [imageData, typeData]
            let urlParameters = ["kind": type]
            return .uploadCompositeMultipart(multipartData, urlParameters: urlParameters)
            
        case .moreImageUpLoad(let images, let kind):
            var temp: [Moya.MultipartFormData] = [Moya.MultipartFormData]()
            for item in images {
                let data = (item.scaled(toWidth: 320)?.compressedData())!
                let time = NSTimeIntervalSince1970
                let imageData = MultipartFormData(provider: .data(data), name: "file", fileName: "\(time).png", mimeType: "image/png")
                temp.append(imageData)
            }
//            let typeData = MultipartFormData(provider: .data("1".data(using: .utf8)!), name: "kind")
//            temp.append(typeData)
            let urlParameters = ["kind": kind]
            return .uploadCompositeMultipart(temp, urlParameters: urlParameters)
        case .orderCoupons:
            return .requestParameters(parameters: self.parameters!, encoding: JSONEncoding.default)
        default:
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        
    }
}
