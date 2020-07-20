//
//  OrderCouponView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderCouponView: UIView {
    public var couponIDBlock:((String)->())?
    public var selectCouponModel:((NewCouponList)->())?//选择的优惠券
    let disposeBag = DisposeBag()
    var products: [String] = [""]
    var selectedCoupon: Variable<(GoodsCouponModel, RuleModel)?> = Variable(nil)
    var totalPrice: CGFloat = 0.0
    var cellArray: [NewCouponList] = [NewCouponList]()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "优惠券"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.colorWithHex(hex: "676767")
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.titleColor
        label.textAlignment = .right
        label.text = "优惠券"
        return label
    }()
    
    var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.more_arrow())
        return imageView
    }()
    
    var address: AddressModel? {
        didSet {
            titleLabel.text = address?.address
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.5/WIDTH_6_SCALE)
            make.height.equalTo(15/WIDTH_6_SCALE)
            make.width.equalTo(50/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(arrowImageView.snp.left).offset(-13/WIDTH_6_SCALE)
            make.left.equalTo(self.titleLabel.snp.right)
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-13/WIDTH_6_SCALE)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.width.equalTo(7.5/WIDTH_6_SCALE)
            make.height.equalTo(12.5/WIDTH_6_SCALE)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseCoupon))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }

    lazy var productCouponListView : ProductCouponListView = {
        var productCouponListView = ProductCouponListView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        productCouponListView.productCouponListViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                productCouponListView.alpha = 0
            }) { (Bool) in
                productCouponListView.removeFromSuperview()
            }
        }
        productCouponListView.confirmControllerBool = true
        productCouponListView.confirmOrderControllerNewCouponModelBlock = {(model) in
            self.selectCouponModel?(model)
        }
        return productCouponListView
    }()
    
    @objc func chooseCoupon() {
//        let list = CouponListView.loadXib()
//        list.productID = self.products
//        list.totalPrice = self.totalPrice
//        list.bottomPopShow()
//        list.selectedCoupon.asObservable().skip(1)
//            .subscribe(onNext: {[weak self] (value) in
//                guard let `self` = self else { return }
//                if let value = value {
//                    self.selectedCoupon.value = value
//                    self.detailLabel.text = value.0.getActivityString(rule: value.1)
//                    let couponModel: GoodsCouponModel = value.0
//                    self.couponIDBlock?("\(couponModel.promotionID)")
//                }
//                list.popDismiss()
//            })
//        .disposed(by: disposeBag)
        self.productCouponListView.showView()
    }

}
