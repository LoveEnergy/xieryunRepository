//
//  LiveExpiredTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/22.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LiveExpiredTableViewCell: UITableViewCell {
    var model: ClassModel?{
        didSet{
            self.iconView.loadImage(string: model?.thumbnailUrl)
            self.titleLab.text = model?.productName
            self.titleLab.frame = CGRect(x: self.iconView.right + 8, y: self.iconView.top, width: SCREEN_WIDTH - self.iconView.right - 8 - 10, height: self.getLabelHeight(label: self.titleLab, string: model?.productName ?? "", font: 15, textAlignment: .left, width: SCREEN_WIDTH - self.iconView.right - 8 - 10))
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.lineView.frame = CGRect(x: 16, y: 110 - 1, width: SCREEN_WIDTH - 20, height: 1)
        self.iconView.frame = CGRect(x: self.lineView.left, y: 0, width: 124, height: 124*0.78)
        self.iconView.centerY = 110/2
        self.titleLab.frame = CGRect(x: self.iconView.right + 8, y: self.iconView.top, width: SCREEN_WIDTH - self.iconView.right - 8 - 10, height: 15/WIDTH_6_SCALE)
        self.statusLab.frame = CGRect(x: self.titleLab.left, y: self.iconView.bottom - 35, width: 80, height: 35)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.statusLab)
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
    
    lazy var statusLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "ff0d0d")
        titleLab.textAlignment = .center
        titleLab.text = "已过期"
        return titleLab
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
}
