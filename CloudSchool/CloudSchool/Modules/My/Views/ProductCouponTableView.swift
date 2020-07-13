//
//  ProductCouponTableView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/25.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ProductCouponTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var type: CouponType = .unused
    var data: [GoodsCouponModel] = []
    
    var selectedCoupon: Variable<(GoodsCouponModel, RuleModel)?> = Variable(nil)
    
    var page: Int = 0
    var pageSize: Int = 10
    
    var isProduct: Bool = false
    var totalPrice: CGFloat = 0.0
    
    var productID: [String]? {
        didSet {
            self.loadData()
        }
    }
    
    
    let disposeBag: DisposeBag = DisposeBag()
    func baseConfigure() {
        self.register(R.nib.couponTableViewCell)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView()
        loadData()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func loadData() {
        
        if self.isProduct {
            guard let productID = self.productID else {
                return
            }
            
            RequestHelper.shared.getOrderCoupons(productIDs: productID)
                .subscribe(onNext: {[weak self] (model) in
                    guard let `self` = self else { return }
                    self.data = model.data
                    self.reloadData()
                    }, onError: { (error) in
                        
                })
                .disposed(by: disposeBag)
        } else {
            UserHelper.shared.getCouponList(pageNo: self.page, pageSize: self.pageSize, status: self.type.value)
                .subscribe(onNext: {[weak self] (model) in
                    guard let `self` = self else { return }
                    self.data = model.data?.rows ?? []
                    self.reloadData()
                    }, onError: { (error) in
                        
                })
                .disposed(by: disposeBag)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data[section].ruleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.couponTableViewCell, for: indexPath)!
        let model = self.data[indexPath.section]
        cell.configure(model: model, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = self.data[indexPath.section]
       
        let rule = model.ruleList[indexPath.row]
        if let activityType = ActivityType(rawValue: model.ruleType) {
            switch activityType {
            case .count:
                if self.productID!.count >= rule.count {
                    if self.totalPrice < CGFloat(rule.price) {
                        self.selectedCoupon.value = nil
                        HUD.showError(error: "金额未满\(rule.price) 元")
                    }else{
                        self.selectedCoupon.value = (model, model.ruleList[indexPath.row])
                    }
                } else {
                    self.selectedCoupon.value = nil
                    HUD.showText(text: "数量未满\(rule.count) 件")
                }
            case .price:
                if self.totalPrice >= rule.totalPrice.cgFloat {
                    self.selectedCoupon.value = (model, model.ruleList[indexPath.row])
                } else {
                    self.selectedCoupon.value = nil
                    HUD.showError(error: "金额未满\(rule.totalPrice) 元")
                    
                }
            }
        }
        
    }

}
