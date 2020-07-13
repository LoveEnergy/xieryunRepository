
//
//  BottomPopViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/22.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import pop

protocol BottomPopable {
    var viewHeight: CGFloat { get }
    var autoDismiss: Bool {get}
    func bottomPopShow()
    func popDismiss()
}

extension BottomPopable where Self: UIView {
    var autoDismiss: Bool {
        return false
    }
    
    func bottomPopShow() {
        
        let vc = BottomPopViewController()
        vc.autoDismiss = self.autoDismiss
        vc.show(view: self)
        
    }
    
    func popDismiss() {
        if let currentVC = CurrentControllerHelper.currentViewController() as? BottomPopViewController {
            currentVC.dismissView()
        } else {
            UIView.animate(withDuration: 0.35, animations: {
                self.superview?.alpha = 0.0
            }) { (finished) in
                self.superview?.removeFromSuperview()
            }
        }
        //        IQKeyboardManager.shared.keyboardDistanceFromTextField = keyboardDistance
    }
    
}

class BottomPopViewController: UIViewController {

    var previousWindow: UIWindow?
    var alertWindow: UIWindow?
    var autoDismiss: Bool = false
    
    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.frame = CGRect(x: 0, y: kScreenHeight, width: kScreenWidth, height: 0.8 * kScreenHeight)
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(bottomView)
        if autoDismiss {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapToDismiss))
            view.addGestureRecognizer(tap)
            self.view.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func tapToDismiss() {
        self.dismissView()
    }
    
    func show(view: UIView & BottomPopable) {
        let bounds = UIScreen.main.bounds
        alertWindow = UIWindow(frame: bounds)
        previousWindow = UIApplication.shared.keyWindow
        self.alertWindow?.rootViewController = self
        self.alertWindow?.makeKeyAndVisible()
        self.view.backgroundColor = UIColor.maskBackgroundColor
        self.view.alpha = 0.0
        
        self.bottomView.addSubview(view)
        self.bottomView.height = view.viewHeight
        view.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.bottomView)
        })
        
        UIView.animate(withDuration: 0.35, animations: {
            self.bottomView.frame = CGRect(x: 0, y: kScreenHeight - view.viewHeight, width: kScreenWidth, height: view.viewHeight)
            self.view.alpha = 1.0
        })
        bottomView.addShadow = true
        
    }
    
    @objc func dismissView() {
        self.alertWindow?.removeFromSuperview()
        self.previousWindow?.makeKeyAndVisible()
        self.alertWindow = nil
    }

}
