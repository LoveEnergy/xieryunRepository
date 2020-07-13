//
//  PaymentManager.swift
//  KuTing
//
//  Created by Maynard on 2018/3/21.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum PaymentType: String, CustomStringConvertible {
    case money = "3"
    case wechat = "1"
    case alipay = "2"
    
    var type: String {
        switch self {
        
        case .money:
            return "3"
        case .wechat:
            return "1"
        case .alipay:
            return "2"
        }
    }
    
    var description: String {
        switch self {
            
        case .money:
            return "余额"
        case .wechat:
            return "微信"
        case .alipay:
            return "支付宝"
        }
    }
    
    var icon: UIImage? {
        return nil
    }
    
}

enum WeChatPayResult: Int32, CustomStringConvertible {
    case success = 0    /**< 成功    */
    case errorCodeCommon = -1   /**< 普通错误类型    */
    case errorCodeUserCancel = -2   /**< 用户点击取消并返回    */
    case errorCodeSentFail   = -3   /**< 发送失败    */
    case errorCodeAuthDeny   = -4   /**< 授权失败    */
    case errorCodeUnsupport  = -5   /**< 微信不支持    */
    
    var description: String {
        switch self {
        
        case .success:
            return "支付成功"
        case .errorCodeCommon:
            return "普通错误类型"
        case .errorCodeUserCancel:
            return "支付取消"
        case .errorCodeSentFail:
            return "发送失败"
        case .errorCodeAuthDeny:
            return "授权失败"
        case .errorCodeUnsupport:
            return "微信不支持"
        }
    }
}

class PaymentManager: NSObject {
    
    static let shared = PaymentManager()
    let disposeBag: DisposeBag = DisposeBag()
    
    var wxPaySuccess: ((String) -> Void)?
    var wxPayError: ((String) -> Void)?
    
    var aliPaySuccess: ((String) -> Void)?
    var aliPayError: ((String) -> Void)?
    
    var orderID: String = ""
    
    class func register() {
//        WXApi.registerApp(AppID.WeChat.appID)
    }
    
    func handleAliPayResultURL(url: URL) {
        if url.host == "safepay" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dic) in
                self.dealResultAliPay(resultDic: dic)
            }
        }
        if url.host == "platformapi" {
            AlipaySDK.defaultService().processOrder(withPaymentResult: url) { (dic) in
                self.dealResultAliPay(resultDic: dic)
            }
        }
    }
    
    func dealResultAliPay(resultDic:[AnyHashable : Any]?){
        var orderID: String = self.orderID
        
        if let resultStatus = resultDic?["resultStatus"]! {
            if let statusCode = resultStatus as? String{
                var msg = "支付失败,请重新支付！"
                switch statusCode {
                case "9000":
                    msg = "支付成功！"
                    //显示成功信息，更新具体数据，返回订单记录等等处理
                    
                    aliPaySuccess?(orderID)
                    return
                case "8000":
                    msg = "订单正在处理中，请留意订单记录列表!"
                case "4000":
                    msg = "支付失败,请重新购买套餐!"
                case "5000":
                    msg = "请勿重新请求!"
                case "6001":
                    
                    break
                //用户取消订单
                case "6002":
                    msg = "网络连接错误"
                default:
                    print(statusCode)
                }
                aliPayError?(msg)
                HUD.showText(text: msg)
            }
        }
    }
    
    func pay(type: PaymentType, money: String,
             orderID: String,
             successBlock: ((String) -> Void)?,
             failureBlock: ((String) -> Void)?) {
        
        switch type {
        case .money:
            moneyPay(money: money, orderID: orderID,    successBlock: successBlock,
                     failureBlock: failureBlock)
            
        case .alipay:
            aliPay(money: money, orderID: orderID, successBlock: successBlock, failureBlock: failureBlock)
            
        case .wechat:
            wechatPay(orderID: orderID, successBlock: successBlock, failureBlock: failureBlock)
            
        }
    }
    
    func moneyPay(money: String, orderID: String,           successBlock: ((String) -> Void)?,
                  failureBlock: ((String) -> Void)?) {
        
        PayHelper.shared.balancePay(amount: money, orderID: orderID)
        .asObservable()
            .subscribe(onNext: { (model) in
                model.errorDeal(successBlock: {
                    successBlock?("支付成功")
                })
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
                failureBlock?(error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func wechatPay(orderID: String,
                   successBlock: ((String) -> Void)?,
                   failureBlock: ((String) -> Void)?) {
        PayHelper.shared.getWechatInfo(orderID: orderID)
            .subscribe(onNext: { (result) in
                guard let model = result.data?.weixinParmeter else { return }
                
                if result.code == 0 {
                    failureBlock?(result.message ?? "未知错误")
                    HUD.showError(error: result.message ?? "未知错误")
                } else {
                    self.orderID = orderID
                    self.wxPaySuccess = successBlock
                    self.wxPayError = failureBlock
                    PayHelper.shared.wechatPay(model: model)
                }
            }, onError: { (error) in
                failureBlock?(error.localizedDescription)
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func wechatPay(model: WeChatOrderModel,
                   orderID: String,
                   successBlock: ((String) -> Void)?,
                   failureBlock: ((String) -> Void)?) {
        self.orderID = orderID
        self.wxPaySuccess = successBlock
        self.wxPayError = failureBlock
        PayHelper.shared.wechatPay(model: model)
    }
    
    func aliPay(money: String,
                orderID: String,
                successBlock: ((String) -> Void)?,
                failureBlock: ((String) -> Void)?) {
        PayHelper.shared.getAliPayParaInfo(amount: money, orderID: orderID)
            .subscribe(onNext: { (model) in
                
                if model.code != 200 {
                    failureBlock?(model.message ?? "未知错误")
                    HUD.showError(error: model.message ?? "未知错误")
                } else {
                    self.orderID = orderID
                    self.aliPaySuccess = successBlock
                    self.aliPayError = failureBlock
                    PayHelper.shared.aliPay(paras: model.data?.alipayParmeter ?? "", successBlock: successBlock, failureBlock: failureBlock)
                    
                }
            }, onError: { (error) in
                failureBlock?(error.localizedDescription)
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func handleOpenURL(url: URL) -> Bool {
        handleAliPayResultURL(url: url)
        return WXApi.handleOpen(url, delegate: self);
    }

}

extension PaymentManager: WXApiDelegate {
    func onResp(_ resp: BaseResp!) {
        if let response = resp as? PayResp {
            var error: String = "未知错误"
            if let value = WeChatPayResult(rawValue: response.errCode) {
                error = value.description
                HUD.showText(text: value.description)
            }
            switch response.errCode {
            case WeChatPayResult.success.rawValue:
                wxPaySuccess?(self.orderID)
                break
            case WeChatPayResult.errorCodeCommon.rawValue,
                 WeChatPayResult.errorCodeAuthDeny.rawValue,
                 WeChatPayResult.errorCodeSentFail.rawValue,
                 WeChatPayResult.errorCodeUnsupport.rawValue,
                 WeChatPayResult.errorCodeUserCancel.rawValue:
                wxPayError?(error)
                break
            default:
                break
                
            }
        }
    }
}
