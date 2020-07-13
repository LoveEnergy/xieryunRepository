//
//  LearnCardActiveView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/3.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LearnCardActiveView: UIView {
    public var learnCardActiveViewDismissBlock:(()->())?//消失
    public var learnCardActiveViewSubmitBlock:((String, String, String)->())?//卡号、激活码、提示信息
    private var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0, width: viewWidth, height: 200.0))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_16
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "开课卡开课"
        return titleLab
    }()
    lazy var cardIDTitleLab : UILabel = {
        var cardIDTitleLab = UILabel.init()
        cardIDTitleLab.font = DEF_FontSize_14
        cardIDTitleLab.backgroundColor = .clear
        cardIDTitleLab.textColor = .black
        cardIDTitleLab.textAlignment = .left
        cardIDTitleLab.text = "请输入卡号:"
        return cardIDTitleLab
    }()
    lazy var activeCodeTitleLab : UILabel = {
        var activeCodeTitleLab = UILabel.init()
        activeCodeTitleLab.font = DEF_FontSize_14
        activeCodeTitleLab.backgroundColor = .clear
        activeCodeTitleLab.textColor = .black
        activeCodeTitleLab.textAlignment = .left
        activeCodeTitleLab.text = "请输入激活码:"
        return activeCodeTitleLab
    }()
    
    lazy var cardIDTextfield : UITextField = {
        var cardIDTextfield = UITextField.init()
        cardIDTextfield.font = DEF_FontSize_14
        cardIDTextfield.backgroundColor = .clear
        cardIDTextfield.textColor = .black
        cardIDTextfield.textAlignment = .left
        cardIDTextfield.placeholder = "请输入卡号"
        cardIDTextfield.layer.borderColor = UIColor.lightGray.cgColor
        cardIDTextfield.layer.borderWidth = 0.8
        cardIDTextfield.layer.cornerRadius = 4
        cardIDTextfield.layer.masksToBounds = true
        return cardIDTextfield
    }()
    
    lazy var closeBtn : UIButton = {
        weak var weakSelf = self
        let btnW = 25/WIDTH_6_SCALE
        var closeBtn = UIButton.init(frame: CGRect(x: (weakSelf?.whiteBGView.width)! - btnW - 10/WIDTH_6_SCALE, y: 0, width: btnW, height: btnW))
        closeBtn.setImage(UIImage.init(named: "circle_close"), for: .normal)
        closeBtn.setBackgroundColor(.clear, forState: .normal)
        closeBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
        return closeBtn
    }()
    
    lazy var activeCodeTextfield : UITextField = {
        var activeCodeTextfield = UITextField.init()
        activeCodeTextfield.font = DEF_FontSize_14
        activeCodeTextfield.backgroundColor = .clear
        activeCodeTextfield.textColor = .black
        activeCodeTextfield.textAlignment = .left
        activeCodeTextfield.placeholder = "请输入激活码"
        activeCodeTextfield.layer.borderColor = UIColor.lightGray.cgColor
        activeCodeTextfield.layer.borderWidth = 0.8
        activeCodeTextfield.layer.cornerRadius = 4
        activeCodeTextfield.layer.masksToBounds = true
        return activeCodeTextfield
    }()
    
    lazy var sureBtn : UIButton = {
        var sureBtn = UIButton.init()
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.black, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_14
        sureBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        sureBtn.layer.cornerRadius = 4
        sureBtn.layer.masksToBounds = true
        sureBtn.layer.borderWidth = 0.8
        sureBtn.layer.borderColor = UIColor.lightGray.cgColor
        sureBtn.addTarget(self, action: #selector(sureBtnClick(btn:)), for: .touchUpInside)
        return sureBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.whiteBGView)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        whiteBGView.addSubview(self.titleLab)
        whiteBGView.addSubview(self.cardIDTitleLab)
        whiteBGView.addSubview(self.activeCodeTitleLab)
        whiteBGView.addSubview(self.cardIDTextfield)
        whiteBGView.addSubview(self.activeCodeTextfield)
        whiteBGView.addSubview(self.closeBtn)
        whiteBGView.addSubview(self.sureBtn)

        titleLab.frame = CGRect(x: 0, y: 10/WIDTH_6_SCALE, width: self.whiteBGView.width, height: 35/WIDTH_6_SCALE)
        cardIDTitleLab.frame = CGRect(x: 16/WIDTH_6_SCALE, y: self.titleLab.bottom + 25/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
        activeCodeTitleLab.frame = CGRect(x: self.cardIDTitleLab.left, y: self.cardIDTitleLab.bottom + 10/WIDTH_6_SCALE, width: self.cardIDTitleLab.width, height: self.cardIDTitleLab.height)
        cardIDTextfield.frame = CGRect(x: self.cardIDTitleLab.right + 10/WIDTH_6_SCALE, y: self.cardIDTitleLab.top, width: self.whiteBGView.width - self.cardIDTitleLab.right - 20/WIDTH_6_SCALE, height: self.cardIDTitleLab.height)
        activeCodeTextfield.frame = CGRect(x: self.cardIDTextfield.left, y: self.activeCodeTitleLab.top, width: self.cardIDTextfield.width, height: self.cardIDTextfield.height)
        let sureBtnW = 100/WIDTH_6_SCALE
        sureBtn.frame = CGRect(x: (self.whiteBGView.width - sureBtnW)/2, y: activeCodeTextfield.bottom + 25/WIDTH_6_SCALE, width: sureBtnW, height: 40/WIDTH_6_SCALE)
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        whiteBGView.frame = CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0, width: viewWidth, height: sureBtn.bottom + 25/WIDTH_6_SCALE)
        self.closeBtn.centerY = self.titleLab.centerY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
}
extension LearnCardActiveView{
    @objc func btnClick(btn:UIButton){
//        self.dismissView()
    }
    @objc func cancelBtnClick(btn:UIButton){
        self.dismissView()
    }
    @objc func submitBtnClick(btn:UIButton){
//        self.fillInReferrerViewInfoBlock?(self.nameTextField.text!)
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
        self.learnCardActiveViewDismissBlock!()
    }
    @objc func sureBtnClick(btn: UIButton){
        if self.cardIDTextfield.text!.isEmpty || self.activeCodeTextfield.text!.isEmpty {
            self.learnCardActiveViewSubmitBlock?("", "", "请正确填写信息")
            return
        }
        self.learnCardActiveViewSubmitBlock?(self.cardIDTextfield.text!, self.activeCodeTextfield.text!, "")
    }
}
