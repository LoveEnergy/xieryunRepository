//
//  PrivacyConfirmViewController.swift
//  KuTing
//
//  Created by Maynard on 2018/10/17.
//  Copyright © 2018 Pengxianhe. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class PrivacyConfirmViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: TTTAttributedLabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    override var hideNavigationBar: Bool {
        return true
    }
    
    var privacyDescription: String = """
      感谢您下载西尔APP！西尔重视您的隐私并严格遵守相关法律法规的要求。

      如您同意《西尔隐私政策》请点击“同意”开始使用我们的产品和服务，我们权力保护您的个人信息安全。

"""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        confirmButton.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        descriptionLabel.text = privacyDescription
        configureUI()
    }
    
    func configureUI() {
        cancelButton.borderColor = UIColor(hex: "333333")
        cancelButton.borderWidth = 0.5
        cancelButton.setTitleColor(UIColor(hex: "333333"), for: .normal)
        
        confirmButton.backgroundColor = UIColor(hex: "1FA2F8")
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        
        descriptionLabel.linkAttributes = [kCTForegroundColorAttributeName as NSAttributedString.Key: UIColor.rgb(r: 108, g: 152, b: 210),NSAttributedString.Key.underlineStyle: Int8(NSUnderlineStyle.single.rawValue)]
        if let range: Range = privacyDescription.range(of: "《西尔隐私政策》"){
            descriptionLabel.addLink(to: URL(string: Constant.privacyURL), with: privacyDescription.nsRange(from: range))
        }
        descriptionLabel.delegate = self

    }
    
    @objc func cancelClick() {
        HUD.showError(error: "请先同意隐私政策")
    }
    
    @objc func sureClick() {
        UserDefaults.Appalication.set(true, forKey: .privacyShowed)
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension PrivacyConfirmViewController {
    class func show() {
        guard !UserDefaults.Appalication.bool(forKey: .privacyShowed) else {
            return
        }
        let vc = R.storyboard.login.privacyConfirmViewController()!
        let nav = BaseNavigationViewController.init(rootViewController: vc)
        CurrentControllerHelper.presentViewController(viewController: nav)
        
    }
}

extension PrivacyConfirmViewController: TTTAttributedLabelDelegate {
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        BrowserHelper.showURL(url: URL(string: "http://www.cei.net.cn/contract.html")!)
    }
}
