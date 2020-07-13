//
//  UserInfoViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/12.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum UserInfoInputType {
    case nickName(value: String)
    case email(value: String)
    
    var key: String {
        switch self {
        case .nickName:
            return "nickName"
        case .email:
            return "email"
        }
    }
    
    var title: String {
        switch self {
        case .nickName:
            return "请输入昵称"
        case .email:
            return "请输入邮箱地址"
        }
    }
    
    var placeHolder: String {
        switch self {
        case .nickName:
            return "昵称"
        case .email:
            return "邮箱地址"
        }
    }
    
    var value: String {
        switch self {
        case .nickName(let value):
            return value
        case .email(let value):
            return value
        }
    }
}

class UserInfoViewModel: NSObject {
    var type: UserInfoInputType
    
    let disposeBag: DisposeBag = DisposeBag()
    
    init(type: UserInfoInputType) {
        self.type = type
        super.init()
        
    }
    
    func clickToChange() {
        let view = UserInfoInputView.loadXib()
        view.title = self.type.title
        view.textInputView.textField.placeholder = self.type.placeHolder
        
        view.sureBlock = { text in
            
            self.requestChange(text: text)
        }
        view.popShow()
    }
    
    func requestChange(text: String) {
        switch self.type {
        case .nickName:
            UserHelper.shared.updateUserInfo(dic: [self.type.key: text])
            .asObservable()
                .subscribe(onNext: { (model) in
                    LoginHelper.shared.updateUserInfo()
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
                })
            .disposed(by: disposeBag)
        case .email:
            UserHelper.shared.updateUserContactsInfo(dic: [self.type.key: text])
                .asObservable()
                .subscribe(onNext: { (model) in
                    LoginHelper.shared.updateUserInfo()
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
                })
                .disposed(by: disposeBag)
            break
        }
    }
    
    
    
    
}
