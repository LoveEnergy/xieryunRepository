//
//  ShareView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/7.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

enum ShareContentType {
    case url
    case image
}

class ShareView: UIView, BottomPopable, XibLoadable {
    
    var autoDismiss: Bool {
        return true
    }
    var viewHeight: CGFloat {
        return 140
    }
    
    var url: URL?
    var image: UIImage?
    var title: String?
    var content: String?
    var contentType: SSDKContentType = .webPage
    
    
    @IBAction func shareButtonClick(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.copyURL()
        case 1:
            self.shareToWechat()
        case 2:
            self.shareToWechateTimeline()
        case 3:
            self.showImage()
        default:
            break
        }
        
    }
    
    func copyURL() {
        guard let url = self.url else {
            return
        }
        UIPasteboard.general.string = url.absoluteString
        HUD.showText(text: "复制成功")
    }
    
    func shareToWechat() {//微信好友
        let para = NSMutableDictionary()
        
        para.ssdkSetupShareParams(byText: self.content, images: self.image, url: url!, title: self.title, type: self.contentType)
        ShareSDK.share(.typeWechat, parameters: para) { (state, dic, entity, error) in
            self.popDismiss()
        }
    }
    
    func shareToWechateTimeline() {//朋友圈
        let para = NSMutableDictionary()
        
        para.ssdkSetupShareParams(byText: self.content, images: self.image, url: url!, title: self.title, type: self.contentType)
        ShareSDK.share(.subTypeWechatTimeline, parameters: para) { (state, dic, entity, error) in
            self.popDismiss()
        }
    }
    
    func showImage() {
        
    }
    
    

}
