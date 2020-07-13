//
//  AppDelegate.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/10.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import HyphenateLite
import UserNotificationsUI
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WXApiDelegate, UNUserNotificationCenterDelegate {
    var backgroundTime: Timer?
    var bgTask: UIBackgroundTaskIdentifier?
    var backgroundSessionCompletionHandler : (() -> Void)?
    var window: UIWindow?
    var isPushOpen: Bool = false//判断是否点击推送打开软件
    var loadTimes: Int = 1
    var openType: String = ""
    var title: String = ""
    var url: String = ""
    var productID: String = ""
    var productType: String = ""
    //当前界面支持的方向（默认情况下只能竖屏，不能横屏显示）
    var interfaceOrientations:UIInterfaceOrientationMask = .portrait{
        didSet{
            //强制设置成竖屏
            if interfaceOrientations == .portrait{
                UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue,
                                          forKey: "orientation")
            }
            //强制设置成横屏
            else if !interfaceOrientations.contains(.portrait){
                UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
            }
        }
    }
    
    //返回当前界面支持的旋转方向
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor
        window: UIWindow?)-> UIInterfaceOrientationMask {
        return interfaceOrientations
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = storyBoard.instantiateInitialViewController()
        UIApplication.shared.registerForRemoteNotifications()
        UIConfigure.navgationBar()
        UmengHelper.configure()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 120
        UIViewController.swizzle()
        PaymentManager.register()
        ShareHelper.register()
        iapConfig()
        IMFunction()
        self.loadTimes = 2
        // Push组件基本功能配置
        let entity = UMessageRegisterEntity.init()
        //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = Int(UMessageAuthorizationOptions.badge.rawValue | UMessageAuthorizationOptions.sound.rawValue | UMessageAuthorizationOptions.alert.rawValue)
        UNUserNotificationCenter.current().delegate = self
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted{
                
            }else{
                
            }
        }
        UMessage.openDebugMode(true)
        UMessage.addLaunch()
        UMCommonLogManager.setUp()
        UMConfigure.setLogEnabled(true)
        
        //引导页用
        // 得到当前应用的版本号
        let infoDictionary = Bundle.main.infoDictionary
        let currentAppVersion = infoDictionary!["CFBundleShortVersionString"] as! String
        
        // 取出之前保存的版本号
        let userDefaults = UserDefaults.standard
        let appVersion = userDefaults.string(forKey: "appVersion")
        
        //时间戳
        let timeStamp = self.getNowTimeStamp()
        
        // 如果 appVersion 为 nil 说明是第一次启动；如果 appVersion 不等于 currentAppVersion 说明是更新了
        if appVersion == nil || appVersion != currentAppVersion {
            // 保存最新的版本号
            userDefaults.setValue(currentAppVersion, forKey: "appVersion")
            let guideViewController = GuideViewController.init()
            self.window?.rootViewController = guideViewController
            self.window?.makeKeyAndVisible()
        }else{
            if self.isPushOpen == true{
                self.window?.rootViewController = vc
                self.window?.makeKeyAndVisible()
            }else{
                var imageUrlString = ""
//                if Is_Iphone_X {
//                    imageUrlString = "http://data.cei.net.cn/images/appAdvertisement/appAdvertisementX.jpg"
//                }else{
                imageUrlString = "http://data.cei.net.cn/images/appAdvertisement/appAdvertisement.jpg?time=\(timeStamp)"
//                }
                
                WZXLaunchViewController.show(withFrame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT), imageURL: URL.init(string: imageUrlString), advertisingURL: nil, timeSecond: 10, hideSkip: false, imageLoadGood: { (image, imageURL) in
                }, clickImage: { (WZXlaunchVC) in
                    if self.isPushOpen{
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }else{
                        let welVc = WelcomeViewController.init()
                        let navVc = UINavigationController.init(rootViewController: welVc)
                        self.window?.rootViewController = navVc
                        self.window?.makeKeyAndVisible()
                        welVc.productDetailBlock = { (type, productID) in
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "toADVc"), object: nil, userInfo: ["type": type, "productID": productID])
                        }
                    }
                }) {
                    if self.isPushOpen{
                        if self.openType == "1" {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isPushOpen"), object: nil, userInfo: ["openType":self.openType, "productID":self.productID, "productType":self.productType])
                        }else{
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isPushOpen"), object: nil, userInfo: ["openType":self.openType, "url":self.url, "title":self.title])
                        }
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }else{
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                    }
                }
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        self.openServiceWhenBack()
    }
    
    func openServiceWhenBack(){
        let app = UIApplication.shared
        self.bgTask = app.beginBackgroundTask(expirationHandler: {
            app.endBackgroundTask(self.bgTask!)
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        })
        self.backgroundTime = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(applyForMoreTime), userInfo: nil, repeats: true)
        self.backgroundTime?.fire()
    }
    
    @objc func applyForMoreTime(){
        if UIApplication.shared.backgroundTimeRemaining < 60 {
            UIApplication.shared.endBackgroundTask(self.bgTask!)
            self.bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
                UIApplication.shared.endBackgroundTask(self.bgTask!)
                self.bgTask = UIBackgroundTaskIdentifier.invalid
            })
        }
    }
    func endBackgroundTask(){
        let app = UIApplication.shared
        app.endBackgroundTask(self.bgTask!)
        self.bgTask = UIBackgroundTaskIdentifier.invalid
        if (self.backgroundTime != nil) {
            self.backgroundTime?.invalidate()
            self.backgroundTime = nil
        }
    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        self.endBackgroundTask()
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return PaymentManager.shared.handleOpenURL(url: url)
    }


}

