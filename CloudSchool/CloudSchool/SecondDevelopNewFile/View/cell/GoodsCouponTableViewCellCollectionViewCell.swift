//
//  GoodsCouponTableViewCellCollectionViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GoodsCouponTableViewCellCollectionViewCell: UICollectionViewCell {
    var model: NewCouponList?{
        didSet{
            if model?.couponType == 1 {
                self.titleLab.text = "满\(model!.totalPrice)减\(model!.reductionPrice)"
            }
            if model?.couponType == 2 {
                self.titleLab.text = "代金券  \(model!.reductionPrice)"
            }
            if model?.couponType == 3 {
                self.titleLab.text = "折扣券  \(model!.discountRate)折"
            }
            if model?.couponType == 4 {
                self.titleLab.text = "包邮券  满\(model!.reductionPrice)包邮"
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.bgImgView.frame = CGRect(x: 0, y: 0, width: self.contentView.width, height: 20)
        self.bgImgView.centerY = self.contentView.centerY
        self.titleLab.frame = self.bgImgView.frame
        self.contentView.addSubview(self.bgImgView)
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_10
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.systemRed
        titleLab.textAlignment = .center
        titleLab.text = "满100减20元"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    
    lazy var bgImgView : UIImageView = {
        var bgImgView = UIImageView.init()
        bgImgView.image = UIImage.init(named: "coupon_small_bg")
        return bgImgView
    }()
}
