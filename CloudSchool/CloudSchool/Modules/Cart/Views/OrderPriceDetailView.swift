//
//  OrderPriceDetailView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderPriceDetailView: UIView {

    var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    let disposeBag = DisposeBag()
    
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "优惠券"
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "aaa"
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
//        self.backgroundColor = .orange
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
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
    }
    
    func configure(array: [ValueInfoProtocol]) {
        for subview in self.stackView.arrangedSubviews {
            self.stackView.removeArrangedSubview(subview)
            subview.removeFromSuperview()
            subview.isHidden = true
        }
        self.stackView.removeArrangedSubviews()
        for item in array {
            let view = BaseValueInfoView(name: item.name, value: item.value)
            self.stackView.addArrangedSubview(view)
        }
    }
    
    @objc func chooseAddress() {
        
    }

}

class BaseValueInfoView: UIView {
    var nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.colorWithHex(hex: "676767")
        return label
    }()
    
    var valueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(hex: "333333")
        return label
    }()
    
    init(name: String, value: String) {
        super.init(frame: .zero)
        baseConfigure()
        self.nameLabel.text = name
        self.valueLabel.text = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func baseConfigure() {
        addSubview(nameLabel)
        addSubview(valueLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.5/WIDTH_6_SCALE);
            make.centerY.equalTo(self)
//            make.height.equalTo(30/WIDTH_6_SCALE)
        }
        
        valueLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-13.5/WIDTH_6_SCALE);
            make.centerY.equalTo(self)
        }
        
    }
    
}

protocol ValueInfoProtocol {
    var value: String { get }
    var name: String { get }
}
