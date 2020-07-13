//
//  HUD.swift
//  ColorMask
//
//  Created by yidahis on 2018/5/4.
//  Copyright © 2018年 SoloGame. All rights reserved.
//

import PKHUD

struct HUDP {
    static func config(){
//        PKHUD.sharedHUD.mixedbackgroundColor = MixedColor(normal: UIColor.white, night: ThemeColor.backgroud.night)
//        PKHUD.sharedHUD.mixedcontentColor = MixedColor(normal: UIColor.black, night: UIColor.white)
    }
    static func debugAlert(_ subtitle: String?, delay: UInt64 = 3){
        #if DEBUG
        alert("test:\(String(describing: subtitle))")
//        alert("\(String(describing: subtitle!))")
        #endif
    }
    
    static func alertNetworkError(){
        alert("Could not connect to the network.Please try again later.")
    }
    
    static func alert(_ subtitle: String?){

        let alertView = UIAlertController(title: nil, message: subtitle, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (alert) in
            
        })
        alertView.addAction(action)
        UIApplication.shared.delegate?.window??.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    static func debugFlash(_ subtitle: String?, delay: UInt64 = 3){
        #if DEBUG
        DispatchQueue.main.async {
            //HUD.flash(.label(subtitle),delay: 10)
            
        }
        #endif
    }
    
    static func flashSuccess(_ subtitle: String?){
        DispatchQueue.main.async {
           //HUD.flash(.labeledSuccess(title: nil, subtitle: subtitle),delay: kHudDelaySec)

        }
    }
    
    static func flashSuccess(_ subtitle: String?,delay: Int = 0){
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: UInt64(delay))) {
           //HUD.flash(.labeledSuccess(title: nil, subtitle: subtitle),delay: kHudDelaySec)
        }
    }

    
    static func flashError(_ subtitle: String?){
        DispatchQueue.main.async {
            //HUD.flash(.labeledError(title: nil, subtitle: subtitle),delay: kHudDelaySec)
        }
    }
    
    static func flash(_ subtitle: String?){
        DispatchQueue.main.async {
           //HUD.flash(.label(subtitle),delay: kHudDelaySec)
        }
    }
    
    static func flashProgress(){
        DispatchQueue.main.async {
           //HUD.flash(.progress,delay:9999)
        }
    }
    static func flashProgress(title: String?){
        DispatchQueue.main.async {
            //HUD.flash(.labeledProgress(title: title, subtitle: nil), delay:9999)
        }
    }
    
    static func hide(){
        DispatchQueue.main.async {
//           HUD.hide()
        }
    }
}
