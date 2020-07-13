//
//  LoginViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit

class LoginViewController: QMUICommonViewController {
    var unionid: String = ""
    var loginType: Int = 0//第三方类型（1、QQ2、微信）
    var registerType: Int = 0//0.点注册按钮跳页    1.点第三方按钮跳页
    
    @IBOutlet weak var wxLoginBtn: UIButton!
    @IBOutlet weak var qqLoginBtn: UIButton!
    var nickName: String = ""//昵称
    var headUrl: String = ""//

    @IBOutlet weak var passwordTextField: BaseTextField!
    @IBOutlet weak var phoneTextField: BaseTextField!
    @IBOutlet weak var loginButton: BaseButton!
    
    @IBOutlet weak var registerButton: UIButton!
    
    @IBOutlet weak var forgetButton: UIButton!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override var hideNavigationBar: Bool {
        return true
    }
    
    var viewModel: LoginViewModel!
    
    override var backgroundColor: UIColor { return .white }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        #if DEBUG
        self.qqLoginBtn.isHidden = true
        self.wxLoginBtn.isHidden = true
        if WXApi.isWXAppInstalled(){
            self.wxLoginBtn.isHidden = false
        }
        self.wxLoginBtn.centerX = SCREEN_WIDTH/2
        phoneTextField.text = ""
        passwordTextField.text = ""
        if UserDefaults.standard.object(forKey: "loginNum") != nil {
            phoneTextField.text = UserDefaults.standard.object(forKey: "loginNum") as! String
            passwordTextField.text = UserDefaults.standard.object(forKey: "loginPassword") as! String
        }
        #else
        
        #endif
        
        viewModel = LoginViewModel(input:
            (phone: (phoneTextField.rx.text.orEmpty.asDriver()),
                                           password: passwordTextField.rx.text.orEmpty.asDriver(),
                                           loginTaps: loginButton.rx.tap.asSignal()))
        bind()
        
        (forgetButton.rx.tap)
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.showSetPassword(isRegister: false)
            })
        .disposed(by: disposeBag)
        
        (registerButton.rx.tap)
            .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.registerType = 0
                self.showSetPassword(isRegister: true)
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    func bind() {
        viewModel.loginEnabled.asObservable()
        .bind(to: loginButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        viewModel.loginResult
            .drive(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                if result.success {
                    self.dismiss(animated: true, completion: nil)
                    HUD.showText(text: "登录成功")
                    UserDefaults.standard.setValue(self.phoneTextField.text!, forKey: "loginNum")
                    UserDefaults.standard.setValue(self.passwordTextField.text!, forKey: "loginPassword")

                    LoginHelper.shared.updateUserInfo()
                } else {
                    HUD.showError(error: result.message)
                }
            })
        .disposed(by: disposeBag)
    }
    
    @objc func showSetPassword(isRegister: Bool) {
        if self.registerType == 0 {
            let vc = R.storyboard.login.registerViewController()!
            vc.isRegister = isRegister
            vc.inPageType = 0
            CurrentControllerHelper.pushViewController(viewController: vc)
        }else{
            UserHelper.shared.thirdLogin(unionid: self.unionid, type: self.loginType)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list != nil{
                    if list.code == 4001{
                        let vc = R.storyboard.login.registerViewController()!
                        vc.isRegister = isRegister
                        vc.inPageType = 1
                        vc.thirdLoginType = self.loginType
                        vc.unionid = self.unionid
                        vc.nickName = self.nickName
                        vc.headUrl = self.headUrl
                        CurrentControllerHelper.pushViewController(viewController: vc)
                    }else if list.code == 200{
                        UserDefaults.User.set(list.data?.token ?? "", forKey: .token)
//                        UserDefaults.User.set(list.data?.isMember ?? 0, forKey: .isMember)
                        let workGroup = DispatchGroup.init()
                        let workingQueue = DispatchQueue(label: "login_queue")
                        workGroup.enter()
                        workingQueue.async {
                            LoginHelper.shared.updateUserInfo()
                            // 出组
                            workGroup.leave()
                        }
                        // 调度组里的任务都执行完毕
                        workGroup.notify(queue: workingQueue) {
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        }
    }
    
    
    @IBAction func thirdLogin(_ sender: UIButton) {
        self.registerType = 1
        var type = SSDKPlatformType.typeWechat
        switch sender.tag {
        case 0:
            type = .typeQQ
        case 1:
            type = .typeSinaWeibo
        default:
            break
        }
        ShareSDK.getUserInfo(type) { (state, user, error) in
            switch state {
            case .begin:
                break
            case .success:
                if sender.tag == 2 {
                    self.loginType = 2
                    let model : SSDKUser = user!
                    let dataModel = model.credential.rawData
                    let tempString = dataModel?["unionid"]
                    if tempString is String, let x = tempString as? String {
                        print(x)
                        self.unionid = x
                        self.nickName = model.nickname
                        self.headUrl = model.icon
                    }
                }
                self.showSetPassword(isRegister: true)
            case .fail:
                HUD.showError(error: error?.localizedDescription ?? "未知错误")
            case .cancel:
                HUD.showError(error: error?.localizedDescription ?? "未知错误")
            case .upload:
                break
            }
        }
    }
    
}
