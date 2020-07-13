//
//  FillInReferrerView.swift
//  CloudSchool
//
//  Created by ENERGY on 2019/12/30.
//  Copyright © 2019 CEI. All rights reserved.
//  填写推荐人

import UIKit

class FillInReferrerView: UIView {
    public var fillInReferrerViewDismissBlock:(()->())?//消失
    public var fillInReferrerViewInfoBlock:((String)->())?//推荐人内容
    var nameTitleW : CGFloat = 0
    var nameTextFieldW : CGFloat = 0
    private var whiteBGView : UIView = {
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        var whiteBGView = UIView.init(frame: CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0, width: viewWidth, height: 200.0))
        whiteBGView.backgroundColor = .white
        whiteBGView.layer.cornerRadius = 6
        whiteBGView.layer.masksToBounds = true
        return whiteBGView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_16
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "推荐人"
        return titleLab
    }()
    lazy var topLineView : UIView = {
        let topLineView = UIView.init(frame:CGRect(x: 0, y: self.titleLab.bottom + 30/WIDTH_6_SCALE, width: self.whiteBGView.width, height: 1.0))
        topLineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return topLineView
    }()
    lazy var nameTitleLab : UILabel = {
        var nameTitleLab = UILabel.init(frame:CGRect(x: self.nameBorderView.left - 5/WIDTH_6_SCALE - self.nameTitleW, y: self.nameBorderView.top, width:self.nameTitleW, height: 20/WIDTH_6_SCALE))
        nameTitleLab.centerY = self.nameBorderView.centerY
        nameTitleLab.font = DEF_FontSize_14
        nameTitleLab.backgroundColor = .clear
        nameTitleLab.textColor = .black
        nameTitleLab.textAlignment = .left
        nameTitleLab.text = "推荐人:"
        return nameTitleLab
    }()
    lazy var nameBorderView : UIView = {
        let nameBorderView = UIView.init(frame:CGRect(x: (self.whiteBGView.width - self.nameTextFieldW - self.nameTitleW - 5/WIDTH_6_SCALE)/2 + self.nameTitleW + 5/WIDTH_6_SCALE, y: self.topLineView.bottom + 20/WIDTH_6_SCALE, width: self.nameTextFieldW, height: 20/WIDTH_6_SCALE + 15/WIDTH_6_SCALE))
        nameBorderView.layer.borderColor = UIColor.colorWithHex(hex: "#e8e8e8").cgColor
        nameBorderView.layer.borderWidth = 1
        nameBorderView.layer.cornerRadius = 4
        nameBorderView.layer.masksToBounds = true
        return nameBorderView
    }()
    lazy var nameTextField : UITextField = {
        var nameTextField = UITextField.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self.nameBorderView.width - 15/WIDTH_6_SCALE, height: self.nameBorderView.height))
        nameTextField.backgroundColor = .clear
        return nameTextField
    }()
    lazy var bottomLineView : UIView = {
        var bottomLineView = UIView.init(frame: CGRect(x: 0, y: self.nameBorderView.bottom + 30/WIDTH_6_SCALE, width: self.topLineView.width, height: 1/WIDTH_6_SCALE))
        bottomLineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return bottomLineView
    }()
    lazy var cancelBtn : UIButton = {
        var cancelBtn = UIButton.init(frame: CGRect(x: 0, y: self.bottomLineView.bottom, width: self.whiteBGView.width/2, height: 40/WIDTH_6_SCALE))
        cancelBtn.setTitle("跳过", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.setBackgroundColor(.white, forState: .normal)
        cancelBtn.titleLabel?.font = DEF_FontSize_14
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
        return cancelBtn
    }()
    
    lazy var submitBtn : UIButton = {
        var submitBtn = UIButton.init(frame: CGRect(x: self.cancelBtn.right, y: self.cancelBtn.top, width: self.cancelBtn.width, height: self.cancelBtn.height))
        submitBtn.setTitle("提交", for: .normal)
        submitBtn.setTitleColor(.white, for: .normal)
        submitBtn.setBackgroundColor(UIColor.ColorHex("#4aa1f1"), forState: .normal)
        submitBtn.titleLabel?.font = DEF_FontSize_14
        submitBtn.adjustsImageWhenHighlighted = false
        submitBtn.addTarget(self, action: #selector(submitBtnClick(btn:)), for: .touchUpInside)
        return submitBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.whiteBGView)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        //高度
        self.nameTitleW = self.getLabelWidth(text: "推荐人:", font: DEF_FontSize_14, height: 20/WIDTH_6_SCALE)
        self.nameTextFieldW = self.whiteBGView.width - self.nameTitleW - 40/WIDTH_6_SCALE - 5/WIDTH_6_SCALE
        
        self.whiteBGView.addSubview(self.titleLab)
        self.whiteBGView.addSubview(self.topLineView)
        self.whiteBGView.addSubview(self.nameBorderView)
        self.whiteBGView.addSubview(self.nameTitleLab)
        self.nameBorderView.addSubview(self.nameTextField)
        self.whiteBGView.addSubview(self.bottomLineView)
        self.whiteBGView.addSubview(self.cancelBtn)
        self.whiteBGView.addSubview(self.submitBtn)
        
        let viewWidth = CGFloat(SCREEN_WIDTH - 50/WIDTH_6_SCALE)
        self.whiteBGView.frame = CGRect(x: (SCREEN_WIDTH - viewWidth)/2, y: 200.0, width: viewWidth, height: self.submitBtn.bottom)
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
extension FillInReferrerView{
    @objc func btnClick(btn:UIButton){
//        self.dismissView()
    }
    @objc func cancelBtnClick(btn:UIButton){
        self.dismissView()
    }
    @objc func submitBtnClick(btn:UIButton){
        self.fillInReferrerViewInfoBlock?(self.nameTextField.text!)
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
        self.fillInReferrerViewDismissBlock!()
    }
}
