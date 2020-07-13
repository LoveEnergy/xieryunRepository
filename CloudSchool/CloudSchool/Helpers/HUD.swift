//
//  HUD.swift
//  Asteroid
//
//  Created by Maynard on 2017/5/11.
//  Copyright © 2017年 Aeseroid. All rights reserved.
//

import Foundation
import UIKit
import QMUIKit

struct HUD {
    enum ToastPosition {
        case top
        case bottom
    }
    
    static func configure() {
//        ToastView.appearance().backgroundColor = UIColor.black
//        ToastView.appearance().borderColor = UIColor.lineColor
//        ToastView.appearance().textColor = UIColor.white
//        ToastView.appearance().borderWidth = 0.0
//        ToastView.appearance().textInsets = UIEdgeInsetsMake(14, 33, 14, 33)
    }
    
    static func toast(_ text: String) {
//        ToastCenter.default.cancelAll()
//        let toast = Toast(text: text)
//        toast.duration = 1.0
//        let toastView = toast.view
//        toastView.borderColor = UIColor.lineColor
////        toastView.addShadow(offset: CGSize(width: 1, height: 1), radius: 3, color: UIColor.mainNormalColor, opacity: 0.3)
//        toastView.bottomOffsetPortrait = 100.0
//        toast.show()
    }
    
    static func toast(_ text: String, bottomOffset: CGFloat) {
//        ToastCenter.default.cancelAll()
//        let toast = Toast(text: text)
//        let toastView = toast.view
//        toastView.textColor = UIColor.mainRedColor
//        toastView.font = UIFont.systemFont(ofSize: 14)
//        toastView.borderColor = UIColor.clear
//        toastView.backgroundColor = UIColor.clear
//        toastView.addShadow(offset: CGSize(width: 1, height: 1), radius: 3, color: UIColor.mainNormalColor, opacity: 0.3)
//        toastView.bottomOffsetPortrait = bottomOffset
//        toast.show()
    }
    
    static func toast(_ text: String,position: ToastPosition, textColor: UIColor){
//        var bottomOffset = 0.0
//        switch position {
//        case .top:
//            bottomOffset = Double(UIScreen.main.bounds.height - 76)
//        default:
//            bottomOffset = 50
//        }
//
//        ToastCenter.default.cancelAll()
//        let toast = Toast(text: text)
//        let toastView = toast.view
//        toastView.textColor = textColor
//        toastView.font = UIFont.systemFont(ofSize: 14)
//        toastView.borderColor = UIColor.clear
//        toastView.backgroundColor = UIColor.clear
//        toastView.bottomOffsetPortrait = CGFloat(bottomOffset)
//        toast.show()
    }
    
    static func cancleAll() {
//        ToastCenter.default.cancelAll()
    }
    
//    static func loading() {
//        KRProgressHUD.show()
//    }
    
    static func loading(text: String) {
        QMUITips.showLoading(text, in: CurrentControllerHelper.currentViewController().view)
    }
    
    static func loading(text: String, onViewController: UIViewController) {
        QMUITips.showLoading(text, in: onViewController.view)
    }
    
    static func hideLoading() {
        SwiftNotice.clear()
        QMUITips.hideAllTips()
    }
    
    static func error(view: UIView, error: String) {
        QMUITips.showError(error, in: view)
    }
    
    static func showText(text: String) {
        HUD.hideLoading()
        QMUITips.showInfo(text)
    }
    
    static func showError(error: String) {
        HUD.hideLoading()
        QMUITips.showError(error)
    }

}
