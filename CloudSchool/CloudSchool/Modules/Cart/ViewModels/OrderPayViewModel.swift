//
//  OrderPayViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderPayViewModel: NSObject {
    
    var orderID: String
    let disposeBag: DisposeBag = DisposeBag()
    var payModel: PaySignModel?
    var successBlock: ((Void) -> ())?
    var method: PaymentType = .wechat
    
    init(orderID: String) {
        self.orderID = orderID
        super.init()
        self.loadData()
    }
    
    func loadData() {
        UserHelper.shared.getPayInfo(orderID: self.orderID)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.payModel = model.data
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func requestPay() {
//        guard let model = self.payModel?.weixinParmeter else {
//            HUD.showError(error: "没有支付信息")
//            return
//        }
//
//        PaymentManager.shared.wechatPay(model: model, orderID: orderID, successBlock: { (string) in
//            self.successBlock?(())
//        }) { (string) in
//            HUD.showError(error: string)
//        }
        
        
        PaymentManager.shared.pay(type: self.method, money: "10", orderID: orderID, successBlock: { (text) in
            self.successBlock?(())
        }) { (error) in
            HUD.showError(error: error)
        }
        
        
    }

}
