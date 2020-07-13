//
//  BaseTitleInputView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class BaseTitleInputView: UIView {
    public var selectAddressBlock:(()->())?//选择地址
    public var selectBirthDayBlock:(()->())?//选择生日
    var isLady: Bool = false//是否是女
    var isStay: Bool = false//是否留宿
    var title: String = "" {
        didSet {
            titleLabel.text = title
            self.sexView.isHidden = true
            self.addressBtn.isHidden = true
            self.birthDayBtn.isHidden = true
            self.settleView.isHidden = true
            if title == "性别" {
                self.sexView.isHidden = false
                self.textField.isUserInteractionEnabled = false
                self.insertSubview(self.textField, belowSubview: self.sexView)
            }else if title == "省市县"{
                self.addressBtn.isHidden = false
            }else if title == "出生年月"{
                self.birthDayBtn.isHidden = false
            }else if title == "是否需要协助安排住宿"{
                self.settleView.isHidden = false
                self.textField.isUserInteractionEnabled = false
                self.insertSubview(self.textField, belowSubview: self.settleView)
            }else{
                self.textField.isUserInteractionEnabled = true
                self.insertSubview(self.sexView, belowSubview: self.textField)
            }
        }
    }
    
    var placeHolder: String = "" {
        didSet {
            textField.placeholder = placeHolder
        }
    }
    
    var value: String = "" {
        didSet {
            textField.text = value
            if self.property == "sex" {
                if value == "1" || value == ""{
                    self.isLady = false
                    self.textField.text = "1"
                    self.manBtn.isSelected = true
                    self.ladyBtn.isSelected = false
                }else{
                    self.isLady = true
                    self.textField.text = "2"
                    self.manBtn.isSelected = false
                    self.ladyBtn.isSelected = true
                }
            }
            if self.property == "stay" {
                if value == "1" || value == ""{
                    self.isStay = false
                    self.textField.text = "1"
                    self.trueSettleBtn.isSelected = true
                    self.falseSettleBtn.isSelected = false
                }else{
                    self.isStay = true
                    self.textField.text = "2"
                    self.trueSettleBtn.isSelected = false
                    self.falseSettleBtn.isSelected = true
                }
            }
        }
    }
    
    var property: String = ""
    var isMust: Bool = false
    
    var propertyDic: [String:Any] {
        var isMustInt = 0
        if self.isMust == true {
            isMustInt = 1
        }
        return ["property":self.property, "displayName":self.title, "value":self.textField.text ?? "", "isMustFill": isMustInt]
    }

    let textField: BaseTextField = {
        let textfield = BaseTextField()
        return textfield
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.titleColor
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    let startLabel: UILabel = {
        let startLabel = UILabel()
        startLabel.textColor = UIColor.red
        startLabel.font = UIFont.systemFont(ofSize: 15)
        startLabel.textAlignment = .center
        startLabel.text = "*"
        return startLabel
    }()
    
    lazy var sexView : UIView = {
        weak var weakSelf = self
        var sexView = UIView.init()
        sexView.isHidden = true
        sexView.backgroundColor = UIColor.white
        var buttonTitleArr = ["男", "女"]
        var buttonArr: [RadioButton] = [RadioButton]()
        for item in 0...buttonTitleArr.count - 1{
            var radioBtn = RadioButton.init(frame: .zero)
            radioBtn.addTarget(self, action: #selector(sexViewOnRadioButtonValueChanged(sender:)), for: .touchUpInside)
            radioBtn.setTitle(buttonTitleArr[item], for: .normal)
            radioBtn.setTitleColor(.black, for: .normal)
            radioBtn.setImage(UIImage.init(named: "signleUnselect"), for: .normal)
            radioBtn.setImage(UIImage.init(named: "signleSelect"), for: .selected)
            radioBtn.contentHorizontalAlignment = .left
            radioBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
            sexView.addSubview(radioBtn)
            buttonArr.append(radioBtn)
            radioBtn.tag = 1000 + item
        }
        buttonArr[0].groupButtons = buttonArr
        buttonArr[0].isSelected = true
        weakSelf?.manBtn = buttonArr[0]
        weakSelf?.ladyBtn = buttonArr[1]
        weakSelf?.textField.text = "1"
        return sexView
    }()
    
    lazy var settleView : UIView = {//是否需要协助安排住宿
        weak var weakSelf = self
        var settleView = UIView.init()
        settleView.isHidden = true
        settleView.backgroundColor = UIColor.white
        var buttonTitleArr = ["是", "否"]
        var buttonArr: [RadioButton] = [RadioButton]()
        for item in 0...buttonTitleArr.count - 1{
            var radioBtn = RadioButton.init(frame: .zero)
            radioBtn.addTarget(self, action: #selector(settleViewOnRadioButtonValueChanged(sender:)), for: .touchUpInside)
            radioBtn.setTitle(buttonTitleArr[item], for: .normal)
            radioBtn.setTitleColor(.black, for: .normal)
            radioBtn.setImage(UIImage.init(named: "signleUnselect"), for: .normal)
            radioBtn.setImage(UIImage.init(named: "signleSelect"), for: .selected)
            radioBtn.contentHorizontalAlignment = .left
            radioBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 0)
            settleView.addSubview(radioBtn)
            buttonArr.append(radioBtn)
            radioBtn.tag = 2000 + item
        }
        buttonArr[0].groupButtons = buttonArr
        buttonArr[0].isSelected = true
        weakSelf?.trueSettleBtn = buttonArr[0]
        weakSelf?.falseSettleBtn = buttonArr[1]
        weakSelf?.textField.text = "1"
        return settleView
    }()
    
    lazy var addressBtn : UIButton = {
        var addressBtn = UIButton.init(frame: .zero)
        addressBtn.isHidden = true
        addressBtn.addTarget(self, action: #selector(addressBtnClick), for: .touchUpInside)
        return addressBtn
    }()
    
    lazy var birthDayBtn : UIButton = {
        var birthDayBtn = UIButton.init(frame: .zero)
        birthDayBtn.isHidden = true
        birthDayBtn.addTarget(self, action: #selector(birthDayBtnClick), for: .touchUpInside)
        return birthDayBtn
    }()
    
    lazy var ladyBtn : UIButton = {
        var ladyBtn = UIButton.init()
        return ladyBtn
    }()
    
    lazy var manBtn : UIButton = {
        var manBtn = UIButton.init()
        return manBtn
    }()
    
    lazy var trueSettleBtn : UIButton = {
        var trueSettleBtn = UIButton.init()
        return trueSettleBtn
    }()
    
    lazy var falseSettleBtn : UIButton = {
        var falseSettleBtn = UIButton.init()
        return falseSettleBtn
    }()
    
    
    
    let line = LineView()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseConfigure()
    }
    
    func baseConfigure() {
        addSubview(startLabel)
        addSubview(textField)
        addSubview(titleLabel)
        addSubview(line)
        addSubview(sexView)
        addSubview(settleView)
        addSubview(addressBtn)
        addSubview(birthDayBtn)
        startLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.equalTo(20)
            make.left.equalTo(self).offset(0)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.width.equalTo(95)
            make.left.equalTo(self).offset(20)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.bottom.equalTo(self)
            make.right.equalTo(self)
            make.height.equalTo(0.5)
        }
        
        textField.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.height.equalTo(self)
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-13)
        }
        
        sexView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-13)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-1)
        }
        
        manBtn.snp.makeConstraints { (make) in
            make.left.equalTo(sexView.snp.left).offset(10)
            make.width.equalTo(50)
            make.top.bottom.equalTo(sexView)
        }
        ladyBtn.snp.makeConstraints { (make) in
            make.left.equalTo(manBtn.snp.right).offset(10)
            make.width.equalTo(50)
            make.top.bottom.equalTo(sexView)
        }
        
        settleView.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-13)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-1)
        }
        
        trueSettleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(settleView.snp.left).offset(10)
            make.width.equalTo(50)
            make.top.bottom.equalTo(sexView)
        }
        falseSettleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(trueSettleBtn.snp.right).offset(10)
            make.width.equalTo(50)
            make.top.bottom.equalTo(sexView)
        }
        
        addressBtn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-13)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-1)
        }
        
        birthDayBtn.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(20)
            make.right.equalTo(self.snp.right).offset(-13)
            make.centerY.equalTo(self)
            make.height.equalTo(self).offset(-1)
        }
    }

}

extension BaseTitleInputView{
    @objc func sexViewOnRadioButtonValueChanged(sender: RadioButton){
        if (sender.tag == 1000){
            self.textField.text = "1"
        }
        if (sender.tag == 1001){
            self.textField.text = "2"
        }
    }
    
    @objc func settleViewOnRadioButtonValueChanged(sender: RadioButton){//是否需要协助安排住宿选择
        if (sender.tag == 2000){
            self.textField.text = "1"
        }
        if (sender.tag == 2001){
            self.textField.text = "2"
        }
    }
    
    @objc func addressBtnClick(){
        self.selectAddressBlock?()
    }
    
    @objc func birthDayBtnClick(){
        self.selectBirthDayBlock?()
    }
}
