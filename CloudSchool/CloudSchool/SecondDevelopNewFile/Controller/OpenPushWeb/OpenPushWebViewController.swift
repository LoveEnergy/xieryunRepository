//
//  ViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/6/5.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import ObjectMapper
import Rswift

class OpenPushWebViewController: UIViewController {

    var webUrl: String = ""
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.coverWebView)
        self.view.backgroundColor = .white
        let itemBtn = UIBarButtonItem.init(customView: self.backBtn)
        self.navigationItem.leftBarButtonItem = itemBtn
    }
    
    
    lazy var backBtn : UIButton = {
        var btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        btn.setBackgroundImage(UIImage.init(named: "clear_back"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()

    @objc func btnClick(){
        self.dismiss(animated: true, completion: nil)
    }
    
    lazy var coverWebView: WKWebView = {
        weak var weakSelf = self
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        var wkUScript = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var wkUController = WKUserContentController.init()
                wkUController.addUserScript(wkUScript)
        var wkWebConfig = WKWebViewConfiguration.init()
        wkWebConfig.userContentController = wkUController
        var coverWebView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(NAVI_HEIGHT)), configuration: wkWebConfig)
        coverWebView.scrollView.bounces = true
        coverWebView.scrollView.showsHorizontalScrollIndicator = false
        coverWebView.scrollView.isScrollEnabled = true
        coverWebView.uiDelegate = self
        coverWebView.navigationDelegate = self
        coverWebView.backgroundColor = UIColor.clear
        coverWebView.load(URLRequest.init(url: URL.init(string: weakSelf!.webUrl)!))
        return coverWebView
    }()
}

extension OpenPushWebViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hideLoading()
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
        }
    }
}
