//
//  EmploySearchRightTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/24.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmploySearchRightTableViewCell: UITableViewCell {

    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.layer.cornerRadius = 4
        titleLab.layer.masksToBounds = true
        titleLab.layer.borderColor = UIColor.colorWithHex(hex: "CCCCCC").cgColor
        titleLab.layer.borderWidth = 1
        titleLab.text = "水处理"
        return titleLab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.colorWithHex(hex: "FAFAFA")
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLab)
        self.titleLab.frame = CGRect(x: 21.5/WIDTH_6_SCALE, y: 6.5/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE - 43/WIDTH_6_SCALE, height: 32/WIDTH_6_SCALE)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
