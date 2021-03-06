//
//  DiscountViewTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/13.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class DiscountViewTableViewCell: UITableViewCell {
    var model: DiscountCouponModel?{
        didSet{
            if model?.discountRate == 0 && model?.userCouponID == 0 {
                self.titleLab.text = "不使用优惠券"
            }else{
                self.titleLab.text = "\(model?.discountRate ?? 10)折优惠"
            }
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.colorWithHex(hex: "F4F5F6")
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: 120/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_12
        titleLab.backgroundColor = UIColor.clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = ""
        return titleLab
    }()
}
