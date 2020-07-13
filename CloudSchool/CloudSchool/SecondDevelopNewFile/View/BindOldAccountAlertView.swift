//
//  BindOldAccountView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/8.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class BindOldAccountAlertView: UIView {
    public var bindOldAccountAlertCancelBlock:(()->())?//取消绑定
    public var bindOldAccountAlertSureBlock:(()->())?//确定绑定
    lazy var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0/WIDTH_6_SCALE, width: viewWidth, height: 150.0/WIDTH_6_SCALE))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    lazy var titleLab : UILabel = {
        weak var weakSelf = self
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: (weakSelf?.whiteBGView.width)!, height: 100/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "是否想绑定到已存在账号上?"
        return titleLab
    }()
    
    lazy var sureBtn: UIButton = {
        weak var weakSelf = self
        var sureBtn = UIButton.init(frame: CGRect(x: 0, y: (weakSelf?.titleLab.bottom)!, width: (weakSelf?.whiteBGView.width)!/2, height: 50/WIDTH_6_SCALE))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_14
        sureBtn.setBackgroundColor(UIColor.colorWithHex(hex: "1FA2F8"), forState: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        weak var weakSelf = self
        var cancelBtn = UIButton.init(frame: CGRect(x: (weakSelf?.sureBtn.right)!, y: (weakSelf?.sureBtn.top)!, width: (weakSelf?.sureBtn.width)!, height: (weakSelf?.sureBtn.height)!))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.titleLabel?.font = DEF_FontSize_14
        cancelBtn.setBackgroundColor(UIColor.white, forState: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        let btn = UIButton.init(frame: self.bounds)
        self.addSubview(btn)
        btn.addSubview(self.whiteBGView)
        self.whiteBGView.centerY = btn.centerY - 100/WIDTH_6_SCALE
        self.whiteBGView.addSubview(self.titleLab)
        self.whiteBGView.addSubview(self.sureBtn)
        self.whiteBGView.addSubview(self.cancelBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BindOldAccountAlertView{
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    @objc func cancelBtnClick(){
        self.bindOldAccountAlertCancelBlock?()
    }
    
    @objc func sureBtnClick(){
        self.bindOldAccountAlertSureBlock?()
    }
    
}
