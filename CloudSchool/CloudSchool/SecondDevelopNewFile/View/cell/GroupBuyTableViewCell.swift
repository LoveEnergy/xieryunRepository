//
//  GroupBuyTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GroupBuyTableViewCell: UITableViewCell {
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .mainRedColor
        titleLab.textAlignment = .center
        titleLab.text = "5人团购"
        return titleLab
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.frame = CGRect(x: 0, y: self.titleLab.bottom - 1, width: SCREEN_WIDTH, height: 1)
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.titleLab.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40/WIDTH_6_SCALE)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
