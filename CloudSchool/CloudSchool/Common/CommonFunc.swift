//
//  CommonFunc.swift
//  ColorMask
//
//  Created by zhouyehong on 2018/3/6.
//  Copyright © 2018年 SoloGame. All rights reserved.
//

import UIKit
//#if DEBUG
//import DotzuX
//#endif

func dotzuXEnable(){
//    #if DEBUG
//    DotzuX.enable()
//    #endif
}

public func DPrint(_ message:Any...,file:String = #file,function:String = #function,row:Int = #line){
    let thread = Thread.current
    SFLog.shared.log(message, thread: thread,file: file, function: function,row: row)
}

class SFLog: NSObject {
    
    static let shared = SFLog()
    private override init() {}
    let queue: DispatchQueue = {
        let queue = DispatchQueue(label: "sflog")
        return queue
    }()
    
    private lazy var logPath: String = {
        let path = "\(NSHomeDirectory())/tmp/log.txt"
        return path
    }()
    
    public func log(_ message:Any,thread: Thread,file:String ,function: String, row:Int){
        queue.async {
            
            if let filename = (file as String).components(separatedBy: "/").last {
                
                let model = SFLogModel(thread: thread , fileName: filename, function: function,row: row, message: message)
                #if DEBUG
                print(model.descripation)
                #endif
                
            }
        }
    }
}
struct SFLogModel {
    let thread: Thread
    let date : Date = Date()
    let fileName: String
    let function: String
    let row: Int
    let message: Any
    
    var descripation: String {
        
        let des = "SFLog<\(thread.name ?? "")>->\(dateString()) \(fileName)-\(row)->\(function):\(message)"
        return des
    }
    
    func dateString() -> String {
        let formatter =  DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd hh:mm:ss:SSS"
        let dateString = formatter.string(from: self.date)
        return dateString
    }
}


func nslog<T>(_ message : T, file: String = #file, function: String = #function, line: Int = #line, color: UIColor = .white) {
    let fileName = (file as NSString).lastPathComponent
    let dateformatter = DateFormatter()
    dateformatter.dateFormat = "yyyy-MM-dd hh:mm:ss SSS"
    let log = "[\(fileName):\(line) \(dateformatter.string(from: Date()))]\(message)"
    
    #if DEBUG
        print(log)
//        swiftLog(file, function, line, message, color)
    #endif
}

/// 安全区域边距
func safeAreaEdges() -> UIEdgeInsets {
    if #available(iOS 11.0, *) {
        return UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    return .zero
}

///修改订阅状态
func setSubscriptionStatusState(_ state: Bool) {
    let oldState = UserDefaults.User.bool(forKey: .subscriptionValid)
//    //更新通知处理
//    LocalNotification.updateLocalNotification()
//    if oldState == state {
//        return
//    }
//    if state {
//        if !UserDefaults.standard.bool(forKey: UserDefaultKey.hasSubscriptionKey) {
//            UserDefaults.standard.set(true, forKey: UserDefaultKey.hasSubscriptionKey)
//        }
//
//    } else {
//        //未订阅
//
//    }
    UserDefaults.User.set(state, forKey: .subscriptionValid)
    UserDefaults.standard.synchronize()
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue:NtfKey.subscriptionStatusUpdate), object: nil, userInfo: nil)
}


