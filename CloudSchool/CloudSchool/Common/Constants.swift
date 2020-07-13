//
//  Constants.swift
//  Asteroid
//
//  Created by feiyu on 2017/4/26.
//  Copyright © 2017年 Aeseroid. All rights reserved.
//

import UIKit

let constant = Constant()

// MARK:- const value
let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height
let currentVesion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] ?? "0.0"
let ySpace: CGFloat = 8
let gXLeading: CGFloat = 15
let xSpace: CGFloat = 10

//吐司提示框延迟消失时长，秒
let kHudDelaySec = 1.0


typealias RequestResult = (success: Bool, message: String)

struct Constant {
    
    // MARK:- const string
    /* 用于 info.plist 存储当前版本号的 key */
    let sandboxVesion = "CFBundleShortVersionString"
   
    let isUserReviewedApp = "isUserReviewedAppV\(currentVesion)"
    let isUserDenyReviewAppCondition1 = "isUserDenyReviewAppCondition1V\(currentVesion)"
    let isUserDenyReviewAppCondition2 = "isUserDenyReviewAppCondition2V\(currentVesion)"
    let isUserDenyReviewAppCondition3 = "isUserDenyReviewAppCondition3V\(currentVesion)"
    let launchAppTimes = "LaunchAppTimesV\(currentVesion)"
    let sportTimesWhenUserDenyReviewAppCondition1 = "SportTimesWhenUserDenyReviewAppCondition1V\(currentVesion)"
    let launchAppTimesWhenUserDenyReviewAppCondition2 = "LaunchAppTimesWhenUserDenyReviewAppCondition2V\(currentVesion)"
    let lastAlertUserUpgradeDate = "LastAlertUserUpgradeDate"
    let theDateOfUserFirstLaunchAppInCurrentVersion = "TheDateOfUserFirstLaunchAppInCurrentVersionV\(currentVesion)"
    
    //结果页是否已经显示反馈
    let isShowResultFeedback = "isShowResultFeedback\(currentVesion)"
    
    let shareUrlString = "https://itunes.apple.com/us/app/asteroid-vpn-ip-vanish-proxy/id1331345801"
    
//        FYTODO:   上线前检查好 APPID是否正确，是否切换到Release版本
    #if DEBUG
    let appleid = "1232485195"
    ///每日免费使用时长
    let everyDaySeconds = 120
    #else
    let appleid = "1331345801"
    ///每日免费使用时长
    let everyDaySeconds = 1800
    #endif
    
    let seconds = 1800
    
    
    
    let freetriel: String = "free.connect.unblock.vpn.fast.proxy.shield.subscribe.free7days"
    
    // MARK:- NotificationKeys
    let clearUserInfo = "clearUserInfo"
    let shareTopic = "#Asteroid VPN"

    let minWeight: Float = 20.0 //kg
    let minHeight: Float = 20.0 // cm
    
    let defaultCornerRadius: CGFloat = 3.0
    let defaultShadowOpacity: CGFloat = 0.2
    static let pageSize = 40
    static let serverBaseURL: String = "http://39.98.42.158"//测试
//    static let serverBaseURL: String = "http://192.168.3.102:8080"//亮哥本地
//    static let serverBaseURL: String = "http://192.168.3.145:8080"//晓东本地
//    static let serverBaseURL: String = "http://39.98.54.106"
    static let serverURL: String = "https://wlp.zkhj618.com/"
    static let codeURL: String = "http://ycwx.zkhj618.com/"
    static let codeKeyString: String = "4VATS58DFnZDmoPu"
    
    static let privacyURL: String = serverBaseURL + "/contract.html"
    static let userProtocolURL: String = serverBaseURL + "/contract.html"
    
//    productType: 1、在线课程  2、书 籍  3、班级(objectType: 1、开课卡远程班  2、面授  3、付费远程班)  4、实物  5、直播课程
}

public func DAssertionFailure(_ message:Any...,file:String = #file,row:Int = #line){
    #if DEBUG
        if let filename = (file as String).components(separatedBy: "/").last {
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYY-MM-dd hh:mm:ss:SSS"
            let dateString = formatter.string(from: Date())
            assertionFailure("[\(dateString) \(String(describing: filename))-\(row)]:\(message)")
        }
    #endif
}

public func DAssertionFailureDataErr(){
    DAssertionFailure("数据异常")
}
