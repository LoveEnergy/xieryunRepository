//
//  SetViewModel.swift
//  KuTing
//
//  Created by Maynard on 2018/3/20.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift

enum SettingType {
    //推送消息
    case notification
    //意见反馈
    case feedback
    //关于我们
    case aboutus
    //服务条款
    case privacy
    //账号设置
    case accountSet
    
    var iconImage: UIImage? {
        switch self {
            
        case .notification:
            return R.image.set_message()
        case .feedback:
            return R.image.set_opinion()
        case .aboutus:
            return R.image.set_us()
        case .privacy:
            return R.image.set_service()
        case .accountSet:
            return R.image.set_service()
        }
    }
    var settingTitle: String {
        switch self {
            
        case .notification:
            return "推送消息"
        case .feedback:
            return "反馈意见"
        case .aboutus:
            return "关于我们"
        case .privacy:
            return "服务条款"
        case .accountSet:
            return "账号绑定管理"
        }
    }
    
    func open() {
        switch self {
            
//        case .notification:
//            BrowserHelper.show(url: KuTingProtocol.newUser.url)
//        case .privacy:
//            let modifyVC = R.storyboard.login.registerViewController()!
//
//           modifyVC.type = .forgetPassword
//            CurrentControllerHelper.pushViewController(viewController: modifyVC)
//        case .feedback:
//            let feedbackVC = R.storyboard.set.feedBackViewController()!
//            CurrentControllerHelper.pushViewController(viewController: feedbackVC)
        case .aboutus:
            let vc = R.storyboard.my.aboutUsViewController()!
            CurrentControllerHelper.pushViewController(viewController: vc)
        case .accountSet:
            let vc = AccountSettingViewController.init()
            CurrentControllerHelper.pushViewController(viewController: vc)
        default:
            break
        }
    }
}

struct SetViewModel {
    let data: Observable<[SettingType]> = Observable.just(
        [.aboutus, .accountSet]
    )
}
