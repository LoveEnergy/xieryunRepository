//
//  DiscountProductTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class DiscountProductTableViewCell: UITableViewCell {
    var model: DiscountProductDetailModel? {
        didSet{
            guard let model = model else { return }
            self.iconImgView.loadImage(string: model.previewImgUrl)
            self.titleLab.text = "\(model.productName)"
            //钱数大小字体
            let string = "￥\(model.basicPrice)"
            let ranStr = "\(model.basicPrice)"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string)
            let str = NSString(string: string)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: theRange)
            attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 18), range: theRange)
            self.moneyLab.attributedText = attrstring
            
            if model.courseType == 0 {
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
            }else{
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
            }
            self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.dateLab)
        self.contentView.addSubview(self.locationLab)
        self.contentView.addSubview(self.moneyLab)
        self.contentView.addSubview(self.postLab)
        self.contentView.addSubview(self.buyLab)
        self.iconImgView.addSubview(self.productTypeImgView)
        self.buyLab.isHidden = true
        self.dateLab.isHidden = true
        self.locationLab.isHidden = true
        self.postLab.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let moneyLabH = 22/WIDTH_6_SCALE
        let buyLabW = 90/WIDTH_6_SCALE
        let imgW = 40
        self.iconImgView.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 5/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 100/WIDTH_6_SCALE)
        self.titleLab.frame = CGRect(x: 15/WIDTH_6_SCALE + self.iconImgView.right, y: self.iconImgView.top, width: SCREEN_WIDTH - self.iconImgView.right - 30/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.dateLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 10/WIDTH_6_SCALE, width: self.titleLab.width, height: 12/WIDTH_6_SCALE)
        self.locationLab.frame = CGRect(x: self.titleLab.left, y: self.dateLab.bottom + 5/WIDTH_6_SCALE, width: self.titleLab.width, height: 12/WIDTH_6_SCALE)
        self.moneyLab.frame = CGRect(x: self.titleLab.left, y: self.iconImgView.bottom - moneyLabH, width: 80/WIDTH_6_SCALE, height: moneyLabH)
        self.buyLab.frame = CGRect(x: self.moneyLab.right, y: self.iconImgView.bottom - 15/WIDTH_6_SCALE, width: buyLabW, height: 15/WIDTH_6_SCALE)
        self.productTypeImgView.frame = CGRect(x: self.iconImgView.width - CGFloat(imgW), y: self.iconImgView.height - CGFloat(imgW), width: CGFloat(imgW), height: CGFloat(imgW))
    }
    
    lazy var iconImgView : UIImageView = {
        var iconImgView = UIImageView.init()
        iconImgView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        iconImgView.layer.cornerRadius = 4
        iconImgView.layer.masksToBounds = true
        return iconImgView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "1、苹果公司规定，虚拟商品必须使用苹果系统充值购买，充值金额不可自定义，且不能用于安卓、网页等其他平台；\n2、学习币可用于直接购买APP内虚拟内容（不含实物产品和线下课）\n3、学习币为虚拟币，充值成功后不会过期，但无法提现或转赠他人；"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 2
        titleLab.sizeToFit()
        return titleLab
    }()
    
    lazy var dateLab : UILabel = {
        var dateLab = UILabel.init()
        dateLab.font = DEF_FontSize_10
        dateLab.backgroundColor = .clear
        dateLab.textColor = UIColor.colorWithHex(hex: "828282")
        dateLab.textAlignment = .left
        dateLab.text = "aaa"
        return dateLab
    }()
    
    lazy var locationLab : UILabel = {
        var locationLab = UILabel.init()
        locationLab.font = DEF_FontSize_10
        locationLab.backgroundColor = .clear
        locationLab.textColor = UIColor.colorWithHex(hex: "FF9E27")
        locationLab.textAlignment = .left
        locationLab.text = "aaa"
        return locationLab
    }()
    
    lazy var moneyLab : UILabel = {
        var moneyLab = UILabel.init()
        moneyLab.font = DEF_FontSize_10
        moneyLab.backgroundColor = .clear
        moneyLab.textColor = UIColor.colorWithHex(hex: "FF6253")
        moneyLab.textAlignment = .left
        moneyLab.text = "￥1320"
        return moneyLab
    }()
    
    lazy var postLab : UILabel = {
        var postLab = UILabel.init()
        postLab.font = DEF_FontSize_13
        postLab.backgroundColor = .clear
        postLab.textColor = UIColor.colorWithHex(hex: "ADADAD")
        postLab.textAlignment = .center
        postLab.text = "满80包邮"
        postLab.layer.cornerRadius = 3
        postLab.layer.masksToBounds = true
        return postLab
    }()
    
    lazy var buyLab : UILabel = {
        var buyLab = UILabel.init()
        buyLab.font = DEF_FontSize_12
        buyLab.backgroundColor = .clear
        buyLab.textColor = UIColor.colorWithHex(hex: "ADADAD")
        buyLab.textAlignment = .right
        buyLab.text = "266人购书"
        return buyLab
    }()
    
    lazy var productTypeImgView : UIImageView = {
        var productTypeImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 40/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        return productTypeImgView
    }()
    
    /// 圆角设置/部分圆角
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}
