//
//  ModifyPasswordViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ModifyPasswordViewModel: NSObject {
    var finishEnabled: Variable<Bool> = Variable(false)
    var originalPassword: Variable<String> = Variable("")
    var newPassword: Variable<String> = Variable("")
    var repeateNewPassword: Variable<String> = Variable("")
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        Observable.combineLatest(newPassword.asObservable(), originalPassword.asObservable(), repeateNewPassword.asObservable()) { (newPasswordString, originalPasswordString, repeateNewPasswordString) -> Bool in
            return newPasswordString.count >= 6 && originalPasswordString.count >= 6 && repeateNewPasswordString.count >= 6
            }.bind(to: finishEnabled)
            .disposed(by: disposeBag)
    }
}
