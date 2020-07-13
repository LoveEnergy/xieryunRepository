//
//  AccountSettingViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/2.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import Alamofire

class AccountSettingViewController: UIViewController {
    var countTime: Int = 10
    let disposeBag = DisposeBag()
    var cellArray : [[String : String]] = [["title":"微信", "bindStatus":"0", "icon":"bind_weixin"], ["title":"手机", "bindStatus":"0", "icon":"bind_phone"]]
    var localPhoneNum: String = ""
    var timer: Timer?
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - 80/WIDTH_6_SCALE - CGFloat(NAVI_HEIGHT) - 60/WIDTH_6_SCALE))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60/WIDTH_6_SCALE
        tableView.register(AccountSettingTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(AccountSettingTableViewCell.self))
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60/WIDTH_6_SCALE))
        let titleLab = UILabel.init(frame: CGRect(x: 35.5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH, height: headerView.height))
        titleLab.text = "以下账号绑定成功后可用于登录"
        titleLab.font = DEF_FontSize_14
        titleLab.textColor = UIColor.ColorHex("7a7979")
        headerView.addSubview(titleLab)
        headerView.backgroundColor = .white
        return headerView
    }()
    
    lazy var bindPhoneView : BindPhoneView = {
        var bindPhoneView = BindPhoneView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        bindPhoneView.bindPhoneViewDismissBlock = {
            self.bindPhoneView.sendCodeBtn.isUserInteractionEnabled = true
            self.bindPhoneView.sendCodeBtn.setTitle("发送验证码", for: .normal)
            self.countTime = 10
            self.timer?.invalidate()
            self.timer = nil
            UIView.animate(withDuration: 0.15, animations: {
                self.bindPhoneView.alpha = 0
            }) { (Bool) in
                self.bindPhoneView.removeFromSuperview()
            }
        }
        bindPhoneView.sendCodeBlock = {(phoneString) in
            //获取验证码
            HUD.loading(text: "")
            UserHelper.shared.getCode(phone: phoneString).asObservable()
                .subscribe(onNext: {[weak self] (model) in
                    HUD.hideLoading()
                    guard let `self` = self else { return }
                    if model.code == 200{
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerCountTime), userInfo: nil, repeats: true)
                        self.bindPhoneView.sendCodeBtn.isUserInteractionEnabled = false
                    }
                    }, onError: { (error) in
                        HUD.hideLoading()
                        HUD.showError(error: error.localizedDescription)
                })
                .disposed(by: self.disposeBag)
        }
        bindPhoneView.submitDataBlock = {(phoneString, codeString) in
            //验证验证码
            HUD.loading(text: "")
            UserHelper.shared.verifyCode(phone: phoneString, code: codeString).asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                if model.code == 200{
                    UserHelper.shared.bindPhone(phone: phoneString).asObservable().subscribe(onNext: { [weak self] (model) in
                        HUD.hideLoading()
                        guard let `self` = self else { return }
                        if model.code == 200{
                            HUD.showText(text: "操作成功")
                            UIView.animate(withDuration: 0.15, animations: {
                                self.bindPhoneView.alpha = 0
                            }) { (Bool) in
                                self.bindPhoneView.removeFromSuperview()
                            }
                        }else{
                            HUD.showText(text: model.message!)
                        }
                        }, onError: {(error) in
                            HUD.hideLoading()
                            HUD.showError(error: error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                }else{
                    HUD.showText(text: model.message!)
                }
                }, onError: { (error) in
                    HUD.hideLoading()
                    HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: self.disposeBag)
        }
        
        return bindPhoneView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "账号绑定管理"
        setUpUI()
        UserHelper.shared.getUserInfo()
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    guard let user = model.data else { return }
                    self.localPhoneNum = user.phone
                    if !user.wxThirdLoginID.isEmpty{
                        self.cellArray[0]["bindStatus"] = "1"
                    }
                    if !user.qqThirdLoginID.isEmpty{
                        self.cellArray[1]["bindStatus"] = "1"
                    }
                    self.tableView.reloadData()
                })
                
                }, onError: { (error) in
                    
            })
        .disposed(by: disposeBag)
    }
    
    func setUpUI(){
        self.view.addSubview(self.tableView)
        let labelBorder = 63/WIDTH_6_SCALE
        let label = UILabel.init(frame: CGRect(x: labelBorder, y: self.tableView.bottom, width: SCREEN_WIDTH - 2*labelBorder, height: SCREEN_HEIGHT - self.tableView.height))
        label.text = "1.每个手机/微信号不可重复绑定\n2.每个账号只能绑定一次，绑定成功后不可解绑"
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        label.backgroundColor = .white
        label.textColor = UIColor.colorWithHex(hex: "A4A3A3")
        label.font = DEF_FontSize_12
        self.view.addSubview(label)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
        self.timer = nil
    }
    
    @objc func timerCountTime(){
        if self.countTime != 1 {
            self.countTime = self.countTime - 1
            self.bindPhoneView.sendCodeBtn.isUserInteractionEnabled = false
            self.bindPhoneView.sendCodeBtn.setTitle("剩余\(self.countTime)秒", for: .normal)
        }else{
            self.bindPhoneView.sendCodeBtn.isUserInteractionEnabled = true
            self.bindPhoneView.sendCodeBtn.setTitle("发送验证码", for: .normal)
            self.countTime = 10
            self.timer?.invalidate()
            self.timer = nil
        }
    }
}

