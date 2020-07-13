//
//  CartBottomView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartBottomView: UIView {
    
    let disposeBag = DisposeBag()
    var fromControllerName: String = ""
    var isMember: Int = 0//0.非会员  1.会员
    var selectAllButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("全选", for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.titleColor, for: .normal)
        button.setImage(R.image.cart_choose_n(), for: .normal)
        button.setImage(R.image.cart_selected(), for: .selected)
        return button
    }()
    
    var settleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        button.setTitle("去结算", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()
    
    var totalPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "总额：¥1000.0"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "777777")
        return label
    }()
    
    var discountLabel: UILabel = {
        let label = UILabel()
        label.text = "减免：¥0"
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor(hex: "777777")
        return label
    }()
    
    var finalPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.titleColor
        label.text = "合计：¥0"
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(stackView)
        
        let containerView = UIView()
        containerView.addSubview(finalPriceLabel)
        containerView.addSubview(totalPriceLabel)
        containerView.addSubview(discountLabel)
        
        finalPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(containerView)
            make.top.equalTo(containerView).offset(11)
        }
        
        totalPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(finalPriceLabel.snp.bottom).offset(2)
            make.left.equalTo(finalPriceLabel)
        }
        
        discountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(totalPriceLabel.snp.right)
            make.centerY.equalTo(totalPriceLabel)
        }
        
        stackView.addArrangedSubview(selectAllButton)
        stackView.addArrangedSubview(containerView)
        stackView.addArrangedSubview(settleButton)
        
        selectAllButton.snp.makeConstraints { (make) in
            make.width.equalTo(stackView).multipliedBy(0.25)
        }
        
        settleButton.snp.makeConstraints { (make) in
            make.width.equalTo(stackView).multipliedBy(0.25)
        }
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        settleButton.addTarget(self, action: #selector(generateOrder), for: .touchUpInside)
        
        addResponse()
        
        self.isMember = 0
        if let userModel = LoginHelper.getLocalUser() {//已登录状态
            if userModel.isMember == 1 {
                self.isMember = 1
            }
        }
        
    }
    
    func addResponse() {
        let tap = (selectAllButton.rx.tap)
        tap.map { () -> Bool in
            return !self.selectAllButton.isSelected
            }
            .subscribe(onNext: { (value) in
                CartHelper.shared.selectAll.onNext(value)
            })
        .disposed(by: disposeBag)
        
        CartHelper.shared.totalPrice
        .asObservable()
            .map { (value) -> String in
                return "总价：¥\(value)"
        }.bind(to: totalPriceLabel.rx.text)
        .disposed(by: disposeBag)
        
        
        CartHelper.shared.finalPrice
            .asObservable()
            .map { (value) -> String in
                return "合计：¥\(value)"
            }.bind(to: finalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        
        CartHelper.shared.isAllSelected
        .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.selectAllButton.isSelected = value
            })
        .disposed(by: disposeBag)
    }
    //    productType: 1、在线课程  2、书 籍  3、班级(objectType: 1、开课卡远程班  2、面授  3、付费远程班)  4、实物  5、直播课程
    @objc func generateOrder() {
        guard CartHelper.shared.selectedArray.count > 0 else {
            HUD.showError(error: "请选择商品")
            return
        }
        let vc = R.storyboard.cart.confirmOrderViewController()!
        vc.selectedArray = CartHelper.shared.selectedArray
        vc.isStudyCardPay = 1
        vc.isMember = self.isMember
        var productTypeArr: [Int] = [Int]()
        for num in 0...vc.selectedArray.count - 1 {
            productTypeArr.append(vc.selectedArray[num].productType)
        }
        for item in 0...productTypeArr.count {
            if productTypeArr[item] != productTypeArr[0] {
                HUD.showError(error: "线上课程与其他商品不能同时购买")
                return
            }
        }
        vc.productType = 1
        for item in vc.selectedArray {
            if item.isStudyCardPay == 0 {
                vc.isStudyCardPay = 0
            }
            if item.productType == 2 {
                vc.productType = 2
            }
        }
        vc.applePayID = ""
        if self.fromControllerName == "cartViewController" {
            vc.pageFromControllerName = self.fromControllerName
        }
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
