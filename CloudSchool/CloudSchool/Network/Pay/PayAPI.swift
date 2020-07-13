//
//  PayAPI.swift
//  KuTing
//
//  Created by Maynard on 2018/4/12.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import UIKit
import Foundation
import RxSwift
import Moya
import Alamofire

enum PayAPI {
    case recharge(amount: String, type: String, orderID: String)
    //余额支付
    case balancePay(amount: String, orderID: String)
    //注册
    case register(telephone: String, password: String, repassword: String, verifyCode: String)
    //获取微信订单
    case getWeChatInfo(amount: String)
    //获取支付宝订单
    case getAliPayInfo(amount: String, orderID: String)
    
}

extension PayAPI: TargetType {
    var headers: [String : String]? {
        return [:]
    }
    
    var baseURL: URL {
        return URL(string: Constant.serverBaseURL)!
    }
    
    var path: String {
        return ""
    }
    
    var method: Moya.Method {
        switch self {
        case .recharge, .balancePay, .register(_), .getAliPayInfo(_):
            return .get
        case .getWeChatInfo(_):
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        var dic:[String: Any] = [:]
        if let user = LoginHelper.shared.currentUser.value {
//            dic["uid"] = user.uid ?? ""
//            dic["token"] = user.token ?? ""
        }
        switch self {

        case .recharge(let amount, let type, let orderID):
            dic["r"] = "default/center/addmoney"
            dic["amount"] = amount
            dic["type"] = type
            dic["order_id"] = orderID
        case .balancePay(let amount, let orderID):
            dic["r"] = "default/homepage/pay"
            dic["money"] = amount
            dic["order_id"] = orderID
        case .register(let telephone, let password, let repassword, let verifyCode):
            dic["r"] = "default/myCarNumber/register"
            dic["telephone"] = telephone
            dic["password"] = password
            dic["code"] = verifyCode
            dic["repassword"] = repassword
            
        case .getWeChatInfo(let amount):
            dic["r"] = "default/wechat/getPrePayOrder"
            dic["total_fee"] = amount
            
        case .getAliPayInfo(let total_fee, let out_trade_no):
            dic["r"] = "default/commodity/alipay"
            dic["total_fee"] = total_fee
            dic["out_trade_no"] = out_trade_no
            
        default:
            break
        }
        return dic
    }
    
    var sampleData: Data {
        switch self {
        case .recharge, .balancePay:
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .register(_):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        case .getWeChatInfo, .getAliPayInfo(_):
            return "[{\"userId\": \"1\", \"Title\": \"Title String\", \"Body\": \"Body String\"}]".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
    }
}
