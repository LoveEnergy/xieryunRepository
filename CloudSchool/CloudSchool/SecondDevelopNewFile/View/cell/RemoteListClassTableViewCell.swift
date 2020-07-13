//
//  RemoteListClassTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/30.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class RemoteListClassTableViewCell: UITableViewCell {
    
    var model: RemoteClassDetailModel? {
        didSet{
            guard let model = model else { return }
            self.imgImgView.loadImage(string: model.thumbnailUrl)
            self.titleLab.frame = CGRect(x: self.lineView.left, y: self.imgImgView.top, width: SCREEN_WIDTH - self.imgImgView.right - 18/WIDTH_6_SCALE, height: self.getLabelHeight(label: self.titleLab, string: model.productName, font: 15, textAlignment: .left, width: SCREEN_WIDTH - self.imgImgView.right - 18/WIDTH_6_SCALE))
            self.titleLab.text = model.productName
            self.moneyLab.text = "￥\(model.basicPrice)/人"
            self.titleLab.sizeToFit()
            self.buyBtn.setTitle("\(model.buyCount)人购买", for: .normal)
            
            if model.courseType == 0 {
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
            }else{
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
            }
            self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
        }
    }
    
    lazy var imgImgView : UIImageView = {
        var imgImgView = UIImageView.init()
        imgImgView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return imgImgView
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "名称"
        titleLab.text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbccccccccccccccccccccc"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 2
        titleLab.sizeToFit()
        return titleLab
    }()
    
    lazy var moneyLab : UILabel = {
        var moneyLab = UILabel.init()
        moneyLab.font = DEF_FontSize_13
        moneyLab.backgroundColor = .clear
        moneyLab.textColor = .systemRed
        moneyLab.textAlignment = .left
        moneyLab.text = "aaa"
        return moneyLab
    }()
    
    lazy var buyBtn : UIButton = {
        var buyBtn = UIButton.init()
        buyBtn.setTitle("人购买", for: .normal)
        buyBtn.setTitleColor(UIColor.colorWithHex(hex: "a3a3a3"), for: .normal)
        buyBtn.setImage(UIImage.init(named: "course_buyNumber"), for: .normal)
        buyBtn.titleLabel?.font = DEF_FontSize_11
        return buyBtn
    }()
    
    lazy var productTypeImgView : UIImageView = {
        var productTypeImgView = UIImageView.init()
        return productTypeImgView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let imgW = 40
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.imgImgView)
        self.imgImgView.addSubview(self.productTypeImgView)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.moneyLab)
        self.contentView.addSubview(self.buyBtn)
        self.imgImgView.frame = CGRect(x: 12/WIDTH_6_SCALE, y: 11/WIDTH_6_SCALE, width: 120/WIDTH_6_SCALE, height: 88/WIDTH_6_SCALE)
        self.productTypeImgView.frame = CGRect(x: self.imgImgView.width - CGFloat(imgW), y: self.imgImgView.height - CGFloat(imgW), width: CGFloat(imgW), height: CGFloat(imgW))
        self.lineView.frame = CGRect(x: self.imgImgView.right + 9/WIDTH_6_SCALE, y: 110/WIDTH_6_SCALE - 1, width: SCREEN_WIDTH - self.imgImgView.right - 9/WIDTH_6_SCALE, height: 1)
        self.titleLab.frame = CGRect(x: self.lineView.left, y: self.imgImgView.top, width: SCREEN_WIDTH - self.imgImgView.right - 18/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
        self.moneyLab.frame = CGRect(x: self.lineView.left, y: self.imgImgView.bottom - 25/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.buyBtn.frame = CGRect(x: self.moneyLab.right + 25/WIDTH_6_SCALE, y: self.moneyLab.top, width: self.moneyLab.width, height: 15/WIDTH_6_SCALE)
    }
    
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
        if size.height > 30/WIDTH_6_SCALE {
            return 30/WIDTH_6_SCALE
        }
        return size.height
    }
    
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
