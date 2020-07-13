//
//  BrowserHelper.swift
//  KuTing
//
//  Created by Maynard on 2018/3/23.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import SafariServices

class BrowserHelper: NSObject {
    static let shared = BrowserHelper()
    class func showURL(url: URL) {
        BrowserHelper.shared.showSafari(url: url)
    }
    
    func showSafari(url: URL) {
        let browserVC = SFSafariViewController(url: url)
        browserVC.delegate = self
        CurrentControllerHelper.presentViewController(viewController: browserVC)
    }
    
    
}

extension BrowserHelper: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        
    }
    
    func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        HUD.hideLoading()
    }
    
    
}

protocol URLShowable {
    var url: URL { get }
    func showURL()
}

extension URLShowable {
    func showURL() {
        BrowserHelper.showURL(url: url)
    }
}


struct StaticURL {
//    enum ImportIntroduce: URLShowable {
//        case mnemonic
//        case keystore
//        case privateKey
//        case watch
    
//        var path: String {
//            let path = Bundle.main.bundlePath
//
//            switch self {
//
//            case .mnemonic:
//                return URLHelper.localURL(string: Constants.importWallet)
//            case .keystore:
//                return "\(path)/html/import introduce/what-keystore.htm"
//            case .privateKey:
//                return "\(path)/html/import introduce/what-privateKey.htm"
//            case .watch:
//                return "\(path)/html/import introduce/what-mnemonic.htm"
//            }
//        }
//
//        var url: URL {
//            let string = URLHelper.localURL(string: Constants.importWallet)
//            let url = URL(string: string)!
//            return url
//        }
//    }
}
