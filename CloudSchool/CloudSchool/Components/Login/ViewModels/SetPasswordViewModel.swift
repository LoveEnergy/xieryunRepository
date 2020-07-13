//
//  SetPasswordViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/15.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SetPasswordViewModel: NSObject {
    let disposeBag = DisposeBag()

    var finisheEnabled: Driver<Bool>
    
    let finishResult: Driver<RequestResult>
    
    let thirdRegisterResult: Driver<RequestResult>
    init(input:(
        phone: String,
        code: String,
        nickName: String,
        headUrl: String,
        type: Int,
        credential: String,
        password:Driver<String>,
        repassword:Driver<String>,
        finishTaps:Signal<()>,
        isRegister: Bool)) {
        
        finisheEnabled = Driver.combineLatest(input.password, input.repassword, resultSelector: { (password, repassword) -> Bool in
            return (repassword == password && password.count >= 6 && repassword.count >= 6)
        }).asDriver()
        
        finishResult = input.finishTaps
            .withLatestFrom(Driver.combineLatest(input.password, input.repassword){ (password: $0, repassword: $1) })
            .flatMapLatest({ value in
                if input.isRegister {
                    return UserHelper.shared.register(phone: input.phone, password: value.password, code: input.code).map({ (model) -> RequestResult in
                        if let user = model.data {
                            UserDefaults.User.set(user.token, forKey: .token)
                            LoginHelper.saveLocalUser(user: user)
                        }
                        return model.errorDealResult()
                    })
                        .asDriver(onErrorJustReturn: (false, ""))
                } else {
                    return UserHelper.shared.resetPassword(phone: input.phone, password: value.password, code: input.code).map({ (model) -> RequestResult in
                        return model.errorDealResult()
                    })
                        .asDriver(onErrorJustReturn: (false, ""))
                }
                
            })
        
        thirdRegisterResult = input.finishTaps
        .withLatestFrom(Driver.combineLatest(input.password, input.repassword){ (password: $0, repassword: $1) })
        .flatMapLatest({ value in
            if input.isRegister {
                return UserHelper.shared.thirdRegister(phone: input.phone, password: value.password, code: input.code, nickName: input.nickName, headUrl: input.headUrl, type: input.type, credential: input.credential).map({ (model) -> RequestResult in
                    if let user = model.data {
                        UserDefaults.User.set(user.token, forKey: .token)
                        LoginHelper.saveLocalUser(user: user)
                    }
                    return model.errorDealResult()
                })
                    .asDriver(onErrorJustReturn: (false, ""))
            } else {
                return UserHelper.shared.resetPassword(phone: input.phone, password: value.password, code: input.code).map({ (model) -> RequestResult in
                    return model.errorDealResult()
                })
                    .asDriver(onErrorJustReturn: (false, ""))
            }
            
        })
    }
}
