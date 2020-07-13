//
//  MyResumeBlockTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/11.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class MyResumeBlockTableViewCell: UITableViewCell {
    public var fillInInfoBlock:(()->())?//信息填写block
    var model: String? {
        didSet{
            self.btn.setTitle(model, for: .normal)
        }
    }
    
    lazy var btn : UIButton = {
        var btn = UIButton.init()
        btn.setTitleColor(UIColor.colorWithHex(hex: "FF6434"), for: .normal)
        btn.titleLabel?.font = DEF_FontSize_18
        btn.setBackgroundImage(UIImage.init(named: "employ_block_info"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.btn)
        self.btn.frame = CGRect(x: 42/WIDTH_6_SCALE, y: 26/WIDTH_6_SCALE, width: SCREEN_WIDTH - 84/WIDTH_6_SCALE, height: 32/WIDTH_6_SCALE)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func btnClick(){
        self.fillInInfoBlock?()
    }
}
