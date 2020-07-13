//
//  RegisterViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//import <CommonCrypto/CommonDigest.h>
import CommonCrypto
class RegisterViewController: UIViewController {
    @IBOutlet weak var checkView: UIView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var protocolButton: URLButton!
    override var backgroundColor: UIColor { return .white }

    @IBOutlet weak var getCodeButton: BaseButton!
    @IBOutlet weak var codeInputView: BaseInputView!
    @IBOutlet weak var phoneInputView: BaseInputView!
    
    @IBOutlet weak var nextButton: BaseButton!
    var inPageType: Int = 0//0.点注册账号进入页面   1.点第三方按钮进入页面
    var thirdLoginType = 0//第三方类型（1、QQ2、微信）
    var unionid: String = ""//credential
    var nickName: String = ""//
    var headUrl: String = ""//
    var isRegister: Bool = false
    
    lazy var viewModel: RegisterViewModel = {
        let vm = RegisterViewModel(input:
            (phone: phoneInputView.textField.rx.text.orEmpty.asDriver(),
             code: codeInputView.textField.rx.text.orEmpty.asDriver(),
             getCodeTaps: getCodeButton.rx.tap.asSignal(),
             registerTaps: nextButton.rx.tap.asSignal(),
             protocolTaps: checkButton.rx.tap.asSignal()))
        return vm
    }()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        bind()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIView.animate(withDuration: 0.15, animations: {
            self.bindOldAccountAlertView.alpha = 0
            self.bindExistAccountAlertView.alpha = 0
        }) { (Bool) in
            self.bindOldAccountAlertView.removeFromSuperview()
            self.bindExistAccountAlertView.removeFromSuperview()
        }
    }
    
    lazy var bindOldAccountAlertView : BindOldAccountAlertView = {
        var bindOldAccountAlertView = BindOldAccountAlertView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bindOldAccountAlertView.bindOldAccountAlertCancelBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.bindOldAccountAlertView.alpha = 0
            }) { (Bool) in
                self.bindOldAccountAlertView.removeFromSuperview()
            }
            //三方在平台不存在账号，请跳转输入密码页面
            let vc = R.storyboard.login.finishRegisterViewController()!
            vc.isRegister = self.isRegister
            vc.phone = self.phoneInputView.textField.text
            vc.code = self.codeInputView.textField.text
            vc.registerType = self.inPageType
            vc.thirdLoginType = self.thirdLoginType//第三方登录的类型
            vc.credential = self.unionid
            vc.nickName = self.nickName
            vc.headUrl = self.headUrl
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        bindOldAccountAlertView.bindOldAccountAlertSureBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.bindOldAccountAlertView.alpha = 0
            }) { (Bool) in
                self.bindOldAccountAlertView.removeFromSuperview()
            }
            self.bindExistAccountAlertView.showView()
        }
        return bindOldAccountAlertView
    }()
    
    lazy var bindExistAccountAlertView : BindExistAccountAlertView = {
        var bindExistAccountAlertView = BindExistAccountAlertView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bindExistAccountAlertView.bindExistAccountAlertSureBlock = {(loginName, password) in
            //type:第三方类型（1、QQ 2、微信）
            UserHelper.shared.thirdOldAccount(type: 2, credential: self.unionid, loginName: loginName, password: (self.md5(strs: password)?.uppercased())!, phone: self.phoneInputView.textField.text!).asObservable()
            .subscribe(onNext: {[weak self] (object) in
                guard let `self` = self else { return }
                if object.code == 200, let model = object.data {
                    if let user = object.data {
                        UserDefaults.User.set(user.token, forKey: .token)
                        LoginHelper.saveLocalUser(user: user)
                        self.dismiss(animated: true, completion: nil)
                        LoginHelper.shared.updateUserInfo()
                    }
                }
            }).disposed(by: self.disposeBag)
        }
        bindExistAccountAlertView.bindExistAccountAlertCancelBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.bindExistAccountAlertView.alpha = 0
            }) { (Bool) in
                self.bindExistAccountAlertView.removeFromSuperview()
            }
        }
        return bindExistAccountAlertView
    }()
    
    func configureUI() {
        title = "手机注册"
        phoneInputView.placeHolder = "手机/邮箱"
        codeInputView.placeHolder = "验证码"
        
        protocolButton.url = Constant.userProtocolURL
        
        phoneInputView.type = .gray
        codeInputView.type = .gray
        
    }
    
    func bind() {
        if !isRegister {
            viewModel.protocolSelected.value = true
            self.checkView.isHidden = true
            self.title = "密码修改"
        }
        viewModel.getCodeEnabled
        .asObservable()
        .bind(to: getCodeButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        viewModel.registerEnabled
        .asObservable()
        .bind(to: nextButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        viewModel.protocolSelected
        .asObservable()
        .bind(to: checkButton.rx.isSelected)
        .disposed(by: disposeBag)
        
        viewModel.getCodeResult
            .drive(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                if value {
                    HUD.showText(text: "获取验证码成功")
                } else {
                    HUD.showError(error: "获取失败")
                }
            })
        .disposed(by: disposeBag)
        
        viewModel.verifyResult
            .drive(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                if self.inPageType == 1{
                    if value {
                        UserHelper.shared.thirdCheckCode(phone: self.phoneInputView.textField.text!, code: self.codeInputView.textField.text!, type: self.thirdLoginType, credential: self.unionid).asObservable()
                        .subscribe(onNext: {[weak self] (object) in
                            guard let `self` = self else { return }
                            let model : BaseModel = object
                            if model.code == 4003{
                                //该手机号已被绑定
                                HUD.showError(error: object.message!)
                            }else if model.code == 200{
                                //已有账号直接绑定
                                self.dismiss(animated: true, completion: nil)
                                LoginHelper.shared.updateUserInfo()
                            }else if model.code == 4002{
                                self.bindOldAccountAlertView.showView()
                            }
                            }, onError: { (error) in
                                HUD.showError(error: error.localizedDescription)
                        }).disposed(by: self.disposeBag)
                    } else {
                        HUD.showError(error: "验证码错误")
                    }
                }else{
                    //非第三方注册
                    let vc = R.storyboard.login.finishRegisterViewController()!
                    vc.isRegister = self.isRegister
                    vc.phone = self.phoneInputView.textField.text
                    vc.code = self.codeInputView.textField.text
                    vc.registerType = self.inPageType
                    vc.thirdLoginType = self.thirdLoginType//第三方登录的类型
                    vc.credential = self.unionid
                    vc.nickName = self.nickName
                    vc.headUrl = self.headUrl
                    CurrentControllerHelper.pushViewController(viewController: vc)
                }
            })
        .disposed(by: disposeBag)
        
        viewModel.getCodeButtonTitle.asObservable()
        .bind(to: self.getCodeButton.rx.title(for: .normal))
        .disposed(by: disposeBag)
        
    }
    
    public func md5(strs:String) ->String!{
      let str = strs.cString(using: String.Encoding.utf8)
      let strLen = CUnsignedInt(strs.lengthOfBytes(using: String.Encoding.utf8))
      let digestLen = Int(CC_MD5_DIGEST_LENGTH)
      let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
      CC_MD5(str!, strLen, result)
      let hash = NSMutableString()
      for i in 0 ..< digestLen {
          hash.appendFormat("%02x", result[i])
      }
      result.deinitialize()
      return String(format: hash as String)
    }
}
