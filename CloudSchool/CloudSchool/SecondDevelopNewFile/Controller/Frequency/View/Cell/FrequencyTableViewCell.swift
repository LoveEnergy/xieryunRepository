//
//  FrequencyTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/24.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class FrequencyTableViewCell: UITableViewCell {
    lazy var iconView : UIView = {
        var iconView = UIView.init(frame: CGRect(x: 16/WIDTH_6_SCALE, y: 0, width: 39/WIDTH_6_SCALE, height: 39/WIDTH_6_SCALE))
        iconView.backgroundColor = UIColor.lightGray
        return iconView
    }()
    lazy var nameLab : UILabel = {
        var nameLab = UILabel.init(frame: CGRect(x: 8/WIDTH_6_SCALE + self.iconView.right, y: 0, width: SCREEN_WIDTH - self.iconView.right - 16/WIDTH_6_SCALE, height: 23/WIDTH_6_SCALE))
        nameLab.font = DEF_FontSize_14
        nameLab.backgroundColor = .clear
        nameLab.textColor = UIColor.colorWithHex(hex: "606060")
        nameLab.textAlignment = .left
        nameLab.text = "嘟嘟"
        return nameLab
    }()
    lazy var commentLab : UILabel = {
        var commentLab = UILabel.init()
        commentLab.font = DEF_FontSize_14
        commentLab.backgroundColor = .clear
        commentLab.textColor = UIColor.colorWithHex(hex: "353535")
        commentLab.textAlignment = .left
        commentLab.text = "aaa"
        commentLab.lineBreakMode = .byWordWrapping
        commentLab.numberOfLines = 0
        return commentLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.iconView)
        self.contentView.addSubview(self.nameLab)
        self.contentView.addSubview(self.commentLab)
        let string = "培养了大批生态环境执法专业化人才，逐步建立起中国的生态环境执法精英人才库，对带动整个生态环境执法队伍，提升能力建设具有重要意义。"
        self.commentLab.frame = CGRect(x: 8.5/WIDTH_6_SCALE + self.iconView.right, y: self.nameLab.bottom + 7/WIDTH_6_SCALE, width: SCREEN_WIDTH - 8.5/WIDTH_6_SCALE - self.iconView.right - 70.5/WIDTH_6_SCALE, height: self.getLabelHeight(label: commentLab, string: string, font: 14, textAlignment: .left, width: SCREEN_WIDTH - 8.5/WIDTH_6_SCALE - self.iconView.right - 70.5/WIDTH_6_SCALE))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //效果最佳
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
