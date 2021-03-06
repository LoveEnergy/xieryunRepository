//  UIConfigure.swift
//  Asteroid
//
//  Created by Maynard on 2017/4/21.
//  Copyright © 2017年 Aeseroid. All rights reserved.
//

import UIKit
import Foundation

class UIConfigure {
    //配置tabbar 样式
    class func tabbar() {
        UITabBar.appearance().tintColor = UIColor.mainHighlightColor
        UITabBar.appearance().backgroundColor = UIColor.white
        let tabbar = UITabBar.appearance()
        tabbar.barTintColor = UIColor.white
        tabbar.isTranslucent = false
    }
    
    //配置导航栏样式
    class func navgationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.mainNormalColor
        UINavigationBar.appearance().isTranslucent = false
        
        let image = R.image.ic_back()?.withRenderingMode(.alwaysOriginal)

        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().titleTextAttributes =  [NSAttributedString.Key.foregroundColor:UIColor.black, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        
        if #available(iOS 11.0, *) {
            UINavigationBar.appearance().largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor:UIColor.mainNormalColor]
        } else {
            // Fallback on earlier versions
        }
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -200, vertical: 0), for:UIBarMetrics.default)
    }
    
    //配置tableview 样式
    class func tableView() {
        let tableView = UITableView.appearance()
        tableView.separatorColor = UIColor.lineColor
        
        let tableViewCell = UITableViewCell.appearance()
        let view = UIView()
        view.backgroundColor = UIColor.tableViewCellSelectedColor
        tableViewCell.selectedBackgroundView = view
    }
    
}