extension AppDelegate {
    /// 内购数据初始化
    func iapConfig(){
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = {(type) in
            if type == .purchased || type == .disabled || type == .restored || type == .failed {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
                    if type == .purchased || type
                        == .restored{
                        setSubscriptionStatusState(true)
                    }else{
                        setSubscriptionStatusState(false)
                    }
                })
                alertView.addAction(action)
                UIApplication.shared.delegate?.window??.rootViewController?.present(alertView, animated: true, completion: nil)
            }else if type == .verifyed{
                setSubscriptionStatusState(true)
            } else {
                setSubscriptionStatusState(false)
            }
        }
        
        #if DEBUG
        IAPHandler.shared.verifyPurchase(isForce: false)
        #else
        IAPHandler.shared.verifyPurchase(isForce: false)
        #endif
        
        
    }
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        return WXApi.handleOpenUniversalLink(userActivity, delegate: self as! WXApiDelegate)
    }
    
    func onReq(_ req: BaseReq) {
        if req.isKind(of: GetMessageFromWXReq.self) {
            WXApi.self
        }else if req.isKind(of: ShowMessageFromWXReq.self){
            
        }else if req.isKind(of: LaunchFromWXReq.self){
            
        }
    }
    
    func onResp(_ resp: BaseResp) {
        if resp.isKind(of: SendMessageToWXResp.self) {
            let sendResp = SendMessageToWXResp.init()
            let str = sendResp.errCode //数字
            if str == 0{
                
            }else{
                let alertView = UIAlertView.init(title: "回调信息", message: "\(str)", delegate: self, cancelButtonTitle: "确认")
                alertView.show()
            }
        }
        if resp.isKind(of: SendAuthResp.self) {
            let rep = SendAuthResp.init()
            if rep.errCode == 0 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: WXAuthorizationSuccess), object: ["code":rep.code])
            }
        }
        if resp.isKind(of: PayResp.self) {
            var payResoult = "errcode:\(resp.errCode)"
            switch resp.errCode {
            case 0:
                payResoult = "支付结果：成功！"
                let dict = ["key":"2"]
                let noti = Notification.init(name: Notification.Name(rawValue: WeChatReturnSucceedPayNotification), object: nil, userInfo: dict)
                NotificationCenter.default.post(noti)
            case 1:
                payResoult = "支付结果：失败！"
            case 2:
                payResoult = "用户已经退出支付！"
            default:
                payResoult = "支付结果：失败！retcode = \(resp.errCode), retstr = \(resp.errStr)"
            }
        }
    }
    func IMFunction(){
        let options = EMOptions.init(appkey: "1112191107030428#cei")
        options?.apnsCertName = "istore_dev"
        var error = EMClient.shared()?.initializeSDK(with: options)
        if error == nil {
            print("初始化成功")
        }
    }
    
    //获取deviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var deviceTokenString = String()
        let bytes = [UInt8](deviceToken)
        for item in bytes {
            deviceTokenString += String(format:"%02x", item&0x000000FF)
        }
        UMessage.registerDeviceToken(deviceToken)
