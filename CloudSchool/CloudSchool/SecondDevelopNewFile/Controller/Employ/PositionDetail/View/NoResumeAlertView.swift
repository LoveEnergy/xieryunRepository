//
//  NoResumeAlertView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class NoResumeAlertView: UIView {
    public var sendResumeViewDismissBlock:(()->())?//消失
    lazy var noResumeAlertView : UIImageView = {
        var noResumeAlertView = UIImageView.init(frame: CGRect(x: 52/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 104/WIDTH_6_SCALE, height: 189/WIDTH_6_SCALE))
        noResumeAlertView.centerX = SCREEN_WIDTH/2
        noResumeAlertView.centerY = SCREEN_HEIGHT/2
        noResumeAlertView.image = UIImage.init(named: "noSendResume")
        return noResumeAlertView
    }()
    
    lazy var fillInBtn : UIButton = {
        var fillInBtn = UIButton.init()
        fillInBtn.addTarget(self, action: #selector(fillInBtnClick), for: .touchUpInside)
        fillInBtn.setImage(UIImage.init(named: "employ_fill_in"), for: .normal)
        return fillInBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.noResumeAlertView)
        self.addSubview(self.fillInBtn)
        self.noResumeAlertView.isUserInteractionEnabled = true
        self.fillInBtn.frame = CGRect(x: 0, y: self.noResumeAlertView.bottom + 38/WIDTH_6_SCALE, width: 125.5/WIDTH_6_SCALE, height: 65/WIDTH_6_SCALE)
        self.fillInBtn.centerX = SCREEN_WIDTH/2
        self.fillInBtn.isUserInteractionEnabled = true
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
    
    @objc func fillInBtnClick(){
        self.dismissView()
    }
}
