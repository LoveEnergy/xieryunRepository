//
//  CouponTableView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DZNEmptyDataSet

enum CouponType {
    case overdue
    case used
    case unused
    
    var value: Int {
        switch self {
        case .overdue:
            return 2
        case .used:
            return 1
        case .unused:
            return 0
        }
    }
}

class CouponTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var type: CouponType = .unused {
        didSet {
            self.loadData()
        }
    }
    var data: [NewCouponList] = []
    var page: Int = 1
    var pageSize: Int = 10
    var isProduct: Bool = false
    var productID: String? {
        didSet {
            self.loadData()
        }
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    func baseConfigure() {
//        self.register(R.nib.couponTableViewCell)
        self.register(ProductCouponListViewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ProductCouponListViewTableViewCell.self))
        self.separatorStyle = .none
        self.delegate = self
        self.dataSource = self
        self.emptyDataSetSource = self
        self.tableFooterView = UIView()
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            RequestHelper.shared.getOrderCoupons(productIDs: [productID])
                .subscribe(onNext: {[weak self] (model) in
                    guard let `self` = self else { return }
//                    self.data = model.data
                    self.reloadData()
                    }, onError: { (error) in
                        
                })
                .disposed(by: disposeBag)
        } else {
            UserHelper.shared.searchUserCoupon(status: self.type.value, pageNo: self.page, pageSize: self.pageSize).subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.data = model.data?.rows ?? []
                self.reloadData()
                }, onError: { (error) in

            })
            .disposed(by: disposeBag)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductCouponListViewTableViewCell.self), for: indexPath) as! ProductCouponListViewTableViewCell
        let model = self.data[indexPath.row]
        cell.model = model
        if self.type.value == 0 {
            if model.crowdScope == 2 {
                cell.bgView.image = UIImage.init(named: "coupon_vip_unused_bg")
            }else{
                cell.bgView.image = UIImage.init(named: "coupon_usual_unused_bg")
            }
        }
        if self.type.value == 1 {
            if model.crowdScope == 2 {
                cell.bgView.image = UIImage.init(named: "coupon_vip_used_bg")
            }else{
                cell.bgView.image = UIImage.init(named: "coupon_usual_used_bg")
            }
        }
        if self.type.value == 2 {
            cell.reduceLab.textColor = UIColor.colorWithHex(hex: "828282")
            if model.crowdScope == 2 {
                cell.bgView.image = UIImage.init(named: "coupon_vip_expired_bg")
            }else{
                cell.bgView.image = UIImage.init(named: "coupon_usual_expired_bg")
            }
            cell.lastDayLab.text = ""
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = self.data[indexPath.row]
//        UserHelper.shared.getCoupon(promotionID: model.promotionID.string, ruleID: (model.ruleList.first?.ruleID.string ?? ""))
//        .asObservable()
//            .subscribe(onNext: {[weak self] (model) in
//                guard let `self` = self else { return }
//            })
//        .disposed(by: disposeBag)
        let vc = DiscountProductViewController.init()
        vc.productScope = self.data[indexPath.row].productScope
        vc.promotionID = self.data[indexPath.row].promotionID
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105/WIDTH_6_SCALE
    }
}

extension CouponTableView: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}

