//
//  CouponSmallButton.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/15.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class CouponSmallButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        setBackgroundImage(R.image.coupon_small_bg(), for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
        contentEdgeInsets = UIEdgeInsets(top: 2, left: 10, bottom: 2, right: 10)
        setTitleColor(UIColor.mainRedColor, for: .normal)
        
    }

}
