//
//  APIManager.swift
//  AsteroidVPN-iOS
//
//  Created by Asteroid on 2017/12/25.
//  Copyright © 2017年 Asteroid. All rights reserved.
//
import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire

enum API {
    //节点信息
    case servers
    //用户信息
    case userInfo(deviceID: String)
    //购买商品信息
    case productList
    //验证购买商品信息
    case verifyPurchase(receipt: String, transactionID: String, userID: String)
    //验证订阅信息
    case verifySubcribe(receipt: String, transactionID: String, originalTransactionID: String?, userID: String)
    //概率.引导页sid=1
    case probability(sID: String)
    //获取剩余流量
    case remainingTraffic(userID: String)
    //获取更新信息
    case updateInfo
    //恢复购买
    case restore(transactionID: String, userID: String)
    
}

extension API: TargetType {
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        return URL(string: Constant.serverBaseURL)!
    }
    
    var path: String {
        switch self {
        case .servers:
            return "/api/server/list"
        case .userInfo(_):
            return "/api/user"
        case .productList:
            return "/payment/product_list"
        case .verifyPurchase( _, _, _):
            return "/payment/apple_order_verify"
        case .verifySubcribe(_, _, _, _):
            return "/payment/apple_subscribe"
        case .probability(_):
            return "/api/switch"
        case .remainingTraffic(_):
            return "/api/getRemainingTraffic"
        case .updateInfo:
            return "api/app_version"
        case .restore(_, _):
            return "/api/order_recovery"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .servers, .userInfo(_), .productList, .probability(_),.remainingTraffic(_),.updateInfo:
            return .get
        case .verifyPurchase( _, _, _), .verifySubcribe(_, _, _, _),.restore(_, _):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        //pid: 产品id 固定为3,appstore 1.0版本为3
        var dic:[String: Any] = ["pl":"iOS",
//                   "lan":UIDevice.languageCode,
//                   "osv":UIDevice.systemVersionString,
//                   "avc":AppInfo.buildNumber,
//                   "did": UIDevice.UUID,
//                   "loc":UIDevice.countryCode,
                   "pid":"4"]
        switch self {
            case .userInfo(let deviceID):
                dic["did"] = deviceID
            case .verifyPurchase(let receipt, let transactionID, let userID):
                dic["receipt"] = receipt
                dic["transaction_id"] = transactionID
                dic["user_id"] = userID
            case .verifySubcribe(let receipt, let transactionID, let originalTransactionID, let userID):
                dic["receipt"] = receipt
                dic["transaction_id"] = transactionID
                dic["user_id"] = userID
                if let originalID = originalTransactionID {
                    dic["original_ransaction_id"] = originalID
                }
            case .probability(let sID):
                dic["sid"] = sID
            case .remainingTraffic(let userID):
                let timeZone = UIDevice.timeZone.identifier
                dic["user_id"] = userID
                dic["time_zone"] = timeZone
            case .restore(let transactionID, let userID):
                dic["transaction_id"] = transactionID
                dic["user_id"] = userID
            default:
                break
        }
        return dic
    }
    
    var sampleData: Data {
        switch self {
        case .servers,.probability(_),.remainingTraffic(_),.updateInfo, .restore(_, _):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .userInfo(_):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .productList, .verifyPurchase(_, _, _),.verifySubcribe(_, _, _, _):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
    }
}

protocol NetworkResultProtocol {
    var message: String? { get set }
    var code: Int { get set }
    
    func errorDeal(successBlock:(() -> Void)?)
}

extension NetworkResultProtocol {
    func errorDeal(successBlock:(() -> Void)?) {
        if self.code == 0 {
            HUD.showError(error: self.message ?? "未知错误")
        } else if self.code == 200 {
            successBlock?()
        }else if(self.code == 401) {
            if LoginHelper.isLogin {
                HUD.showError(error: "账号在其他设备登录，请重新登录")
            }
            LoginHelper.logout(completion: nil)
        } else if let message = self.message {
            HUD.showError(error: message)
        } else {
//            successBlock?()
            HUD.showError(error: self.message ?? "未知错误")
        }
    }
    
    func errorDealResult() -> RequestResult {
        if self.code == 200 {
            return (true, self.message ?? "")
        } else {
            return (false, self.message ?? "")
        }
    }
}
