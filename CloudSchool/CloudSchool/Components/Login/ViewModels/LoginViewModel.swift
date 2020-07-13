//
//  LoginViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewModel: NSObject {
    let disposeBag = DisposeBag()
    var loginEnabled: Driver<Bool>
    let loginResult: Driver<RequestResult>
    
    init(input:(
        phone: Driver<String>,
        password:Driver<String>,
        loginTaps:Signal<()>)) {
        
        loginEnabled = Driver.combineLatest(input.phone, input.password, resultSelector: { (phone, password) -> Bool in
//            return phone.count >= 6 && password.count >= 6//登录判断输入条件
            #warning("登录判断输入条件，上架修改")
            return phone.count >= 1 && password.count >= 1
        }).asDriver()
        
        
        loginResult = input.loginTaps
            .withLatestFrom(Driver.combineLatest(input.phone, input.password){ (phone: $0, password: $1) })
            .flatMapLatest({ value in
                return UserHelper.shared.login(name: value.phone, password: value.password).do(onNext: { (info) in
                    if info.code == 200, let model = info.data {
                        UserDefaults.User.set(model.token, forKey: .token)
                        UserDefaults.User.set(model.isMember, forKey: .isMember)
                        if let jsonString = info.data?.toJSONString() {
                            let user = UserInfo(JSONString: jsonString)!
                            LoginHelper.saveLocalUser(user: user)
//                            LoginHelper.shared.updateUserInfo()
                        }
                    }
                }).map({ (model) -> (Bool, String) in
                    return model.errorDealResult()
                })
                .asDriver(onErrorJustReturn: (false, ""))
            })
    }
}
