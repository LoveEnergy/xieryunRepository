//
//  CourseDetailFreePostTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/6/8.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class CourseDetailFreePostTableViewCell: UITableViewCell {
    var model: ProductDetailModel?{
        didSet{
            self.titleLab.text = "运费: 满\(model!.freeShippingPrice)元包邮"
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 16.5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 16.5/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_12
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.ColorHex("999999")
        titleLab.textAlignment = .left
        titleLab.text = "运费:"
        return titleLab
    }()
}
