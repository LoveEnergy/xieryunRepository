//
//  PayOrderViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa

class PayOrderViewController: QMUICommonViewController {
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var payMethodView: PayMethodView!
    var productType: Int = 0
    var objectType: Int = 0
    var viewModel: OrderPayViewModel?
    let disposeBag: DisposeBag = DisposeBag()
    var haveCourse: Bool = false
    var virtualType: Bool = true
    var submitPrice: CGFloat = 0.0
    var qrCodeImageUrl: String = ""
    var wechatNumber: String = ""
    var addressString: String = ""
    var productName: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        self.payButton.addTarget(self, action: #selector(payButtonClick), for: .touchUpInside)
        NotificationCenter.default.addObserver(self, selector: #selector(weixinPaySuccess), name: NSNotification.Name(rawValue: WeChatReturnSucceedPayNotification), object: nil)//微信支付
    }
    func configureUI() {
        self.payButton.backgroundColor = UIColor.mainRedColor
        
    }
    
    func bindViewModel(viewModel: OrderPayViewModel) {
        self.viewModel = viewModel
        
        viewModel.successBlock = { _ in
            HUD.showText(text: "支付成功")
            if self.haveCourse {
                HUD.showText(text: "支付失败")
            } else {
                let vc = PaySuccessViewController.init()
                vc.orderID = self.viewModel!.orderID
                vc.productType = self.productType
                vc.objectType = self.objectType
                vc.submitPrice = self.submitPrice
                vc.qrCodeImageUrl = self.qrCodeImageUrl
                vc.wechatNumber = self.wechatNumber
                vc.addressString = self.addressString
                vc.productName = self.productName
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
        }
    }
    
    @objc func payButtonClick() {
        self.viewModel?.method = self.payMethodView.method
        self.viewModel?.requestPay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let orderID = self.viewModel?.orderID {
            UserHelper.shared.getPayResult(orderID: orderID)
            .asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    guard let `self` = self else { return }
                    if result.code == 200 {
                        
                    }
                })
            .disposed(by: disposeBag)
        }
        
        
    }
    
    @objc func weixinPaySuccess(){
        //支付成功
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
