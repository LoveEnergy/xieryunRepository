//
//  UIViewController + Analytics.swift
//  SoloFitness
//
//  Created by Maynard on 2017/5/3.
//  Copyright © 2017年 赤子城. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class func swizzle(){
        
        // 创建一个结构体,写个静态变量
        struct Exchange {
            
             static let viewWillApper: Bool = {
                let cls: AnyClass = UIViewController.self
                // 创建消息对象
                let originalSelector = #selector(UIViewController.viewWillAppear(_:))
                let swizzleSelector = #selector(UIViewController.swizzle_viewWillAppear(_:))
                // 创建方法
                let ori_method = class_getInstanceMethod(cls, originalSelector)
                let swi_method = class_getInstanceMethod(cls, swizzleSelector)
                
                // 交换两个方法的实现部分
                method_exchangeImplementations(ori_method!,swi_method!)
                return false
            }()
            
            static let viewWillDisapper: Bool = {
                let cls: AnyClass = UIViewController.self
                // 创建消息对象
                let originalSelector = #selector(UIViewController.viewWillDisappear(_:))
                let swizzleSelector = #selector(UIViewController.swizzle_viewWillDisappear(_:))
                // 创建方法
                let ori_method = class_getInstanceMethod(cls, originalSelector)
                let swi_method = class_getInstanceMethod(cls, swizzleSelector)
                
                // 交换两个方法的实现部分
                method_exchangeImplementations(ori_method!,swi_method!)
                return false
            }()
        }
        // 这里必须执行一下,不然没法创建静态变量
        let _ = Exchange.viewWillApper
        let _ = Exchange.viewWillDisapper
        
    }
    
    @objc public func swizzle_viewWillAppear(_ animated: Bool) {
        print("\(self.className) 出现了")
        //这里进行统计操作
//        MobClick.beginLogPageView("\(self.className)")
        
        // 看似好像调用了自己构成死循环,但是 我们其实已经将两个方法名的实现进行了调换 所以 其实我们调用的是 方法sendAction:to:forEvent 的实现 这样就可以在不破环原先方法结构的基础上进行交换实现
        swizzle_viewWillAppear(animated)
    }
    
    @objc public func swizzle_viewWillDisappear(_ animated: Bool) {
        print("\(self) 消失了")
        //这里进行统计操作
//        MobClick.endLogPageView("\(self.className)")
        
        // 看似好像调用了自己构成死循环,但是 我们其实已经将两个方法名的实现进行了调换 所以 其实我们调用的是 方法sendAction:to:forEvent 的实现 这样就可以在不破环原先方法结构的基础上进行交换实现
        swizzle_viewWillDisappear(animated)
    }
}
