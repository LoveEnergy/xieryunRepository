//
//  CouponInstructionViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/8.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class CouponInstructionViewController: UIViewController, UINavigationControllerDelegate {
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "使用说明"
        self.view.addSubview(self.coverWebView)
        self.loadData()
    }
    
    func loadData(){
        HUD.loading(text: "")
        UserHelper.shared.couponInstruction().subscribe(onNext: {[weak self] (model) in
            HUD.hideLoading()
            if model.code == 200{
                self?.coverWebView.loadHTMLString(model.data!.instructions, baseURL: nil)
            }
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    lazy var coverWebView: WKWebView = {
        weak var weakSelf = self
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        var wkUScript = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var wkUController = WKUserContentController.init()
                wkUController.addUserScript(wkUScript)
        var wkWebConfig = WKWebViewConfiguration.init()
        wkWebConfig.userContentController = wkUController
        var coverWebView = WKWebView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT)), configuration: wkWebConfig)
        coverWebView.scrollView.bounces = true
        coverWebView.scrollView.showsHorizontalScrollIndicator = false
        coverWebView.uiDelegate = self
        coverWebView.navigationDelegate = self
        coverWebView.backgroundColor = UIColor.clear
        coverWebView.scrollView.isScrollEnabled = true
        return coverWebView
    }()
}

extension CouponInstructionViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hideLoading()
//        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
//        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
//        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
//        }
    }
}
