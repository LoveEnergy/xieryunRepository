//
//  PayHelper.swift
//  KuTing
//
//  Created by Maynard on 2018/4/12.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

enum AliPayResult: Int32 {
    case success = 9000
    case cancle = 6001
    case failure
}

class PayHelper: NSObject {
    static let shared = PayHelper()
    
    fileprivate var endpointClosure = { (target: PayAPI) -> Endpoint in
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    private lazy var provider = MoyaProvider<PayAPI>(endpointClosure: self.endpointClosure, plugins: plugins())
    
    let disposeBag = DisposeBag()
    
    func getAliPayInfo(amount: String, orderID: String) -> Observable<AliOrderInfoModel> {
        return provider.rx.request(PayAPI.getAliPayInfo(amount: amount, orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: AliOrderInfoModel.self)
    }
    
    func getAliPayParaInfo(amount: String, orderID: String) -> Observable<BaseInfoModel<PaySignModel>> {
        return UserHelper.shared.getPayInfo(orderID: orderID, type: "4")
    }
    
    func getWechatInfo(orderID: String) -> Observable<BaseInfoModel<PaySignModel>> {
        return UserHelper.shared.getPayInfo(orderID: orderID)
    }
    
    func balancePay(amount: String, orderID: String) -> Observable<BaseModel> {
        return provider.rx.request(PayAPI.balancePay(amount: amount, orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func recharge(amount: String, type: String, orderID: String) -> Observable<BaseModel> {
        return provider.rx.request(PayAPI.recharge(amount: amount, type: type, orderID: orderID))
            .filterSuccessfulStatusCodes()
            .mapJSON()
            .asObservable()
            .mapObject(type: BaseModel.self)
    }
    
    func wechatPay(model: WeChatOrderModel) {
        let request = PayReq()
        request.openID = model.appid
        request.partnerId = model.mch_id
        request.prepayId = model.prepay_id
        request.package = "Sign=WXPay"
        request.nonceStr = model.nonce_str
        let time = UInt32(model.timestamp) ?? 0
        request.timeStamp = time
        request.sign = model.sign

        WXApi.send(request) { (result) in
            if result == true{
                print("成功")
            }else{
                print("失败")
            }
        }
        
//        request.timeStamp = [dic[@"timestamp"] intValue];
        
//        ShareSDK.authorize(.typeWechat, settings: nil) { (state, user, error) in
//            switch state
//            {
//            case .success:
//                print("Success:%@",user?.dictionaryValue() ?? "");
//            case .fail:
//                print("Fail:%@",error ?? "");
//            case .cancel:
//                print("Cancel");
//            default : break
//            }
//        }
    }
    
    func aliPay(paras: String,
                successBlock: ((String) -> Void)?,
                failureBlock: ((String) -> Void)?) {
       
        
       
        AlipaySDK.defaultService().payOrder(paras, fromScheme: "ceischool") { (dic) in
            
            if let dic = dic as? [String: Any], let resultCode: Int32 = dic["resultStatus"] as? Int32 {
                switch resultCode {
                case AliPayResult.success.rawValue:
                    successBlock?("支付成功")
                case AliPayResult.cancle.rawValue:
                    failureBlock?("支付取消")
                default:
                    failureBlock?("支付失败")
                }
            }
        }
    }
    
}
