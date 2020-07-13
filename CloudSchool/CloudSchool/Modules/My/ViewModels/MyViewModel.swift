//
//  MyViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

enum MyType {
    case cart
    //我的订单
    case order
    //意见反馈
    case cache
    //考试
    case exam
    case studycard
    //开课卡
    case coursecard
    //优惠券
    case coupon
    //账户余额
    case balance
    //账户余额
    case address
    //联系客服
    case service
    
    case profit
    //发票管理
    case invoice
    //联系客服
    case connectServe
    //测试
    case testPage
    //测试
    case testPushLive
    //测试
    case frequency
    //测试
    case paySuccess
    case payTest
    case employ
    case myResume
    case jobFeedback
    case albumTest
    case myAccount
    
    var iconImage: UIImage? {
        switch self {
            
        case .order:
            return R.image.my_order()
        case .cache:
            return R.image.my_cache()
        case .coursecard:
            return R.image.my_course()
        case .coupon:
            return R.image.my_coupon()
        case .balance:
            return R.image.my_coupon()
        case .service:
            return R.image.my_call_server()
        case .address:
            return R.image.my_address()
        case .cart:
            return R.image.my_cart()
        case .studycard:
            return R.image.my_study()
        case .exam:
            return R.image.my_exam()
        case .profit:
            return R.image.my_profit()
        case .invoice:
            return R.image.my_invoice()
        case .connectServe:
            return R.image.my_invoice()
        case .testPage:
            return R.image.my_invoice()
        case .testPushLive:
            return R.image.my_invoice()
        case .frequency:
            return R.image.my_invoice()
        case .paySuccess:
            return R.image.my_invoice()
        case .payTest:
            return R.image.my_invoice()
        case .employ:
            return R.image.my_invoice()
        case .myResume:
            return R.image.my_invoice()
        case .jobFeedback:
            return R.image.my_invoice()
        case .albumTest:
            return R.image.my_invoice()
        case .myAccount:
            return R.image.my_invoice()
        }
    }
    var settingTitle: String {
        switch self {
        case .cart:
            return "购物车"
        case .order:
            return "我的订单"
        case .cache:
            return "离线缓存"
        case .coursecard:
            return "开课卡"
        case .coupon:
            return "优惠券"
        case .balance:
            return "账户余额"
        case .service:
            return "联系客服"
        case .address:
            return "收货地址"
        case .studycard:
            return "学习卡"
        case .exam:
            return "我的考试"
        case .profit:
            return "我的收益"
        case .invoice:
            return "发票管理"
        case .connectServe:
            return "联系客服"
        case .testPage:
            return "观看直播"
        case .testPushLive:
            return "直播讲课"
        case .frequency:
            return "音频"
        case .paySuccess:
            return "支付成功"
        case .payTest:
            return "苹果支付"
        case .employ:
            return "招聘"
        case .myResume:
            return "我的简历"
        case .jobFeedback:
            return "求职反馈"
        case .albumTest:
            return "相册"
        case .myAccount:
            return "我的账户"
        }
    }
    
    func open() {
        switch self {
        case .order:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.myOrderViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .cache:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.offlineListViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .exam:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.exam.examViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .coupon:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.couponListViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
//            let vc = R.storyboard.recharge.rechargeViewController()!
//            CurrentControllerHelper.pushViewController(viewController: vc)
        case .address:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.addressListViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
            
        case .coursecard:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.openCourseViewController()!
                let vm = OpenCourseViewModel()
                let getViewModel = GetOpenCourseViewModel()
                vc.bindViewModel(viewModel: vm)
                vc.bindSecondViewModel(sViewModel: getViewModel)
                
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
            
        case .cart:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.cart.cartViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .studycard:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.openCourseViewController()!
                let vm = LearnCardViewModel()
                vc.bindViewModel(viewModel: vm)
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .profit:
            LoginHelper.checkLoginStatus {
                let vc = R.storyboard.my.manageProfitViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .invoice:
            LoginHelper.checkLoginStatus {
//            let vc = R.storyboard.my.invoiceManageViewController()!
//            CurrentControllerHelper.pushViewController(viewController: vc)
                let vc = R.storyboard.my.invoiceManageViewController()!
                CurrentControllerHelper.pushViewController(viewController: vc)
//                let vc = SelectInvoiceTypeViewController.init()
//                vc.title = "发票类型"
//                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .testPage:
            LoginHelper.checkLoginStatus {
                let vc = PlayLiveViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .testPushLive:
            LoginHelper.checkLoginStatus {
                let vc = IMTestPageViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .frequency:
//            LoginHelper.checkLoginStatus {
                let vc = FrequencyViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
//            }
        case .paySuccess:
            LoginHelper.checkLoginStatus {
                let vc = PaySuccessViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        case .employ:
//            LoginHelper.checkLoginStatus {
                let vc = EmployViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
//            }
        case .myResume:
//            LoginHelper.checkLoginStatus {
                let vc = MyResumeViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
//            }
        case .connectServe:
            let phone = "telprompt://" + "4000810101"
            if UIApplication.shared.canOpenURL(URL(string: phone)!) {
                 UIApplication.shared.openURL(URL(string: phone)!)
            }
        case .jobFeedback:
            let vc = JobFeedbackViewController.init()
            CurrentControllerHelper.pushViewController(viewController: vc)
        case .albumTest:
            let vc = TestPayViewController.init()
            CurrentControllerHelper.pushViewController(viewController: vc)
        case .myAccount:
            LoginHelper.checkLoginStatus {
                let vc = MyAccountViewController.init()
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        default:
            break
        }
        //        switch self {
        //
        //        case .order:
        //            BrowserHelper.show(url: KuTingProtocol.newUser.url)
        //        case .coupon:
        //            let modifyVC = R.storyboard.login.registerViewController()!
        //
        //           modifyVC.type = .forgetPassword
        //            CurrentControllerHelper.pushViewController(viewController: modifyVC)
        //        case .cache:
        //            let cacheVC = R.storyboard.set.cacheViewController()!
        //            CurrentControllerHelper.pushViewController(viewController: cacheVC)
        //        case .coursecard:
        //            BrowserHelper.show(url: KuTingProtocol.coursecard.url)
        //        }
    }
}

struct MyViewModel {
    #warning("上架修改")
    //测试用
//    let data: [[MyType]] = [[.cart, .order, .exam, .profit], [.cache, .coursecard, .studycard, .coupon], [.address, .invoice, .connectServe, .testPage, .testPushLive, .frequency, .myResume, .jobFeedback, .employ, .paySuccess, .albumTest]]
    //正式用
//    let data: [[MyType]] = [[.cart, .order, .exam, .profit], [.cache, .coursecard, .studycard, .testPushLive], [.address, .invoice, .connectServe]]
    let data: [[MyType]] = [[.cart, .order, .exam, .profit, .myAccount], [.cache, .coupon, .testPushLive], [.address, .invoice, .connectServe]]
}
