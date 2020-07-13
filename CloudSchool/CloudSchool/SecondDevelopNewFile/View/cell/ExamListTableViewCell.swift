//
//  ExamListTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/21.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ExamListTableViewCell: UITableViewCell {
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 8/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 18/WIDTH_6_SCALE)
        titleLab.font = DEF_FontSize_16
        titleLab.backgroundColor = .clear
        titleLab.textColor = .lightGray
        titleLab.textAlignment = .left
        titleLab.text = "第1次考试"
        return titleLab
    }()
    
    lazy var timeLab : UILabel = {
        var timeLab = UILabel.init()
        timeLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: self.titleLab.bottom + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 150/WIDTH_6_SCALE, height: self.titleLab.height)
        timeLab.font = DEF_FontSize_16
        timeLab.backgroundColor = .clear
        timeLab.textColor = .lightGray
        timeLab.textAlignment = .left
        timeLab.text = "bbb"
        return timeLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.frame = CGRect(x: 0, y: 50/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 1/WIDTH_6_SCALE)
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    
    lazy var scoreLab : UILabel = {
        var scoreLab = UILabel.init()
        scoreLab.frame = CGRect(x: self.timeLab.right, y: self.timeLab.top, width: SCREEN_WIDTH - self.timeLab.right - 15/WIDTH_6_SCALE, height: self.titleLab.height)
        scoreLab.font = DEF_FontSize_16
        scoreLab.backgroundColor = .clear
        scoreLab.textColor = .lightGray
        scoreLab.textAlignment = .right
        scoreLab.text = "aaa"
        return scoreLab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.timeLab)
        self.contentView.addSubview(self.scoreLab)
        self.contentView.addSubview(self.lineView)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
