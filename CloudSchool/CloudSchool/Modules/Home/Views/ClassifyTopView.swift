//
//  ClassifyTopView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class ClassifyTopView: UIView {
    
    var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    var moreButton: LayoutableButton = {
        let button = LayoutableButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        button.setTitleColor(UIColor.subTitleColor, for: .normal)
        button.setTitle("更多", for: .normal)
        button.setImage(R.image.more_arrow(), for: .normal)
        button._layoutType = "right"
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.titleColor
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    init() {
        super.init(frame: .zero)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseConfigure()
    }
    
    func baseConfigure() {
        addSubview(titleLabel)
        addSubview(moreButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(15)
        }
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(self).offset(-15)
        }
    }

}
