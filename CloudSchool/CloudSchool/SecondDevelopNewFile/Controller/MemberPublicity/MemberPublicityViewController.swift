//
//  MemberPublicityViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/18.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import WebKit

class MemberPublicityViewController: UIViewController, UINavigationControllerDelegate {
    let bottomH = 50/WIDTH_6_SCALE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "西尔会员"
        self.view.backgroundColor = .white
        self.view.addSubview(self.coverWebView)
        self.view.addSubview(self.bottomView)
    }
    
    lazy var bottomView : UIImageView = {
        var bottomView = UIImageView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - bottomH - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT), width: SCREEN_WIDTH, height: bottomH))
        bottomView.image = UIImage.init(named: "member_ublicity_bottom")
        bottomView.backgroundColor = .clear
        return bottomView
    }()
    
    lazy var coverWebView: WKWebView = {
        weak var weakSelf = self
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        var wkUScript = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var wkUController = WKUserContentController.init()
                wkUController.addUserScript(wkUScript)
        var wkWebConfig = WKWebViewConfiguration.init()
        wkWebConfig.userContentController = wkUController
        var coverWebView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(NAVI_HEIGHT) - bottomH), configuration: wkWebConfig)
        coverWebView.scrollView.bounces = true
        coverWebView.scrollView.showsHorizontalScrollIndicator = false
        coverWebView.uiDelegate = self
        coverWebView.navigationDelegate = self
        coverWebView.backgroundColor = UIColor.clear
        coverWebView.scrollView.isScrollEnabled = true
        let url = "http://data.cei.net.cn/images/product/vip_bg.png"
        let html  = "<!DOCTYPE html>\n<html>\n<head>\n<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no,minimal-ui\">\n</head>\n<body>\n<img src=\"\(url)\"  width=\"100%\" >\n</body>\n</html>"
        coverWebView.loadHTMLString(html, baseURL: nil)
        return coverWebView
    }()
    
}

extension MemberPublicityViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    }
}
