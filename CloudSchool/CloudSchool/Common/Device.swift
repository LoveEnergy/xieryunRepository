//
//  Device.swift
//  AsteroidVPN-iOS
//
//  Created by Asteroid on 2017/12/26.
//  Copyright © 2017年 Asteroid. All rights reserved.
//

import UIKit
import Foundation

extension UIDevice {
    open class var UUID: String {
        return ""
    }
    
    open class var languageCode: String {
        return Locale.current.languageCode ?? "en"
    }
    
    open class var systemVersionString: String {
        return UIDevice.current.systemVersion
    }
    
    open class var countryCode: String {
        return Locale.current.regionCode ?? ""
    }
    
    open class var timeZone: TimeZone {
        return NSTimeZone.local
    }
    
    
}

class AppInfo {
    class var buildNumber: String {
        let infoDic = Bundle.main.infoDictionary
        
//        // 获取App的版本号
//        let appVersion = infoDic?["CFBundleShortVersionString"]
        
        // 获取App的build版本
        let appBuildVersion = infoDic?["CFBundleVersion"] as? String
        
        // 获取App的名称
//        let appName = infoDic?["CFBundleDisplayName"]
        return appBuildVersion ?? "0"
        
    }
}


