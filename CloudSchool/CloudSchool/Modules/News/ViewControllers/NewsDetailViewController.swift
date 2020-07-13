//
//  NewsDetailViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import WebKit
import RxSwift
import RxCocoa

class NewsDetailViewController: UIViewController {

//    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var watchNumberButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    let disposeBag = DisposeBag()
    
    var pageID: String?
    
    var url: URL? {
        didSet {
            loadURL()
        }
    }
    
    var htmlString: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func shareButtonClick(_ sender: UIButton) {
        let image = self.webView.qmui_snapshotLayerImage()
        ShareHelper.presentSharing(in: self, from: sender, image: image)
    }
    
    func configureUI() {
        if let htmlString = self.htmlString.emptyToNil() {
            self.webView.loadHTMLString(htmlString, baseURL: nil)
        }
        if let _ = self.pageID {
            self.loadData()
        }
    }
    
    func loadURL() {
        guard let url = url else {
            return
        }
        HUD.loading(text: "")
        let request = URLRequest(url: url)
        webView.loadRequest(request)
        webView.delegate = self
    }
    
    func loadData() {
        
        guard let pageID = self.pageID else {
            return
        }
        RequestHelper.shared.getNewsDetailList(informationID: pageID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                if let name = model.data?.pageName {
                    self.title = name.nsString.substring(to: min(14, name.count))
                }
                
                if let htmlString = model.data?.webContent.emptyToNil() {
                    self.titleLabel.text = model.data?.pageName
                    self.dateLabel.text = model.data?.updateTime
                    self.watchNumberButton.isHidden = true
                    self.webView.loadHTMLString(htmlString, baseURL: nil)
                }
                
            })
            .disposed(by: disposeBag)
    }
    
    deinit {
        HUD.hideLoading()
    }

}

extension NewsDetailViewController: UIWebViewDelegate {
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
