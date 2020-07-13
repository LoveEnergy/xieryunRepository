//
//  EmployHomeTableViewCellCollectionViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/8.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmployHomeTableViewCellCollectionViewCell: UICollectionViewCell {
    var model : String? {
            didSet{
                guard let model = model else { return }
                self.titleLab.text = model
                self.titleLab.frame = CGRect(x: 0, y: 0/WIDTH_6_SCALE, width: self.getLabelWidth(text: model, font: DEF_FontSize_12, height: 20/WIDTH_6_SCALE) + 10/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
            }
    }
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: 3/WIDTH_6_SCALE, width: 40/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_12
        titleLab.backgroundColor = UIColor.colorWithHex(hex: "eaf3fe")
        titleLab.textColor = UIColor.colorWithHex(hex: "848484")
        titleLab.textAlignment = .center
        titleLab.text = "aaa"
        return titleLab
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
}
