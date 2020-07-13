//
//  XibLoadable.swift
//  Asteroid
//
//  Created by Maynard on 2017/6/12.
//  Copyright © 2017年 Aeseroid. All rights reserved.
//

import UIKit

protocol XibLoadable {
    
}

extension XibLoadable where Self: UIView {
    ///提供加载XIB方法
    static func loadXib(xibStr: String? = nil) -> Self {
        return Bundle.main.loadNibNamed(xibStr ?? "\(self)", owner: nil, options: nil)?.last as? Self ?? Self()
    }
}

