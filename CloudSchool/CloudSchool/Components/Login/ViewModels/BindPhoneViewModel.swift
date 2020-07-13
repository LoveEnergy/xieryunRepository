//
//  BindPhoneViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class BindPhoneViewModel: NSObject {
    var bindabled: Variable<Bool> = Variable(false)
    var code: Variable<String> = Variable("")
    var phone: Variable<String> = Variable("")
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        Observable.combineLatest(phone.asObservable(), code.asObservable()) { (phoneString, codeString) -> Bool in
            return phoneString.count == 11 && codeString.count >= 6
            }.bind(to: bindabled)
            .disposed(by: disposeBag)
    }
}
