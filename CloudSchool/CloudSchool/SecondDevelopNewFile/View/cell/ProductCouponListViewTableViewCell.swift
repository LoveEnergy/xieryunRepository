//
//  ProductCouponListViewTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/10.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ProductCouponListViewTableViewCell: UITableViewCell {
    let borderX = 18.5/WIDTH_6_SCALE
    let bgBorderX = 15/WIDTH_6_SCALE
    public var couponBtnClickBlock:(()->())?
    var couponListModel : NewCouponList? {
        didSet{
            guard let couponListModel = couponListModel else { return }
            self.fullLab.isHidden = false
            bgView.image = UIImage.init(named: "coupon_usual_go_use_bg")
            var productScopeString = ""
            var couponTypeString = ""
            if couponListModel.productScope == 0 {
                productScopeString = "全部品类"
            }
            if couponListModel.productScope == 1 {
                productScopeString = "课程"
            }
            if couponListModel.productScope == 2 {
                productScopeString = "书籍"
            }
            if couponListModel.productScope == 3 {
                productScopeString = "班级"
            }
            if couponListModel.productScope == 4 {
                productScopeString = "直播"
            }
            if couponListModel.productScope == 5 {
                productScopeString = "书籍"
            }
            if couponListModel.productScope == 6 {
                productScopeString = "指定产品"
            }
            if couponListModel.couponType == 0 {//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
                couponTypeString = "全部用户"
            }
            if couponListModel.couponType == 1 {//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
                couponTypeString = "新用户"
            }
            if couponListModel.couponType == 2 {//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
                couponTypeString = "VIP用户"
            }
            if couponListModel.couponType == 3 {//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
                couponTypeString = "指定用户"
            }
            self.titleLab.text = "\(productScopeString)\(couponTypeString)"
            self.dateLab.text = "\(couponListModel.receiveStartTime) - \(couponListModel.receiveEndTime)"
            self.lastDayLab.text = "仅剩\(couponListModel.validDate)天"
            if couponListModel.couponType == 1 {
                self.reduceLab.text = "￥\(couponListModel.reductionPrice)"//减去的价格
                self.fullLab.text = "满\(couponListModel.totalPrice)元可用"//总价
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(couponListModel.reductionPrice)")
            }
            if couponListModel.couponType == 2 {
                self.fullLab.isHidden = true
                self.reduceLab.text = "￥\(couponListModel.reductionPrice)"//代金券
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(couponListModel.reductionPrice)")
            }
            if couponListModel.couponType == 3 {
                self.reduceLab.text = "\(couponListModel.discountRate)折"//折扣
                self.fullLab.text = "满\(couponListModel.totalPrice)元可用"//总价
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(couponListModel.discountRate)")
            }
            if couponListModel.couponType == 4 {
                self.reduceLab.text = "￥0"//包邮券
                self.fullLab.text = "运费"
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "0")
            }
            
        }
    }
    var model : NewCouponList? {
        didSet{
            guard let model = model else { return }
            self.fullLab.isHidden = false
            bgView.image = UIImage.init(named: "coupon_usual_go_use_bg")
            var productScopeString = ""
            var couponTypeString = ""
            if model.productScope == 0 {
                productScopeString = "全部品类"
            }
            if model.productScope == 1 {
                productScopeString = "课程"
            }
            if model.productScope == 2 {
                productScopeString = "书籍"
            }
            if model.productScope == 3 {
                productScopeString = "班级"
            }
            if model.productScope == 4 {
                productScopeString = "直播"
            }
            if model.productScope == 5 {
                productScopeString = "书籍"
            }
            if model.productScope == 6 {
                productScopeString = "指定产品"
            }
            if model.couponType == 0 {//人群适用范围(0.全部用户 1.新用户 2.VIP用户 3.指定用户)
                couponTypeString = "全部用户"
            }
            if model.couponType == 1 {
                couponTypeString = "新用户"
            }
            if model.couponType == 2 {
                couponTypeString = "VIP用户"
            }
            if model.couponType == 3 {
                couponTypeString = "指定用户"
            }
            self.titleLab.text = "\(productScopeString)\(couponTypeString)"
            self.dateLab.text = "\(model.receiveStartTime) - \(model.receiveEndTime)"
            self.lastDayLab.text = "仅剩\(model.validDate)天"
            if model.couponType == 1 {
                self.reduceLab.text = "￥\(model.reductionPrice)"//减去的价格
                self.fullLab.text = "满\(model.totalPrice)元可用"//总价
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(model.reductionPrice)")
            }
            if model.couponType == 2 {
                self.fullLab.isHidden = true
                self.reduceLab.text = "￥\(model.reductionPrice)"//代金券
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(model.reductionPrice)")
            }
            if model.couponType == 3 {
                self.reduceLab.text = "\(model.discountRate)折"//折扣
                self.fullLab.text = "满\(model.totalPrice)元可用"//总价
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "\(model.discountRate)")
            }
            if model.couponType == 4 {
                self.reduceLab.text = "￥0"//包邮券
                self.fullLab.text = "运费"
                self.changeLabelTextFont(label: self.reduceLab, ranStr: "0")
            }
            
        }
    }
    
    lazy var fullLab : UILabel = {[weak self] in
        var fullLab = UILabel.init(frame: CGRect(x: (self?.reduceLab.left)!, y: (self?.reduceLab.bottom)! + 5/WIDTH_6_SCALE, width: (self?.reduceLab.width)!, height: 12/WIDTH_6_SCALE))
        fullLab.centerY = self!.bgView.centerY
        fullLab.font = DEF_FontSize_12
        fullLab.backgroundColor = .clear
        fullLab.textColor = UIColor.colorWithHex(hex: "828282")
        fullLab.textAlignment = .center
        fullLab.text = ""
        return fullLab
    }()
    lazy var reduceLab : UILabel = {[weak self] in
        var reduceLab = UILabel.init(frame: CGRect(x: 10, y: self!.borderX, width: 83/WIDTH_6_SCALE, height: 27/WIDTH_6_SCALE))
        reduceLab.font = UIFont.systemFont(ofSize: 12)
        reduceLab.backgroundColor = .clear
        reduceLab.textColor = UIColor.colorWithHex(hex: "FF6253")
        reduceLab.textAlignment = .center
        reduceLab.text = ""
        return reduceLab
    }()
    lazy var bgView : UIImageView = {
        weak var weakSelf = self
        var bgView = UIImageView.init(frame: CGRect(x: weakSelf!.bgBorderX, y: weakSelf!.borderX, width: SCREEN_WIDTH - 2*weakSelf!.bgBorderX, height: 90/WIDTH_6_SCALE))
        bgView.backgroundColor = .clear
        bgView.isUserInteractionEnabled = true
        return bgView
    }()
    lazy var couponBtn : UIButton = {[weak self] in
        let btnW = 52/WIDTH_6_SCALE
        weak var weakSelf = self
        var couponBtn = UIButton.init(frame : CGRect(x: (weakSelf?.bgView.width)! - btnW, y: 0, width: btnW, height: (weakSelf?.bgView.height)!))
        couponBtn.setBackgroundColor(.clear, forState: .normal)
        couponBtn.addTarget(self, action: #selector(couponBtnClick), for: .touchUpInside)
        return couponBtn
    }()
    lazy var dateLab : UILabel = {
        weak var weakSelf = self
        var dateLab = UILabel.init(frame: CGRect(x: (weakSelf?.lastDayLab.left)!, y: (weakSelf?.lastDayLab.bottom)! + 5/WIDTH_6_SCALE, width: (weakSelf?.lastDayLab.width)!, height: 13/WIDTH_6_SCALE))
        dateLab.font = DEF_FontSize_12
        dateLab.backgroundColor = .clear
        dateLab.textColor = UIColor.colorWithHex(hex: "828282")
        dateLab.textAlignment = .left
        dateLab.text = "有效期2020.1.18-20201.18"
        return dateLab
    }()
    
    lazy var titleLab : UILabel = {
        weak var weakSelf = self
        var titleLab = UILabel.init(frame: CGRect(x: 15/WIDTH_6_SCALE + (weakSelf?.reduceLab.right)!, y: 15/WIDTH_6_SCALE, width: (weakSelf?.bgView.width)! - (weakSelf?.reduceLab.right)! - 80/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_18
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "aaaaaaaaaaa"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        titleLab.sizeToFit()
        return titleLab
    }()
    
    lazy var lastDayLab : UILabel = {
        weak var weakSelf = self
        var lastDayLab = UILabel.init(frame: CGRect(x: (weakSelf?.titleLab.left)!, y: (weakSelf?.titleLab.bottom)! + 10/WIDTH_6_SCALE, width: (weakSelf?.bgView.width)! - (weakSelf?.reduceLab.right)! - 80/WIDTH_6_SCALE, height: 13/WIDTH_6_SCALE))
        lastDayLab.font = DEF_FontSize_12
        lastDayLab.backgroundColor = .clear
        lastDayLab.textColor = UIColor.colorWithHex(hex: "828282")
        lastDayLab.textAlignment = .left
        lastDayLab.text = "剩余10天"
        return lastDayLab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.bgView)
        self.bgView.addSubview(self.reduceLab)
        self.bgView.addSubview(self.couponBtn)
        self.bgView.addSubview(self.fullLab)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.lastDayLab)
        self.bgView.addSubview(self.dateLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func couponBtnClick(){
        print("点击优惠券")
        self.couponBtnClickBlock?()
    }
    
    func changeLabelTextFont(label: UILabel, ranStr:String){
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:label.text!)
        let str = NSString(string: label.text!)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 23), range: theRange)
        label.attributedText = attrstring
    }
}
