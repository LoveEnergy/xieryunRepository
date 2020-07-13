//
//  BindPhoneView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class BindPhoneView: UIView {
    public var bindPhoneViewDismissBlock:(()->())?//消失
    public var sendCodeBlock:((String)->())?//发送验证码
    public var submitDataBlock:((String, String)->())?//提交手机与验证码
    lazy var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0/WIDTH_6_SCALE, width: viewWidth, height: 275.0/WIDTH_6_SCALE))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    
    lazy var phoneTextField: UITextField = {
        weak var weakSelf = self
        let phoneTextField = UITextField.init()
        phoneTextField.placeholder = "请输入手机号"
        phoneTextField.font = DEF_FontSize_15
        phoneTextField.textColor = UIColor.colorWithHex(hex: "666666")
        return phoneTextField
    }()
    
    lazy var phoneTextBgView : UIView = {
        var codeTextBgView = UIView.init()
        codeTextBgView.layer.cornerRadius = 2
        codeTextBgView.layer.masksToBounds = true
        codeTextBgView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        codeTextBgView.layer.borderWidth = 0.8
        return codeTextBgView
    }()
    
    lazy var codeTextField: UITextField = {
        weak var weakSelf = self
        let codeTextField = UITextField.init()
        codeTextField.placeholder = "请填写邀请码"
        codeTextField.font = DEF_FontSize_15
        codeTextField.textColor = UIColor.colorWithHex(hex: "666666")
        return codeTextField
    }()
    
    lazy var codeTextBgView : UIView = {
        var codeTextBgView = UIView.init()
        codeTextBgView.layer.cornerRadius = 2
        codeTextBgView.layer.masksToBounds = true
        codeTextBgView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        codeTextBgView.layer.borderWidth = 0.8
        return codeTextBgView
    }()
    
    lazy var topImgView : UIImageView = {
        weak var weakSelf = self
        var topImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: (weakSelf?.whiteBGView.width)!, height: 80/WIDTH_6_SCALE))
        topImgView.image = UIImage.init(named: "goodsdetail_live_invite_code_bg")
        return topImgView
    }()
    
    lazy var closeBtn : UIButton = {
        weak var weakSelf = self
        let btnW = 25/WIDTH_6_SCALE
        var closeBtn = UIButton.init(frame: CGRect(x: (weakSelf?.whiteBGView.width)! - 5/WIDTH_6_SCALE - btnW, y: 5/WIDTH_6_SCALE, width: btnW, height: btnW))
        closeBtn.setImage(UIImage.init(named: "goodsdetail_x"), for: .normal)
        closeBtn.addTarget(self, action: #selector(closeBtnClick(btn:)), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var sendCodeBtn : UIButton = {
        var sendCodeBtn = UIButton.init()
        sendCodeBtn.setTitle("发送验证码", for: .normal)
        sendCodeBtn.setTitleColor(UIColor.colorWithHex(hex: "1FA2F8"), for: .normal)
        sendCodeBtn.titleLabel?.font = DEF_FontSize_13
        sendCodeBtn.setBackgroundColor(.white, forState: .normal)
        sendCodeBtn.addTarget(self, action: #selector(sendCodeBtnClick), for: .touchUpInside)
        sendCodeBtn.adjustsImageWhenHighlighted = false//高亮
        return sendCodeBtn
    }()
    
    lazy var sureBtn : UIButton = {
        var sureBtn = UIButton.init()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_14
        sureBtn.setBackgroundColor(UIColor.colorWithHex(hex: "1FA2F8"), forState: .normal)
        sureBtn.layer.cornerRadius = 2
        sureBtn.layer.masksToBounds = true
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var titleLab : UILabel = {
        weak var weakSelf = self
        var titleLab = UILabel.init(frame: self.topImgView.bounds)
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .white
        titleLab.textAlignment = .center
        titleLab.text = "绑定手机号"
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        btn.addSubview(self.whiteBGView)
        self.whiteBGView.addSubview(self.topImgView)
        self.topImgView.addSubview(self.titleLab)
        self.whiteBGView.addSubview(self.phoneTextBgView)
        self.phoneTextBgView.addSubview(self.phoneTextField)
        self.whiteBGView.addSubview(self.codeTextBgView)
        self.codeTextBgView.addSubview(self.codeTextField)
        self.codeTextBgView.addSubview(self.sendCodeBtn)
        self.whiteBGView.addSubview(self.closeBtn)
        self.whiteBGView.addSubview(self.sureBtn)
        let bgViewH = 35/WIDTH_6_SCALE
        let bgViewX = 15/WIDTH_6_SCALE
        let btnX = 82.5/WIDTH_6_SCALE
        let btnH = 40/WIDTH_6_SCALE
        self.phoneTextBgView.frame = CGRect(x: bgViewX, y: self.topImgView.bottom + 20/WIDTH_6_SCALE, width: self.whiteBGView.width - 2 * bgViewX, height: bgViewH)
        self.codeTextBgView.frame = CGRect(x: self.phoneTextBgView.left, y: self.phoneTextBgView.bottom + 20/WIDTH_6_SCALE, width: self.phoneTextBgView.width, height: self.phoneTextBgView.height)
        self.phoneTextField.frame = CGRect(x: 5/WIDTH_6_SCALE, y: 0, width: self.phoneTextBgView.width, height: self.phoneTextBgView.height)
        self.codeTextField.frame = CGRect(x: self.phoneTextField.left, y: 0, width: self.codeTextBgView.width - 110/WIDTH_6_SCALE, height: self.codeTextBgView.height)
        self.sendCodeBtn.frame = CGRect(x: self.codeTextBgView.width - 110/WIDTH_6_SCALE, y: 0, width: 100/WIDTH_6_SCALE, height: self.codeTextBgView.height)
        self.sureBtn.frame = CGRect(x: btnX, y: self.codeTextBgView.bottom + 25/WIDTH_6_SCALE, width: self.whiteBGView.width - 2 * btnX, height: btnH)
        self.sureBtn.centerY = (self.whiteBGView.height - self.codeTextBgView.bottom)/2 + self.codeTextBgView.bottom
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension BindPhoneView{

    @objc func btnClick(btn: UIButton){
        
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
        self.bindPhoneViewDismissBlock?()
    }
    
    @objc func closeBtnClick(btn: UIButton){
        self.dismissView()
    }
    
    @objc func sendCodeBtnClick(){
        if self.phoneTextField.text!.isEmpty {
            HUD.showText(text: "请填写手机号")
            return
        }
        self.sendCodeBlock?(self.phoneTextField.text!)
    }
    
    @objc func sureBtnClick(){
        if self.phoneTextField.text!.isEmpty || self.codeTextField.text!.isEmpty {
            HUD.showText(text: "请填写手机号与验证码")
            return
        }
        self.submitDataBlock?(self.phoneTextField.text!, self.codeTextField.text!)
    }
}
