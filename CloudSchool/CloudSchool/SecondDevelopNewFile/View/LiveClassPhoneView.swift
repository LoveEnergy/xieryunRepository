//
//  BindPhoneView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LiveClassPhoneView: UIView {
    public var liveClassPhoneViewDismissBlock:(()->())?//消失
    public var sureBtnClickBlock:((String)->())?//邀请码接口
    lazy var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0/WIDTH_6_SCALE, width: viewWidth, height: 200.0/WIDTH_6_SCALE))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    
    lazy var codeTextField: UITextField = {
        weak var weakSelf = self
        let codeTextField = UITextField.init()
        codeTextField.placeholder = "请填写手机号"
        codeTextField.font = DEF_FontSize_15
        codeTextField.textColor = .black
        return codeTextField
    }()
    
    lazy var textBgView : UIView = {
        var textBgView = UIView.init()
        textBgView.layer.cornerRadius = 2
        textBgView.layer.masksToBounds = true
        textBgView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        textBgView.layer.borderWidth = 0.8
        return textBgView
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
    
    lazy var sureBtn : UIButton = {
        var sureBtn = UIButton.init()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_15
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
        titleLab.text = "请填写手机号"
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
        self.whiteBGView.addSubview(self.sureBtn)
        self.whiteBGView.addSubview(self.textBgView)
        self.textBgView.addSubview(self.codeTextField)
        self.whiteBGView.addSubview(self.closeBtn)
        let sendCodeBtnH = 45/WIDTH_6_SCALE
        let sendCodeBtnW = 110/WIDTH_6_SCALE
        self.sureBtn.frame = CGRect(x: self.whiteBGView.width - 15/WIDTH_6_SCALE - sendCodeBtnW, y: (self.whiteBGView.height - self.topImgView.height - sendCodeBtnH)/2 + self.topImgView.height, width: sendCodeBtnW, height: sendCodeBtnH)
        self.textBgView.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 0, width: self.whiteBGView.width - 45/WIDTH_6_SCALE - self.sureBtn.width, height: self.sureBtn.height)
        self.textBgView.centerY = self.sureBtn.centerY
        self.codeTextField.frame = CGRect(x: 5, y: 5, width: self.textBgView.width - 10, height: self.textBgView.height - 10)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension LiveClassPhoneView{

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
        self.liveClassPhoneViewDismissBlock?()
    }
    
    @objc func closeBtnClick(btn: UIButton){
        self.dismissView()
    }
    
    @objc func sureBtnClick(){
        if self.codeTextField.text!.isEmpty {
            HUD.showText(text: "请填写手机号码")
            return
        }
        self.sureBtnClickBlock?(self.codeTextField.text!)
    }
}
