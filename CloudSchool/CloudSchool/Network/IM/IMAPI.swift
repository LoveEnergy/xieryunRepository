//
//  IMAPI.swift
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

enum IMAPI {
    case getChatRoomInfo(objectID: String)
    case getLiveClassInfo(pushUrl: String)
    case getUserListData(roomID: String)
    case getLiveClassListData
}

extension IMAPI: TargetType {
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
        case .getChatRoomInfo:
            return "/cei/get_em_chat_info"
        case .getLiveClassInfo:
            return "/cei/get_product_info_by_pushUrl"
        case .getUserListData(let roomID):
            return "/cei/get_em_online_users"
        case .getLiveClassListData:
            return "/cei/get_user_live_course"
        }
    }
    
    var method: Moya.Method {
        switch self {
//        case .uploadImage, .orderCoupons, .rechargeIAPOrder:
//            return .post
        default:
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        switch self {
        case .getChatRoomInfo(let objectID):
            dic["objectID"] = objectID
            break
        case .getLiveClassInfo(let pushUrl):
            dic["pushUrl"] = pushUrl
            break
        case .getUserListData(let roomID):
            dic["roomID"] = roomID
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
        default:
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
        
    }
}