//        UserDefaults.standard.set("\(deviceTokenString)", forKey: "deviceId")
        print("deviceTokenString:\(deviceTokenString)")
        if let userModel = LoginHelper.getLocalUser() {//已登录状态
            UMessage.addAlias("\(userModel.userID)", type: "CEI") { (responseObject, error) in
                if error == nil{

                }
            }
        }
    }
    //iOS10以下使用这两个方法接收通知，
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        UMessage.setAutoAlert(false)
        if Int(UIDevice.current.systemVersion)! < 10 {
            UMessage.didReceiveRemoteNotification(userInfo)
            completionHandler(UIBackgroundFetchResult.newData)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        //关闭友盟自带的弹出框
        UMessage.setAutoAlert(false)
        UMessage.didReceiveRemoteNotification(userInfo)
    }
    //iOS10新增：处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        self.isPushOpen = true
//        //在前台运行时，得到推送信号
//        let alert = UIAlertController(title: "3", message: nil, preferredStyle: .alert)
//        let accountLogin = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in }
//        //将Actiont加入到AlertController
//        alert.addAction(accountLogin)
//        CurrentControllerHelper.presentViewController(viewController: alert)
        //在前台运行时，得到推送信号
        let userInfo = notification.request.content.userInfo
        if notification.request.trigger.self is UNPushNotificationTrigger{
            //应用处于前台时的远程推送接受
            //关闭U-Push自带的弹出框
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        }else{
            //应用处于前台时的本地推送接受
        }
        //当应用处于前台时提示设置，需要哪个可以设置哪一个
        completionHandler(UNNotificationPresentationOptions(rawValue: UNNotificationPresentationOptions.RawValue(Int(UNNotificationPresentationOptions.sound.rawValue | UNNotificationPresentationOptions.badge.rawValue | UNNotificationPresentationOptions.alert.rawValue))))
    }
    //后台时收到的userInfo
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger.self is UNPushNotificationTrigger {
//            应用处于后台时的远程推送接受
//            必须加这句代码
            //程序后台运行时走的方法
            self.isPushOpen = true
            UMessage.didReceiveRemoteNotification(userInfo)
            guard let openType = userInfo["openType"] as? String else{
                return
            }
            if openType == "1" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushOpen"), object: nil, userInfo: ["openType":"1", "productID":userInfo["productID"] as! String, "productType":userInfo["productType"] as! String])
                self.openType = "1"
                self.productID = userInfo["productID"] as! String
                self.productType = userInfo["productType"] as! String
                if self.loadTimes == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isPushOpen"), object: nil, userInfo: ["openType":"1", "productID":userInfo["productID"] as! String, "productType":userInfo["productType"] as! String])
                }
            }
            
            if openType == "2" {
                var title = ""
                let aps = userInfo["aps"] as! [String: AnyObject]
                if let tempString = aps["alert"] as? [String: String]{
                    let alert = aps["alert"] as! [String: String]
                    title = alert["title"] as! String
                }else{
                    title = aps["alert"] as! String
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushOpen"), object: nil, userInfo: ["openType":"2", "url":userInfo["url"] as! String, "title":title])
                self.openType = "2"
                self.url = userInfo["url"] as! String
                self.title = title
                if self.loadTimes == 1 {
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "isPushOpen"), object: nil, userInfo: ["openType":"2", "url":userInfo["url"] as! String, "title":title])
                    
                }
            }
//            let alert = UIAlertController(title: "1", message: nil, preferredStyle: .alert)
//            let accountLogin = UIAlertAction(title: "确定", style: .default) { (UIAlertAction) in }
//            //将Actiont加入到AlertController
//            alert.addAction(accountLogin)
//            CurrentControllerHelper.presentViewController(viewController: alert)
        }else{
            //应用处于后台时的本地推送接受
            UMessage.didReceiveRemoteNotification(userInfo)
            guard let openType = userInfo["openType"] as? String else{
                return
            }
            if openType == "1" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushOpen"), object: nil, userInfo: ["openType":"1", "productID":userInfo["productID"] as! String, "productType":userInfo["productType"] as! String])
            }
            if openType == "2" {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushOpen"), object: nil, userInfo: ["openType":"2", "url":userInfo["url"] as! String])
            }
        }
    }
    //先1后3
    
     //MARK: 获取当前时间的时间戳的两种方法(秒为单位)
    func getNowTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"//设置时间格式；hh——>12小时制， HH———>24小时制
        //设置时区
        let timeZone = TimeZone.init(identifier: "Asia/Shanghai")
        formatter.timeZone = timeZone
        let dateNow = Date()//当前的时间
        //当前时间戳
        let timeStamp = String.init(format: "%ld", Int(dateNow.timeIntervalSince1970))
        return timeStamp
    }
}
