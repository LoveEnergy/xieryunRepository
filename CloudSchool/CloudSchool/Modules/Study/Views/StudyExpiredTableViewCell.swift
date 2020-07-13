
//
//  StudyExpiredTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/22.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class StudyExpiredTableViewCell: UITableViewCell {
    public var supplyDelayBlock:(()->())?//申请延期
    public var supplyBuyAgainBlock:(()->())?//再次购买
    var model: ClassModel?{
        didSet{
            self.iconView.loadImage(string: model?.previewImgUrl)
            self.titleLab.text = model?.productName
            self.scoreLab.text = "得分：\(model?.schedule ?? "0")/100"
            self.titleLab.frame = CGRect(x: self.iconView.right + 8, y: self.iconView.top, width: SCREEN_WIDTH - self.iconView.right - 8 - 10, height: self.getLabelHeight(label: self.titleLab, string: model?.productName ?? "", font: 15, textAlignment: .left, width: SCREEN_WIDTH - self.iconView.right - 8 - 10))
            self.scoreLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 10, width: self.titleLab.width, height: 15/WIDTH_6_SCALE)
            self.delayBtn.frame = CGRect(x: self.titleLab.left, y: self.scoreLab.bottom + 10, width: 60, height: 25)
            self.buyAgainBtn.frame = self.delayBtn.frame
            self.delayBtn.isHidden = true
            self.buyAgainBtn.isHidden = true
            if model?.status == 0 {
                self.delayBtn.isHidden = false
                self.buyAgainBtn.isHidden = true
            }else{
                self.delayBtn.isHidden = true
                self.buyAgainBtn.isHidden = false
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.lineView.frame = CGRect(x: 16, y: 110 - 1, width: SCREEN_WIDTH - 20, height: 1)
        self.iconView.frame = CGRect(x: self.lineView.left, y: 0, width: 124, height: 124*0.78)
        self.iconView.centerY = 110/2
        self.titleLab.frame = CGRect(x: self.iconView.right + 8, y: self.iconView.top, width: SCREEN_WIDTH - self.iconView.right - 8 - 10, height: 15/WIDTH_6_SCALE)
        self.scoreLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 10, width: self.titleLab.width, height: 15/WIDTH_6_SCALE)
        self.delayBtn.frame = CGRect(x: self.titleLab.left, y: self.scoreLab.bottom + 10, width: 60, height: 25)
        self.buyAgainBtn.frame = self.delayBtn.frame
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.scoreLab)
        self.contentView.addSubview(self.delayBtn)
        self.contentView.addSubview(self.buyAgainBtn)
    }
    
    lazy var iconView : UIImageView = {
        var iconView = UIImageView.init()
        iconView.backgroundColor = UIColor.gray
        return iconView
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "f6f6f6")
        return lineView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "土壤污染状况调查和监测法"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 2
        titleLab.sizeToFit()
        return titleLab
    }()
    
    lazy var scoreLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_13
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "7a7a7a")
        titleLab.textAlignment = .left
        titleLab.text = "得分:6.25/100"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    
    lazy var delayBtn : UIButton = {
        var btn = UIButton.init()
        btn.setTitle("申请延期", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.titleLabel?.font = DEF_FontSize_12
        btn.setBackgroundColor(UIColor.colorWithHex(hex: "0378FD"), forState: .normal)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.addTarget(self, action: #selector(delayBtnClick), for: .touchUpInside)
        return btn
    }()
    
    lazy var buyAgainBtn : UIButton = {
        var btn = UIButton.init()
        btn.setTitle("再次购买", for: .normal)
        btn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        btn.titleLabel?.font = DEF_FontSize_12
        btn.setBackgroundColor(.white, forState: .normal)
        btn.layer.cornerRadius = 4
        btn.layer.masksToBounds = true
        btn.layer.borderColor = UIColor.colorWithHex(hex: "0378FD").cgColor
        btn.layer.borderWidth = 0.8
        btn.addTarget(self, action: #selector(buyAgainBtnClick), for: .touchUpInside)
        return btn
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //label高度
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
    
    @objc func delayBtnClick(){
        self.supplyDelayBlock?()
    }
    
    @objc func buyAgainBtnClick(){
        self.supplyBuyAgainBlock?()
    }
}
