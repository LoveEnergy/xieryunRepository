//
//  UViewController+Extension.swift
//  AsteroidVPN-iOS
//
//  Created by Asteroid on 2017/12/27.
//  Copyright © 2017年 Asteroid. All rights reserved.
//

import UIKit
import QMUIKit

extension UIViewController {
    @objc var backgroundColor: UIColor {
        return UIColor.backgroundColor
    }
}

extension UIViewController {
    
//    open override func awakeFromNib() {
//        self.view.backgroundColor = self.backgroundColor
//        super.awakeFromNib()
//    }
    
    
}

extension QMUICommonViewController {
    func showDefaultEmptyView() {
        self.showEmptyView(with: R.image.common_empty_image(), text: "没有相关内容", detailText: "", buttonTitle: "", buttonAction: nil)
    }
    
    func hideDefaultEmptyView() {
        self.hideEmptyView()
    }
}
