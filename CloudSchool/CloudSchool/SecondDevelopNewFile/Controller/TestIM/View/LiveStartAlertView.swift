//
//  LiveStartAlertView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/29.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LiveStartAlertView: UIView {
    public var backBtnClickBlock:(()->())?
    public var startBtnClickBlock:((String)->())?
    lazy var backBtn : UIButton = {
        var backBtn = UIButton.init(frame: CGRect(x: 30/WIDTH_6_SCALE, y: 40/WIDTH_6_SCALE, width: 30/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "live_close"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        backBtn.backgroundColor = .clear
        return backBtn
    }()
    lazy var startBtn : UIButton = {
        var startBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 142.5/WIDTH_6_SCALE, height: 45/WIDTH_6_SCALE))
        startBtn.centerX = SCREEN_WIDTH/2
        startBtn.centerY = SCREEN_HEIGHT/2 + 30/WIDTH_6_SCALE
        startBtn.setImage(UIImage.init(named: "live_start"), for: .normal)
        startBtn.addTarget(self, action: #selector(startBtnClick(btn:)), for: .touchUpInside)
        return startBtn
    }()
    lazy var liveURLTextfield: UITextField = {
        var liveURLTextfield = UITextField.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self.textfieldBGView.width - 20/WIDTH_6_SCALE, height: self.textfieldBGView.height))
        liveURLTextfield.font = DEF_FontSize_14
        liveURLTextfield.placeholder = "请填写直播地址"
        liveURLTextfield.textAlignment = .left
        liveURLTextfield.textColor = .black
        liveURLTextfield.isUserInteractionEnabled = true
        return liveURLTextfield
    }()
    lazy var textfieldBGView : UIView = {
        var textfieldBGView = UIView.init(frame: CGRect(x: 100/WIDTH_6_SCALE, y: self.startBtn.top - 80/WIDTH_6_SCALE, width: SCREEN_WIDTH - 200/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        textfieldBGView.backgroundColor = UIColor.white
        textfieldBGView.layer.cornerRadius = 4
        textfieldBGView.layer.masksToBounds = true
        return textfieldBGView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.backBtn)
        self.addSubview(self.startBtn)
        self.addSubview(self.textfieldBGView)
        self.textfieldBGView.addSubview(self.liveURLTextfield)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LiveStartAlertView{
    @objc func backBtnClick(){
        self.backBtnClickBlock?()
    }
    @objc func startBtnClick(btn: UIButton){
        if self.liveURLTextfield.text?.count == 0{
            HUD.showText(text: "请填写直播地址")
            return
        }
        if self.isIncludeChineseIn(string: self.liveURLTextfield.text!){
            HUD.showText(text: "请正确填写直播地址")
            return
        }
        self.startBtnClickBlock?(self.liveURLTextfield.text!)
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
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    //判断是否包含汉字
    func isIncludeChineseIn(string: String) -> Bool {
        for (_, value) in string.characters.enumerated() {
            if ("\u{4E00}" <= value  && value <= "\u{9FA5}") {
                return true
            }
        }
        return false
    }
}
