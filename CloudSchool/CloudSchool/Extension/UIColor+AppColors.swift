//
//  UIColor+AppColors.swift
//  AsteroidVPN-iOS
//
//  Created by Asteroid on 2017/12/26.
//  Copyright © 2017年 Asteroid. All rights reserved.
//
import UIKit

extension UIColor {
    open class var menuBackgroundColor: UIColor {
        return UIColor.rgb(r: 53, g: 78, b: 134)
    }
    
    //textfield background color
    class var textfieldBackgroundColor: UIColor {
        return UIColor.colorWithHex(hex: "#F5F5F5")
    }
    
    //主题色
    class var mainNormalColor: UIColor {
        return UIColor.colorWithHex(hex: "#1A53F0")
    }
    
    //高亮状态主题色
    class var mainHighlightColor: UIColor {
        return UIColor.colorWithHex(hex: "#777589")
    }
    
    class var mainDeepGrayColor: UIColor {
        return UIColor.rgb(r: 82, g: 80, b: 108)
    }
    
    //导航栏颜色
    class var navigationBarColor: UIColor {
        return UIColor.mainNormalColor
    }
    
    //分割线颜色
    class var lineColor: UIColor {
        //242 242 245
        return UIColor(white: 0, alpha: 0.05)
    }
    
    //深色分割线
    class var deepLineColor: UIColor {
        //117 117 182
        return UIColor.mainNormalColor
    }
    
    //主题红色
    class var mainRedColor: UIColor {
        //248 2 70
        return UIColor.colorWithHex(hex: "#FF5D4C")
    }
    
    //主题红色
    class var mainLightRedColor: UIColor {
        //248 2 70
        return UIColor.rgb(r: 255, g: 93, b: 76, a: 0.1)
    }
    
    
    //主题蓝色
    class var mainBlueColor: UIColor {
        return UIColor.colorWithHex(hex: "#1FA2F8")
    }
    
    //主题灰
    class var mainGrayColor: UIColor{
        return UIColor.rgb(r: 168, g: 168, b: 168)
    }
    
    //购买页蓝
    class var vipBlueColor: UIColor{
        return UIColor.rgb(r: 138, g: 188, b: 255)
    }
    //蒙层颜色
    class var maskBackgroundColor: UIColor {
        return UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
    }
    
    class var buttonTitleColor: UIColor {
        return UIColor.colorWithHex(hex: "#333333")
    }
    
    class var buttonBorderColor: UIColor {
        return UIColor.colorWithHex(hex: "#E4E8EE")
    }
    
    //比主标题更深的标题颜色
    class var deepTitleColor: UIColor {
        //39 38 52
        return UIColor.colorWithHex(hex: "#333333")
    }
    
    //主标题颜色
    class var titleColor: UIColor {
        return UIColor.colorWithHex(hex: "333333")
    }
    
    //副标题颜色
    class var subTitleColor: UIColor {
        return UIColor.colorWithHex(hex: "777777")
    }
    
    class var normalTextColor: UIColor {
        return UIColor.colorWithHex(hex: "#212837")
    }
    
    class var disabledTextColor: UIColor {
        return UIColor.colorWithHex(hex: "#B0B8CA")
    }
    
    class var normalBackgroundColor: UIColor {
        return UIColor.mainNormalColor
    }
    
    class var disabledBackgroundColor: UIColor {
        return UIColor.colorWithHex(hex: "#B0B8CA")
    }
    
    //副标题颜色
    class var separatorLineColor: UIColor {
        return UIColor.rgb(r: 200, g: 199, b: 204)
    }
    
    //副标题颜色
    class var alertTitleColor: UIColor {
        return UIColor.colorWithHex(hex: "#212837")
    }
    
    class var alertMessageColor: UIColor {
        return UIColor.colorWithHex(hex: "#767E8D")
    }
    
    //比副标题更浅的标题颜色
    class var lightTitleColor: UIColor {
        //153 153 153
        return UIColor.colorWithHex(hex: "#999999")
    }
    
    //背景色
    class var backgroundColor: UIColor {
        //242 242 245
        return UIColor.colorWithHex(hex: "#f8f8f8")
    }
    
