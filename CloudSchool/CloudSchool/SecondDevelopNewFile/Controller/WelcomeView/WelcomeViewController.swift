//
//  WelcomeViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/22.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import ObjectMapper
import Rswift

class WelcomeViewController: UIViewController {

    var window: UIWindow?
    let disposeBag = DisposeBag()
    var productDetailBlock:((Int, Int)->())?//type productID
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.addSubview(self.coverWebView)
        RequestHelper.shared.welcomeInfo().asObservable().subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            if list.code == 200{
                if list.data?.type == 1 {//1.h5    2.商品详情
                    self.coverWebView.load(URLRequest.init(url: URL.init(string: list.data!.path)!))
                    self.title = list.data?.advertisingName ?? ""
                }else{
                    DispatchQueue.main.async {
                        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
                        self.window = UIWindow.init(frame: UIScreen.main.bounds)
                        let vc = storyBoard.instantiateInitialViewController()
                        self.window?.rootViewController = vc
                        self.window?.makeKeyAndVisible()
                        self.productDetailBlock?(list.data?.type ?? 0, list.data?.productID ?? 0)
                    }
                }
                
            }
        }).disposed(by: disposeBag)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        let vc = storyBoard.instantiateInitialViewController()
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
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
        return coverWebView
    }()
}

extension WelcomeViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hideLoading()
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
        }
    }
}
