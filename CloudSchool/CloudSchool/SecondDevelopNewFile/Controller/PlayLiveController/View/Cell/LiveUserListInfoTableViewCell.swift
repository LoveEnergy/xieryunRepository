//
//  LiveUserListInfoTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/4/26.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LiveUserListInfoTableViewCell: UITableViewCell {
    
    var model: LiveUserInfo?{
        didSet{
            self.titleLab.text = model?.nickname
            let userType = model?.role
            if userType == "owner"{
                self.userTypeLab.text = "助理"
                self.userTypeLab.backgroundColor = UIColor.colorWithHex(hex: "F5BC40")
            }
            if userType == "member"{
                self.userTypeLab.text = "学员"
                self.userTypeLab.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
            }
        }
    }
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "f7f7f7")
        return lineView
    }()
    
    lazy var userTypeLab : UILabel = {
        var userTypeLab = UILabel.init()
        userTypeLab.font = DEF_FontSize_9
        userTypeLab.textColor = .white
        userTypeLab.textAlignment = .center
        return userTypeLab
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "9edcff")
        titleLab.textAlignment = .left
        return titleLab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.lineView.frame = CGRect(x: 0, y: 39/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 1/WIDTH_6_SCALE)
        self.userTypeLab.frame = CGRect(x: 30/WIDTH_6_SCALE, y: 0/WIDTH_6_SCALE, width: 35/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
        self.userTypeLab.centerY = 40/WIDTH_6_SCALE/2
        self.titleLab.frame = CGRect(x: self.userTypeLab.right + 5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - self.userTypeLab.left * CGFloat(2), height: 15/WIDTH_6_SCALE)
        self.titleLab.centerY = self.userTypeLab.centerY

        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.userTypeLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
