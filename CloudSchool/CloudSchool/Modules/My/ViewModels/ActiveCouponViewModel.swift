//
//  ActiveCouponViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActiveCouponViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String { return "优惠券" }
    var placeHolder: String { return "请输入优惠券编码" }
    
    let disposeBag = DisposeBag()
    
    var enabled: Variable<Bool> = Variable(false)
    var isRequesting: Variable<Bool> = Variable(false)
    var couponNumber: Variable<String> = Variable("")
    
    override init() {
        super.init()
        Observable.combineLatest(couponNumber.asObservable()
            .map{ return $0.count > 0 }, isRequesting.asObservable()) { (value1, value2) -> Bool in
                return value1 && !value2
        }
        .bind(to: enabled)
        .disposed(by: disposeBag)
        
        isRequesting.asObservable()
            .subscribe(onNext: { (value) in
                if value {
                    HUD.loading(text: "")
                } else {
                    HUD.hideLoading()
                }
            })
        .disposed(by: disposeBag)
    }
    
    func bindActiveAction(tap: ControlEvent<Void>) {
        tap.asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.activeCoupon()
            })
        .disposed(by: disposeBag)
    }
    
    func activeCoupon() {
        isRequesting.value = true
        self.perform(#selector(endRequest), with: nil, afterDelay: 2)
    }
    
    @objc func endRequest() {
        isRequesting.value = false
    }

}
