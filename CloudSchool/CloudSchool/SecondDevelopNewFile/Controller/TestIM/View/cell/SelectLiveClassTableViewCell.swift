//
//  SelectLiveClassTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/14.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SelectLiveClassTableViewCell: UITableViewCell {
    var model: SelectLiveClassDataModel?{
        didSet{
            guard let model = model else { return }
            self.titleLab.text = model.productName
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.titleLab.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE - 20/WIDTH_6_SCALE, height: 60/WIDTH_6_SCALE)
        self.lineView.frame = CGRect(x: 0, y: self.titleLab.bottom - 1, width: SCREEN_WIDTH, height: 1)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = ""
        return titleLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "DDDDDD")
        return lineView
    }()
}
