//
//  FinishRegisterViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FinishRegisterViewController: UIViewController {
    
    @IBOutlet weak var finishButton: BaseButton!
    @IBOutlet weak var repasswordTextField: BaseTextField!
    @IBOutlet weak var passwordTextField: BaseTextField!
    
    var thirdLoginType: Int = 0
    var registerType: Int = 0//注册方式：0.点击注册按钮进入页面   1.点击第三方按钮进入页面
    
    var nickName: String = ""
    var headUrl: String = ""
    var credential: String = ""
    var phone: String?
    var code: String?
//    public var finishiRegisterBlock : (() -> ())?
    var isRegister: Bool = false
    
    var viewModel: SetPasswordViewModel!
    let disposeBag = DisposeBag()
    
    override var backgroundColor: UIColor {
        return .white
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let phone = phone, let code = code else {
            return
        }
        viewModel = SetPasswordViewModel(input:
            (phone: phone,
             code: code,
             nickName: nickName,
             headUrl: headUrl,
             type: thirdLoginType,
             credential: credential,
             password: passwordTextField.rx.text.orEmpty.asDriver(),
             repassword: repasswordTextField.rx.text.orEmpty.asDriver(),
             finishTaps: finishButton.rx.tap.asSignal(),
             isRegister:self.isRegister))
        if registerType == 0{
            bind()
        }else{
            thirdRegisterBind()
        }
    }
    
    func bind() {
        viewModel.finisheEnabled
            .asObservable()
            .bind(to: finishButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.finishResult
            .drive(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                if result.success {
                    self.dismiss(animated: true, completion: nil)
                    HUD.showText(text: "注册成功")
                    LoginHelper.shared.updateUserInfo()
                } else {
                    HUD.showError(error: result.message)
                }
            })
            .disposed(by: disposeBag)
    }
    
    func thirdRegisterBind() {
        viewModel.finisheEnabled
            .asObservable()
            .bind(to: finishButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        viewModel.thirdRegisterResult
            .drive(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                if result.success {
                    self.dismiss(animated: true, completion: nil)
                    HUD.showText(text: "注册成功")
                    LoginHelper.shared.updateUserInfo()
                } else {
                    HUD.showError(error: result.message)
                }
            })
            .disposed(by: disposeBag)
    }
}