extension AccountSettingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(AccountSettingTableViewCell.self), for: indexPath) as! AccountSettingTableViewCell
        cell.model = self.cellArray[indexPath.row]
        cell.bindBtnBlock = {
            var type = SSDKPlatformType.typeWechat
            switch indexPath.row {
            case 0:
                type = .typeWechat
            case 1:
                type = .typeQQ
            default:
                break
            }
            if indexPath.row == 0 {
                ShareSDK.getUserInfo(type) { (state, user, error) in
                    switch state {
                    case .begin:
                        break
                    case .success:
                        if indexPath.row == 0 {
                            let model : SSDKUser = user!
                            let dataModel = model.credential.rawData
                            let tempString = dataModel?["unionid"]
                            if tempString is String, let x = tempString as? String {
                                print(x)
                                UserHelper.shared.thirdBind(type: 2, credential: x).asObservable().subscribe(onNext: {[weak self] (list) in
                                    guard let `self` = self else { return }
                                    if list != nil{
                                        if list.code == 4001{
                                            HUD.showText(text: "绑定失败")
                                        }else if list.code == 200{
                                            HUD.showText(text: "绑定成功")
                                            self.cellArray[0]["bindStatus"] = "1"
                                        }
                                        self.tableView.reloadData()
                                    }
                                }).disposed(by: self.disposeBag)
                            }
                        }
                    case .fail:
                        HUD.showError(error: error?.localizedDescription ?? "未知错误")
                    case .cancel:
                        HUD.showError(error: error?.localizedDescription ?? "未知错误")
                    case .upload:
                        break
                    }
                }
            }
            if indexPath.row == 1 {
                self.bindPhoneView.showView()
            }
        }
        cell.unbindBtnBlock = {
            if indexPath.row == 0 {
                UserHelper.shared.thirdUnbind(type: 2).asObservable().subscribe(onNext: {[weak self] (list) in
                    guard let `self` = self else { return }
                    if list != nil{
                        if list.code == 4001{
                            HUD.showText(text: "解绑失败")
                        }else if list.code == 200{
                            HUD.showText(text: "解绑成功")
                            self.cellArray[0]["bindStatus"] = "0"
                        }
                        self.tableView.reloadData()
                    }
                }).disposed(by: self.disposeBag)
            }
            if indexPath.row == 1 {
                
            }
        }
        if indexPath.row == 1 {
            if self.localPhoneNum.isEmpty {
                cell.bindBtn.setTitle("绑定", for: .normal)
            }else{
                cell.bindBtn.setTitle("换绑", for: .normal)
            }
        }
        return cell
    }    
}

