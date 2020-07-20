//
//  CouponListView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/22.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CouponListView: UIView, BottomPopable, XibLoadable {
    var couponListArr : [ActivityModel] = [ActivityModel]()
    var viewHeight: CGFloat {
        return kScreenHeight * 0.8
    }
    
    
    @IBOutlet weak var closeButton: UIButton!
    var productID: [String]? {
        didSet {
            self.loadData()
        }
    }
    let disposeBag: DisposeBag = DisposeBag()
    var selectedCoupon: Variable<(GoodsCouponModel, RuleModel)?> = Variable(nil)
    var totalPrice: CGFloat = 0.0 {
        didSet {
            self.tableView.totalPrice = totalPrice
        }
    }
    
    @IBOutlet weak var tableView: ProductCouponTableView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.isProduct = true
        baseConfigure()
        loadData()
        tableView.backgroundColor = .red
    }
    
    func baseConfigure() {
        self.closeButton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
    }
    
    @objc func closeClick() {
        self.popDismiss()
    }
    
    func loadData() {
        tableView.productID = productID
        tableView.totalPrice = self.totalPrice
        tableView.selectedCoupon.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.selectedCoupon.value = value
//                self.closeClick()
            })
        .disposed(by: disposeBag)
        
        
    }
    
}
