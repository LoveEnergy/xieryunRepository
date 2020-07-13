//
//  ClassInfoAlertView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ClassInfoAlertView: UIView {
    public var classInfoAlertViewDismissBlock:(()->())?
    public var classInfoAlertSureClassBlock:(()->())?
    public var classInfoAlertViewCancelBlock:(()->())?
    var liveClassName: String = ""
    lazy var classNameLab : UILabel = {
        var classNameLab = UILabel.init()
        classNameLab.font = DEF_FontSize_16
        classNameLab.backgroundColor = .clear
        classNameLab.textColor = .white
        classNameLab.textAlignment = .center
        classNameLab.text = "aaa"
        classNameLab.lineBreakMode = .byWordWrapping
        classNameLab.numberOfLines = 0
        classNameLab.sizeToFit()
        classNameLab.font = UIFont.boldSystemFont(ofSize: 20)
        return classNameLab
    }()
    lazy var sureClassBtn : UIButton = {
        var sureClassBtn = UIButton.init()
        sureClassBtn.setTitle("确认课程", for: .normal)
        sureClassBtn.setTitleColor(UIColor.white, for: .normal)
        sureClassBtn.titleLabel?.font = DEF_FontSize_16
        sureClassBtn.setBackgroundColor(UIColor.colorWithHex(hex: "0378fd"), forState: .normal)
        sureClassBtn.layer.cornerRadius = 10
        sureClassBtn.layer.masksToBounds = true
        sureClassBtn.addTarget(self, action: #selector(sureClassBtnClick), for: .touchUpInside)
        return sureClassBtn
    }()
    lazy var cancelClassBtn: UIButton = {
        var cancelClassBtn = UIButton.init()
        cancelClassBtn.setTitle("取消直播", for: .normal)
        cancelClassBtn.setTitleColor(UIColor.white, for: .normal)
        cancelClassBtn.titleLabel?.font = DEF_FontSize_16
        cancelClassBtn.setBackgroundColor(UIColor.colorWithHex(hex: "0378fd"), forState: .normal)
        cancelClassBtn.layer.cornerRadius = 10
        cancelClassBtn.layer.masksToBounds = true
        cancelClassBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        return cancelClassBtn
    }()
    init(frame: CGRect, className: String){
        super.init(frame: frame)
        self.liveClassName = className
        let btn = UIButton.init(frame: self.bounds)
        self.addSubview(btn)
        self.addSubview(self.classNameLab)
        self.addSubview(self.sureClassBtn)
        self.addSubview(self.cancelClassBtn)
        self.classNameLab.frame = CGRect(x: 16/WIDTH_6_SCALE, y: SCREEN_HEIGHT/2 - 50/WIDTH_6_SCALE, width: SCREEN_WIDTH - 32/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.sureClassBtn.frame = CGRect(x: 16/WIDTH_6_SCALE, y: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - 50/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - 24/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.cancelClassBtn.frame = CGRect(x: SCREEN_WIDTH/2 + 8/WIDTH_6_SCALE, y: self.sureClassBtn.top, width: self.sureClassBtn.width, height: self.sureClassBtn.height)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.classNameLab.text = self.liveClassName
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func cancelBtnClick(){
        self.classInfoAlertViewCancelBlock?()
    }
    func dismissView(){
        self.classInfoAlertViewDismissBlock?()
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
    @objc func sureClassBtnClick(){
        self.classInfoAlertSureClassBlock?()
    }
    //效果最佳
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
}
