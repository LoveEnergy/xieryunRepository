//
//  BindExistAccountAlertView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/8.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class BindExistAccountAlertView: UIView {
    public var bindExistAccountAlertCancelBlock:(()->())?//取消
    public var bindExistAccountAlertSureBlock:((String, String)->())?//确定
    lazy var whiteBGView : UIView = {
        var whiteBGView = UIView.init()
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    
    lazy var phoneTextField: UITextField = {
        var phoneTextField = UITextField.init()
        phoneTextField.placeholder = "请输入账号"
        phoneTextField.font = DEF_FontSize_14
        phoneTextField.textAlignment = .left
        return phoneTextField
    }()
    
    lazy var phoneBgView : UIView = {
        var phoneBgView = UIView.init()
        phoneBgView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        phoneBgView.layer.borderWidth = 0.8
        phoneBgView.layer.cornerRadius = 4
        phoneBgView.layer.masksToBounds = true
        return phoneBgView
    }()
    
    lazy var codeTextField: UITextField = {
        var codeTextField = UITextField.init()
        codeTextField.placeholder = "请输入密码"
        codeTextField.font = DEF_FontSize_14
        codeTextField.textAlignment = .left
        return codeTextField
    }()
    
    lazy var codeBgView : UIView = {
        var codeBgView = UIView.init()
        codeBgView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        codeBgView.layer.borderWidth = 0.8
        codeBgView.layer.cornerRadius = 4
        codeBgView.layer.masksToBounds = true
        return codeBgView
    }()
    
    lazy var sureBtn: UIButton = {
        var sureBtn = UIButton.init()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_14
        sureBtn.setBackgroundColor(UIColor.colorWithHex(hex: "1FA2F8"), forState: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        return sureBtn
    }()
    
    lazy var cancelBtn: UIButton = {
        var cancelBtn = UIButton.init()
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
        self.whiteBGView.addSubview(self.phoneBgView)
        self.whiteBGView.addSubview(self.codeBgView)
        self.whiteBGView.addSubview(self.sureBtn)
        self.whiteBGView.addSubview(self.cancelBtn)
        self.phoneBgView.addSubview(self.phoneTextField)
        self.codeBgView.addSubview(self.codeTextField)
        
        self.setUpFrame()
    }
    
    func setUpFrame(){
        let whiteViewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        let textFieldBgViewX = 15/WIDTH_6_SCALE
        let textFieldBgViewH = 40/WIDTH_6_SCALE
        let textFieldBgViewY = 20/WIDTH_6_SCALE
        self.whiteBGView.frame = CGRect(x: (SCREEN_WIDTH - whiteViewWidth)/2, y: 200.0/WIDTH_6_SCALE, width: whiteViewWidth, height: 190.0/WIDTH_6_SCALE)
        self.phoneBgView.frame = CGRect(x: textFieldBgViewX, y: textFieldBgViewY, width: self.whiteBGView.width - 2 * textFieldBgViewX, height: textFieldBgViewH)
        self.phoneTextField.frame = CGRect(x: 5/WIDTH_6_SCALE, y: 0, width: self.phoneBgView.width - 10/WIDTH_6_SCALE, height: self.phoneBgView.height)
        self.codeBgView.frame = CGRect(x: self.phoneBgView.left, y: self.phoneBgView.bottom + 15/WIDTH_6_SCALE, width: self.phoneBgView.width, height: self.phoneBgView.height)
        self.codeTextField.frame = CGRect(x: self.phoneTextField.left, y: 0, width: self.phoneTextField.width, height: self.codeBgView.height)
        self.sureBtn.frame = CGRect(x: 0, y: self.codeBgView.bottom + 20/WIDTH_6_SCALE, width: self.whiteBGView.width/2, height: self.whiteBGView.height - self.codeBgView.bottom - 15/WIDTH_6_SCALE)
        self.cancelBtn.frame = CGRect(x: self.sureBtn.right, y: self.sureBtn.top, width: self.sureBtn.width, height: self.sureBtn.height)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BindExistAccountAlertView{
    @objc func sureBtnClick(){
        if self.phoneTextField.text!.count < 1 || self.codeTextField.text!.isEmpty {
            HUD.showText(text: "请正确填写账号和密码")
            return
        }
        self.bindExistAccountAlertSureBlock?(self.phoneTextField.text!, self.codeTextField.text!)
    }
    
    @objc func cancelBtnClick(){
        self.bindExistAccountAlertCancelBlock?()
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
}
