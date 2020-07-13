//
//  CartActivityHeaderView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/28.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class CartActivityHeaderView: UIView {
    
    var model: CartListModel? {
        didSet {
            if let activity = model?.getActivityString() {
                self.activityLabel.text = model?.getActivityString()
                button.isHidden = false
                activityLabel.isHidden = false
            } else {
                button.isHidden = true
                activityLabel.isHidden = true
            }
            
        }
    }
    
    var button: BaseButton = {
        let button = BaseButton(type: .custom)
        button.contentEdgeInsets = UIEdgeInsets(top: 2, left: 9, bottom: 2, right: 9)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("满减", for: .normal)
        button.backgroundColor = UIColor.mainRedColor
        button.cornerRadius = 2
        return button
    }()
    
    var activityLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(hex: "#ffff00")
        label.numberOfLines = 0;
        label.text = "够满499元，可减100元"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        self.backgroundColor = UIColor.backgroundColor
        addSubview(button)
        addSubview(activityLabel)
        
        button.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(17)
            make.centerY.equalTo(self)
        }
        
        activityLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.button.snp.right).offset(10)
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-17)
        }
    }
}
