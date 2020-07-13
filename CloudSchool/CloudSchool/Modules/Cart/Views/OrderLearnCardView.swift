//
//  OrderLearnCardView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/23.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit

class OrderLearnCardView: UIView {
    public var learnViewSelectBlock:((Bool)->())?
    let disposeBag = DisposeBag()
    var useLearnCard: Variable<Bool> = Variable(false)
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "学习卡   余额:"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWithHex(hex: "676767")
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.subTitleColor
        label.text = ""
        return label
    }()
    
    var checkButton: QMUIButton = {
        let button = QMUIButton(type: .custom)
        button.setTitle("使用学习卡", for: .normal)
        button.setTitleColor(UIColor.subTitleColor, for: .normal)
        button.imagePosition = .left
        button.spacingBetweenImageAndTitle = 10
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setImage(R.image.cart_choose_n(), for: .normal)
        button.setImage(R.image.cart_choose_s(), for: .selected)
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
//        self.backgroundColor = .cyan
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
        addSubview(checkButton)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.5/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(2)
            make.centerY.equalTo(titleLabel)
        }
        
        checkButton.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-10)
            make.height.equalTo(self)
            make.centerY.equalTo(self)
            make.width.equalTo(200)
        }
        
        self.isUserInteractionEnabled = true
        self.detailLabel.text = CartHelper.shared.learnCardAmount.numberFormat(length: 2)
        checkButton.addTarget(self, action: #selector(checkButtonClick), for: .touchUpInside)
    }
    
    @objc func checkButtonClick() {
        self.checkButton.isSelected = !self.checkButton.isSelected
        if self.checkButton.isSelected == true {
            self.learnViewSelectBlock?(true)
        }else{
            self.learnViewSelectBlock?(false)
        }
        useLearnCard.value = self.checkButton.isSelected
    }

}
