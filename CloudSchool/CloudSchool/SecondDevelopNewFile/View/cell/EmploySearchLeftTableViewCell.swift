//
//  EmploySearchLeftTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/24.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmploySearchLeftTableViewCell: UITableViewCell {
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_13
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        titleLab.textAlignment = .left
        titleLab.text = "环保岗位"
        return titleLab
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "FAFAFA")
        return lineView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = .white
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLab)
        self.titleLab.frame = CGRect(x: 16/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH/2 - 30/WIDTH_6_SCALE - 32/WIDTH_6_SCALE, height: 36.5/WIDTH_6_SCALE)
        self.lineView.frame = CGRect(x: 0, y: self.titleLab.bottom - 1, width: self.titleLab.width, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
