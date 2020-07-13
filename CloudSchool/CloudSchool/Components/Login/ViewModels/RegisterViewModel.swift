//
//  GetCodeViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Result

class RegisterViewModel: NSObject {
    let maxSeconds = 10
    let disposeBag = DisposeBag()
    let codeDisposeBag = DisposeBag()
    
    var phone: Variable<String> = Variable("")
    var code: Variable<String> = Variable("")
    var countDownEnded: Variable<Bool> = Variable(true)
    var getCodeButtonTitle: Variable<String> = Variable("获取验证码")
    var registerEnabled: Driver<Bool>
    var getCodeEnabled: Driver<Bool>
    
    let getCodeResult: Driver<Bool>
    let verifyResult: Driver<Bool>
    
    var protocolSelected: Variable<Bool> = Variable(false)
    init(input:(phone:Driver<String>,code:Driver<String>,getCodeTaps:Signal<()>, registerTaps:Signal<()>, protocolTaps:Signal<()>)) {
        
//        getCodeEnabled = Driver.combineLatest(countDownEnded.asObservable(), input.phone.map({ (phone) -> Bool in
//            return phone.count == 11
//        }), resultSelector: { (phoneValid, codeValid) -> Bool in
//            return phoneValid && codeValid
//        }).asDriver()
        getCodeEnabled = Driver.combineLatest(countDownEnded.asDriver(), input.phone.map({ (phone) -> Bool in
            return phone.count == 11
        }), resultSelector: { (v1, v2) -> Bool in
            return v1 && v2
        }).asDriver()
        
        registerEnabled = Driver.combineLatest(getCodeEnabled, input.code.map({ (code) -> Bool in
            return code.count >= 6
        }), protocolSelected.asDriver(), resultSelector: { (phoneValid, codeValid, selected) -> Bool in
            return phoneValid && codeValid && selected
        }).asDriver()
        
         getCodeResult = input.getCodeTaps
            .withLatestFrom(input.phone)
            .flatMapLatest { phone  in
                return UserHelper.shared.getCode(phone: phone).map({ (model) -> Bool in
                    if model.code == 200 {
                        
                        return true
                    } else {
                        return false
                    }
                    
                }).asDriver(onErrorJustReturn: false)
        }
        
        verifyResult = input.registerTaps
            .withLatestFrom(Driver.combineLatest(input.phone, input.code){ (phone: $0, code: $1) })
            .flatMapLatest({ value in
                return UserHelper.shared.verifyCode(phone: value.phone, code: value.code).map({ (model) -> Bool in
                    return true
                })
                .asDriver(onErrorJustReturn: false)
            })
        
        super.init()
        input.protocolTaps.asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.protocolSelected.value = !self.protocolSelected.value
            })
        .disposed(by: disposeBag)
        
        getCodeResult.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.startTimer()
            })
        .disposed(by: disposeBag)
    }
    
    func startTimer() {
        let object = Observable<Int>.interval(1, scheduler: MainScheduler.instance).take(11)
        object.map { (value) -> (Bool, String) in
            return (value >= self.maxSeconds,"\(self.maxSeconds - value)s")
            }
            .subscribe(onNext: {[weak self] (enable, text) in
                guard let `self` = self else { return }
                if enable {
                    self.getCodeButtonTitle.value = "获取验证码"
                    self.countDownEnded.value = true
                } else {
                    self.getCodeButtonTitle.value = text
                    self.countDownEnded.value = false
                }
            })
            .disposed(by: codeDisposeBag)
    }
}
