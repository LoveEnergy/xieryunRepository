//
//  SpecialServiceTableViewCellCollectionViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/27.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SpecialServiceTableViewCellCollectionViewCell: UICollectionViewCell {
    lazy var circleView : UIView = {
        var circleView = UIView.init()
        circleView.backgroundColor = UIColor.colorWithHex(hex: "0378fd")
        return circleView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.circleView)
        self.contentView.addSubview(self.titleLab)
        self.circleView.frame = CGRect(x: 0, y: 0, width: 14/WIDTH_6_SCALE, height: 14/WIDTH_6_SCALE)
        self.titleLab.frame = CGRect(x: self.circleView.right + 16/WIDTH_6_SCALE, y: 0, width: (SCREEN_WIDTH - 52/WIDTH_6_SCALE)/2 - 11/WIDTH_6_SCALE - (self.circleView.right + 16/WIDTH_6_SCALE), height: 15/WIDTH_6_SCALE)
        self.circleView.centerY = self.titleLab.centerY
        self.circleView.layer.cornerRadius = self.circleView.height/2
        self.circleView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
