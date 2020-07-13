//
//  OrderAddressView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderUserInfoView: UIView {
    
    let disposeBag = DisposeBag()

    var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.titleColor
        return label
    }()
    
    var phoneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.subTitleColor
        return label
    }()
    
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
        addSubview(nameLabel)
        addSubview(phoneLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15)
            make.top.equalTo(self).offset(10)
        }
        
        phoneLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        LoginHelper.shared.currentUser
        .asObservable()
            .subscribe(onNext: {[weak self] (info) in
                guard let `self` = self else { return }
                self.nameLabel.text = info?.nickName
                self.phoneLabel.text = info?.phone
            })
        .disposed(by: disposeBag)
    }

}
