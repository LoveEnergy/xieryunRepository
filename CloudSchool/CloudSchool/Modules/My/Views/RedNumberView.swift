//
//  RedNumberView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class RedNumberView: UIView {
    
    @IBInspectable var number: Int = 0 {
        didSet {
            numberButton.pcornerRadius = self.height/2.0
            numberButton.setTitle(number.toString(), for: .normal)
        }
    }
    
    var numberButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        button.contentHorizontalAlignment = .center
        button.setTitleColor(UIColor.white, for: .normal)
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        addSubview(numberButton)
        numberButton.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
