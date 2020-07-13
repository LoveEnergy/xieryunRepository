//
//  BaseSegmentControl.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/7.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class BaseSegmentControl: UISegmentedControl {

    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        
        if #available(iOS 13.0, *) {
            //系统版本高于8.0
            self.selectedSegmentTintColor = UIColor(hex: "1fa2f8")
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor(hex: "1fa2f8")], for: .normal)
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        } else {
            //系统版本低于8.0
            self.tintColor = UIColor(hex: "1fa2f8")
        }
    }
    
    func imageWithColor(color: UIColor) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50)
        if let ctx = UIGraphicsGetCurrentContext() {
          ctx.setFillColor(UIColor.red.cgColor)
          ctx.setStrokeColor(UIColor.black.cgColor)
          ctx.setLineWidth(10)
          ctx.addRect(rect)
          ctx.drawPath(using: .fillStroke)
          UIGraphicsEndImageContext()
        }
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img ?? UIImage.init(color: .white, size: rect.size)
    }
}
