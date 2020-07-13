
//
//  RechargeMethodView.swift
//  KuTing
//
//  Created by 彭显鹤 on 2018/3/25.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class PayMethodView: UIView {
    
    var method: PaymentType = .alipay {
        didSet {
            self.moneyButton.isSelected = method == .money
            self.wechatButton.isSelected = method == .wechat
            self.aliPayButton.isSelected = method == .alipay
        }
    }
    
    var rxMethod: Binder<PaymentType> {
        return Binder(self) { view, method in
            self.method = method
        }
    }

    @IBOutlet weak var moneyViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var view: UIView!
    @IBOutlet weak var moneyChooseButton: UIButton!
    @IBOutlet weak var moneyButton: UIButton!
    @IBOutlet weak var wechatButton: UIButton!
    @IBOutlet weak var wechatChooseButton: UIButton!
    @IBOutlet weak var aliPayButton: UIButton!
    @IBOutlet weak var aliPayChooseButton: UIButton!
    
    var haveMoneyType: Bool = true {
        didSet {
            moneyViewHeightConstraint.constant = haveMoneyType == true ? 80 : 0
        }
    }
    let disposeBag: DisposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    private func initViewFromNib(){
        // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "PayMethodView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view.frame = bounds
        self.addSubview(view)
        baseConfigure()
        // Do any additional setup after loading the view.
    }
    
    func baseConfigure() {
        method = .wechat;
        Observable.of((moneyChooseButton.rx.tap)
            .asObservable()
            .map{ return PaymentType.money},
            (wechatChooseButton.rx.tap)
            .asObservable()
            .map{ return PaymentType.wechat},
            (aliPayChooseButton.rx.tap)
            .asObservable()
            .map{ return PaymentType.alipay }
            )
        .merge()
        .bind(to: self.rxMethod)
        .disposed(by: disposeBag)
        
        
    }

}
