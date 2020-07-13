//
//  LiveStopAlertView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/27.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LiveStopAlertView: UIView {
    public var backPageBlock:(()->())?
    public var dismissViewBlock:(()->())?
    lazy var whiteBGView : UIImageView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 160/WIDTH_6_SCALE)
        var whiteBGView = UIImageView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 0, width: viewWidth, height: 170/WIDTH_6_SCALE))
        whiteBGView.centerY = SCREEN_HEIGHT/2 + 20/WIDTH_6_SCALE
        whiteBGView.backgroundColor = .clear
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        whiteBGView.image = UIImage.init(named: "live_backBG")
        return whiteBGView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: whiteBGView.height/2 + 5/WIDTH_6_SCALE, width: self.whiteBGView.width, height: 20/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "确定退出直播"
        return titleLab
    }()
    lazy var backBtn : UIButton = {
        var backBtn = UIButton.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: self.titleLab.bottom + 15/WIDTH_6_SCALE, width: 80/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "live_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return backBtn
    }()
    lazy var cancelBtn : UIButton = {
        var cancelBtn = UIButton.init(frame: CGRect(x: self.whiteBGView.width - self.backBtn.left - self.backBtn.width, y: self.backBtn.top, width: self.backBtn.width, height: self.backBtn.height))
        cancelBtn.setImage(UIImage.init(named: "live_cancel"), for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelBtn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.whiteBGView)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.whiteBGView)
        self.whiteBGView.addSubview(self.titleLab)
        self.whiteBGView.addSubview(self.backBtn)
        self.whiteBGView.addSubview(self.cancelBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LiveStopAlertView{
    @objc func backBtnClick(){
        self.backPageBlock?()
    }
    
    @objc func cancelBtnClick(){
        self.dismissViewBlock?()
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
    @objc func btnClick(btn:UIButton){
        self.dismissViewBlock?()
    }
    func dismissView(){
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
}
