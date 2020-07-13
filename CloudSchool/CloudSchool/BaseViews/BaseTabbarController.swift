//
//  BaseTabbarControllerViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/7.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class BaseTabbarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard !LoginHelper.isLogin else {
            return true
        }
        if let vc = (viewController as? BaseNavigationViewController)?.viewControllers.first {
//            if vc.isKind(of: MyStudyViewController.self) {
//                LoginHelper.checkLoginStatus(completion: nil)
//                return false
//            }
        }
        return true
    }
    

    
}
