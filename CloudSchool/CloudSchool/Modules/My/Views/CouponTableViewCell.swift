//
//  CouponTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CouponTableViewCell: UITableViewCell {

    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var getButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var goodsButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    var model: GoodsCouponModel?
    var index: Int = 0
    let disposeBag: DisposeBag = DisposeBag()
    
    var canGet: Bool = false {
        didSet {
//            if canGet {
//                self.backImageView.image = R.image.my_coupon_e()
//                self.getButton.isHidden = false
//            } else {
                self.backImageView.image = R.image.my_coupon_d()
                self.getButton.isHidden = true
//            }
//            self.getButton.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.backgroundColor
        goodsButton.isHidden = true
        getButton.backgroundColor = UIColor(hex: "FFF100")
        getButton.setCornerRadius(radius: 12)
        getButton.addTarget(self, action: #selector(getCoupon), for: .touchUpInside)
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    //这个
    func configure(model: GoodsCouponModel, index: Int) {
        self.model = model
        nameLabel.text = model.getActivityString(rule: model.ruleList[index])
        dateLabel.text = "\(model.startTime) - \(model.endTime)"
        if LoginHelper.shared.haveCoupon(model: model, rule: model.ruleList[index]) {
            canGet = false
        } else {
            canGet = true
        }
        if model.ruleType == 1{
            self.valueLabel.text = model.ruleList[index].price.string
        }else{
            self.valueLabel.text = model.ruleList[index].price.string
        }
    }
    
    func configure(model: GoodsCouponModel) {
        nameLabel.text = model.getActivityString()
        dateLabel.text = "\(model.startTime) - \(model.endTime)"
        canGet = false
        self.valueLabel.text = model.getCouponString()
    }
    
    @objc func getCoupon() {
        guard let model = self.model else { return }
        let ruleID = model.ruleList[index].ruleID.string
        UserHelper.shared.getCoupon(promotionID: model.promotionID.string, ruleID: ruleID)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.showText(text: "领取成功")
                    self.canGet = false
                    LoginHelper.shared.getCouponList()
                })
            })
            .disposed(by: disposeBag)
    }
}
