//
//  Extension + UIColor.swift
//  SwiftTest
//
//  Created by ENERGY on 2019/7/31.
//  Copyright © 2019 ENERGY. All rights reserved.
//

import UIKit

extension UIColor {
    static func ColorHex(_ color: String) -> UIColor {
//        if color.count <= 0 || color.count != 7 || color == "(null)" || color == "<null>" {
//            return nil
//        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(color[color.index(color.startIndex, offsetBy: 0)...color.index(color.startIndex, offsetBy: 1)])
        let greenString = String(color[color.index(color.startIndex, offsetBy: 2)...color.index(color.startIndex, offsetBy: 3)])
        let blueString = String(color[color.index(color.startIndex, offsetBy: 4)...color.index(color.startIndex, offsetBy: 5)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        let hexColor = UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        return hexColor
    }
    
    // MARK:- 把#ffffff颜色转为UIImage
    class func creatImageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
