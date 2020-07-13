//
//  SendResumeView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SendResumeView: UIView {
    public var sendResumeViewDismissBlock:(()->())?//消失
    lazy var successView : UIImageView = {
        var successView = UIImageView.init(frame: CGRect(x: 87.5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 175/WIDTH_6_SCALE, height: 250/WIDTH_6_SCALE))
        successView.centerX = SCREEN_WIDTH/2
        successView.centerY = SCREEN_HEIGHT/2
        successView.image = UIImage.init(named: "resumeSuccess")
        return successView
    }()
    lazy var knowBtn : UIButton = {
        var knowBtn = UIButton.init()
        knowBtn.addTarget(self, action: #selector(knowBtnClick), for: .touchUpInside)
        knowBtn.setImage(UIImage.init(named: "employ_know"), for: .normal)
        return knowBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.successView)
        self.successView.addSubview(self.knowBtn)
        self.successView.isUserInteractionEnabled = true
        self.knowBtn.frame = CGRect(x: 0, y: self.successView.height - 15/WIDTH_6_SCALE - 60/WIDTH_6_SCALE, width: 125.5/WIDTH_6_SCALE, height: 60/WIDTH_6_SCALE)
        self.knowBtn.centerX = self.successView.width/2
        self.knowBtn.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func dismissView(){
        self.sendResumeViewDismissBlock?()
    }
    
    @objc func knowBtnClick(){
        self.dismissView()
    }
}
