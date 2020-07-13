//
//  LoginHelper.swift
//  KuTing
//
//  Created by Maynard on 2018/3/21.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift
import Moya
import ObjectMapper
import UIKit
import Alamofire

//func JSONResponseDataFormatter(_ data: Data) -> Data {
//    do {
//        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
//        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
//        return prettyData
//    } catch {
//        return data
//    }
//}
//
//func plugins() -> [PluginType]{
//    var plugins: [PluginType] = [PluginType]()
//
//    #if DEBUG
//        plugins.append(NetworkLoggerPlugin(verbose: true, responseDataFormatter:JSONResponseDataFormatter ))
//
//        let activity =  NetworkActivityPlugin(networkActivityClosure: { (change, target) in
//            print(change)
//            print(target)
//        })
//        plugins.append(activity)
//    #endif
//
//    return plugins
//}
//
//var endpointClosure = { (target: LoginAPI) -> Endpoint in
//    return MoyaProvider.defaultEndpointMapping(for: target)
//}

class LoginHelper: NSObject {
    
    static let shared = LoginHelper()
    var currentUser: Variable<UserInfo?> = Variable(nil)
    var couponList: [GoodsCouponModel] = []
    
//
//
//    private let provider = MoyaProvider<LoginAPI>(endpointClosure: endpointClosure, plugins: plugins())
//
    let disposeBag = DisposeBag()
    
    static var isLogin: Bool {
        if let _ = LoginHelper.getLocalUser() {
            return true
        }
        return false
    }
    
    class func checkLoginStatus(completion: (() -> Void)?) {
        if LoginHelper.isLogin {
            completion?()
        } else {
            let loginVC = R.storyboard.login.instantiateInitialViewController()!
            CurrentControllerHelper.presentViewController(viewController: loginVC)
        }
    }
    
    class func getLoginStatus(completion: (() -> Void)?, noneLogin: (() -> Void)?) {
        if LoginHelper.isLogin {
            completion?()
        } else {
            noneLogin?()
        }
    }
    
    override init() {
        super.init()
        if let user = LoginHelper.getLocalUser() {
            self.currentUser.value = user
        }
        self.getCouponList()
    }
    
    func getCouponList() {
        UserHelper.shared.getCouponList(pageNo: 1, pageSize: 100, status: 1)
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.couponList = list.data?.rows ?? []
            })
        .disposed(by: disposeBag)
    }
    
    func haveCoupon(model: GoodsCouponModel, rule: RuleModel) -> Bool {
        return self.couponList.filter({ (object) -> Bool in
            return object.promotionID == model.promotionID && object.ruleID == rule.ruleID
        }).count > 0 ? true : false
    }
    
    func login(userName: String, password: String) -> Observable<Bool> {
        
        UserHelper.shared.getUserInfo()
            .subscribe(onNext: { (info) in
                if let jsonString = info.data?.toJSONString() {
                    let user = UserInfo(JSONString: jsonString)!
                    LoginHelper.saveLocalUser(user: user)
                    self.currentUser.value = user
                }
            })
        .disposed(by: disposeBag)
        let jsonString = """
    {"birthday":"2018-09-08","userID":1,"sex":0,"phone":"22222","email":"22222","nickName":"test11111","loginCount":1,"headUrl":"http://47.92.168.211/images/headPortrait/1535291592098.jpg","introduction":"22222","loginName":"test", "isMember":0}
"""
        return Observable.of(true)
    }
    
    func updateUserInfo() {
        UserHelper.shared.getUserInfo()
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    guard let user = model.data else { return }
                    self.currentUser.value = user
                    LoginHelper.saveLocalUser(user: user)
                    UMessage.addAlias("\(user.userID)", type: "CEI") { (responseObject, error) in
                        if error == nil{

                        }
                    }
                })
                
                }, onError: { (error) in
                    
            })
        .disposed(by: disposeBag)
    }
    
    func login(ssdkType: SSDKPlatformType) {
        ShareSDK.getUserInfo(ssdkType) { (state, user, error) in
            switch state {
                
            case .begin:
                break
            case .success:
                HUD.showText(text: "登录成功")
            case .fail:
                HUD.toast(error?.localizedDescription ?? "未知错误")
            case .cancel:
                HUD.toast(error?.localizedDescription ?? "未知错误")
            case .upload:
                break
            }
        }
    }
}

//本地存储
extension LoginHelper {
    class func saveLocalUser(user: UserInfo) {
        if let jsonString = user.toJSONString() {
            UserDefaults.User.set(jsonString, forKey: .localUserInfo)
        }
    }
    
    class func getLocalUser() -> UserInfo? {
        if let jsonString = UserDefaults.User.string(forKey: .localUserInfo) {
            let user = UserInfo(JSONString: jsonString)
            return user
        }
        return nil
    }
    
    class func logout(completion: (() -> Void)?) {
//        UserHelper.shared.logoutAccount()
//            .asObservable()
//            .subscribe(onNext: {[weak self] (model) in
//                guard let `self` = self else { return }
//
//
//                }, onError: { (error) in
//
//            })
//            .disposed(by: self.disposeBag)
        if let jsonString = UserDefaults.User.string(forKey: .localUserInfo) {
            let user = UserInfo(JSONString: jsonString)
            UMessage.removeAlias("\(String(describing: user!.userID))", type: "CEI") { (responseObject, error) in
            }
        }
        UserDefaults.standard.removeObject(forKey: UserDefaults.User.namespace(UserDefaults.User.StringDefaultKey.localUserInfo))
        UserDefaults.User.set("", forKey: .token)
        LoginHelper.shared.currentUser.value = nil
        completion?()
    }
}
