//
//  ShareHelper.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/8.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class ShareHelper: NSObject {
    
    
    class func presentSharing(in viewController: UIViewController, from sender: UIView, url: URL) {
//        let shareDic: NSMutableDictionary = NSMutableDictionary()
//        shareDic.ssdkSetupShareParams(byText: "分享", images: UIImage(), url: URL(string: "http://www.baidu.com")!, title: "测试", type: .audio)
//        let item = SSUIPlatformItem()
//        item.platformName = "微信哥哥"
//        let config = SSUIShareSheetConfiguration()
//
//        ShareSDK.showShareActionSheet(viewController.view, customItems: nil, shareParams: shareDic, sheetConfiguration: config) { (state, type, dic, entity, error, success) in
//
//        }
//        item.
        let activityViewController = UIActivityViewController.make(items: [url])
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.centerRect
        viewController.present(activityViewController, animated: true, completion: nil)
        
        
    }
    
    class func register() {
        ShareSDK.registPlatforms { (register) in
//            register?.setupWeChat(withAppId: "wx02cd37210445b712", appSecret: "5d5256583eaee54b3dcebfe8df25a4c2", universalLink: "https://up.yushangai.top/")
            register?.setupWeChat(withAppId: "wx02cd37210445b712", appSecret: "5d5256583eaee54b3dcebfe8df25a4c2", universalLink: "https://www.cei.net.cn/")
            register?.setupQQ(withAppId: "101401513", appkey: "0273e4683159fa105906e484ad1f014b")
            register?.setupSinaWeibo(withAppkey: "66571766", appSecret: "a0e52d378bceb5f9c1a92b367a4e3f44", redirectUrl: "https://www.cei.net.cn/")
        }
        WXApi.registerApp("wx02cd37210445b712", universalLink: "https://www.cei.net.cn/")
    }
    
    class func presentSharing(in viewController: UIViewController, from sender: UIView ,image: UIImage) {
        let activityViewController = UIActivityViewController.make(items: [image])
        activityViewController.popoverPresentationController?.sourceView = sender
        activityViewController.popoverPresentationController?.sourceRect = sender.centerRect
        viewController.present(activityViewController, animated: true, completion: nil)
    }
    
    class func customShare(url: URL, image: UIImage?, title: String?, content: String?) {
        let shareView = ShareView.loadXib()
        shareView.url = url
        shareView.image = image
        shareView.title = title
        shareView.content = content
        shareView.bottomPopShow()
    }
    
    class func customShare(url: URL, image: UIImage?, title: String?, content: String?, contentType: SSDKContentType = .webPage) {
        let shareView = ShareView.loadXib()
        shareView.url = url
        shareView.image = image
        shareView.title = title
        shareView.content = content
        shareView.contentType = contentType
        shareView.bottomPopShow()
    }
}

extension UIActivityViewController {
    static func make(items: [Any]) -> UIActivityViewController {
        return UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
}

extension UIView {
    var centerRect: CGRect {
        return CGRect(x: self.bounds.midX, y: self.bounds.midY, width: 0, height: 0)
    }
}