    //数据为空时，提示标题颜色
    class var emptyTitleColor: UIColor {
        //242 242 242
        return UIColor.colorWithHex(hex: "#f2f2f2")
    }
    
    //tableview cell选中的时候的颜色
    class var tableViewCellSelectedColor: UIColor {
        //245 245 245
        return UIColor.colorWithHex(hex: "#f5f5f5")
    }
    
    //tableview cell normal 状态下背景色
    class var tableViewCellNormalColor: UIColor {
        return UIColor.white
    }
    
    //红色
    class var fitnessRed: UIColor {
        return UIColor.rgb(r: 248, g: 97, b: 97)
    }
    
    //绿色
    class var fitnessGreen: UIColor {
        return UIColor.rgb(r: 79, g: 196, b: 135)
    }
    
    //蓝色
    class var fitnessBlue: UIColor {
        return UIColor.rgb(r: 27, g: 136, b: 255)
    }
    
    //黄色
    class var fitnessYellow: UIColor {
        return UIColor.rgb(r: 255, g: 199, b: 64)
    }
    
    //紫色
    class var fitnessPurple: UIColor {
        return UIColor.rgb(r: 152, g: 101, b: 242)
    }
    
    //运动过程中绿色进度条颜色
    class var sportProgressGreenColor: UIColor {
        return UIColor.circleGreenColor
    }
    
    //运动过程中灰色进度条颜色
    class var sportProgressGrayColor: UIColor {
        return UIColor.rgb(r: 177, g: 177, b: 182)
    }
    
    //性别选择男
    class var maleColor: UIColor {
        return UIColor.rgb(r: 46, g: 111, b: 253)
    }
    
    //性别选择女
    class var femaleColor: UIColor {
        return UIColor.rgb(r: 253, g: 1, b: 132)
    }
    
    class var shareButtonColor: UIColor{
        return UIColor.rgb(r: 25, g: 167, b: 120)
    }
    
    class var circleGreenColor: UIColor {
        return UIColor.rgb(r: 24, g: 167, b: 120)
    }
    
    class func rgb(r: Int, g: Int, b: Int) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    class func rgb(r: Int, g: Int, b: Int, a: CGFloat) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: a)
    }
    
    class var homeBackgroundColor: UIColor {
        return UIColor.white
    }
    
    class var purplishGreyFontColor: UIColor {
        //100 97 118
        return UIColor.colorWithHex(hex: "#646176")
    }
    
    class var cloudyBlueFontColor: UIColor {
        //193 191 207
        return UIColor.colorWithHex(hex: "#c1bfcf")
    }
    
    class var barbiePinkLayerColor: UIColor {
        //255 51 131
        return UIColor.colorWithHex(hex: "#ff3383")
    }
    
    class var aquaMarineFontColor: UIColor {
        //91 228 194
        return UIColor.colorWithHex(hex: "#5be4c2")
    }
    
    class var brightSkyBlueFontColor: UIColor {
        //0 177 254
        return UIColor.colorWithHex(hex: "#00b1fe")
    }
    
    class var grapefruitFontColor: UIColor {
        //248 97 97
        return UIColor.colorWithHex(hex: "#f86161")
    }
    
    class var iceBackGroundColor: UIColor {
        // 230 255 249
        return UIColor.colorWithHex(hex: "#e6fff9")
    }
    
}

extension UIColor {
    class func colorWithHex(hex: String) -> UIColor {
        var cString = hex.trimmingCharacters(in:CharacterSet.whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") {
            let index = cString.index(cString.startIndex, offsetBy:1)
            cString = cString.substring(from: index)
        }
        
        if cString.characters.count != 6 {
            return UIColor.red
        }
        
        let rIndex = cString.index(cString.startIndex, offsetBy: 2)
        let rString = cString.substring(to: rIndex)
        let otherString = cString.substring(from: rIndex)
        let gIndex = otherString.index(otherString.startIndex, offsetBy: 2)
        let gString = otherString.substring(to: gIndex)
        let bIndex = cString.index(cString.endIndex, offsetBy: -2)
        let bString = cString.substring(from: bIndex)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}


extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
