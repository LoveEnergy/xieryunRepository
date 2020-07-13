//
//  URLButton.swift
//  GSCWallet
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 newborntown. All rights reserved.
//

import UIKit

class URLButton: UIButton {
    @IBInspectable var url: String = ""
    var needLocalize: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        self.addTarget(self, action: #selector(showURL), for: .touchUpInside)
    }
    
    @objc func showURL() {
        var urlString = self.url
        if needLocalize {
            urlString = URLHelper.localURL(string: urlString)
        }
        guard let url = URL(string: urlString) else {
            HUD.showText(text: "URL Error")
            return
        }
        BrowserHelper.showURL(url: url)
    }

}
