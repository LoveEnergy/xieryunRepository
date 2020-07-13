//
//  UIScrollView+Refresh.swift
//  New Horizon Labs
//
//  Created by 彭显鹤 on 2018/4/22.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView {
    func addRefreshHeader(block: (() -> Void)?) {
        let header = MJRefreshNormalHeader(refreshingBlock: block)
        header?.ignoredScrollViewContentInsetTop = 20
        self.mj_header = header
        
    }
    
    func addRefreshFooter(block: (() -> Void)?) {
        let footer = MJRefreshAutoFooter(refreshingBlock: block)
        self.mj_footer = footer
    }
    
    func endRefresh() {
        if self.mj_footer != nil {
            self.mj_footer.endRefreshing()
        }
        if self.mj_header != nil {
            self.mj_header.endRefreshing()
        }
    }
}
