//
//  NewsBrowserViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/14.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsBrowserViewController: UIViewController {

    //    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    
    let disposeBag = DisposeBag()
    
    var url: URL? {
        didSet {
            loadURL()
        }
    }
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        self.url = URL(string: "http://app.maple.pub/xier/")
//        self.url = URL(string: "http://www.cei.net.cn/mobile/Laws")
        self.url = URL(string: "http://39.98.42.158/mobile/Laws")
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        title = "环境法宝"
    }
    
    func loadURL() {
        guard let url = url else {
            return
        }
        HUD.loading(text: "",onViewController: self)
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    deinit {
        HUD.hideLoading()
    }
    
}

extension NewsBrowserViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hideLoading()
        let size = webView.sizeThatFits(.zero)
        //        webViewHeightConstraint.constant = size.height
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        HUD.showError(error: error.localizedDescription)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }

}
