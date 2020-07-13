//
//  CartButtonView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartButtonView: UIView {
    
    let disposeBag = DisposeBag()

    lazy var button: UIButton = {
        let button = UIButton(type: .custom)
//        button.setImage(R.image.shopping_car(), for: .normal)
        button.setImage(UIImage.init(named: "new_cart"), for: .normal)
        return button
    }()
    
    lazy var numberButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        button.backgroundColor = UIColor.mainRedColor
        button.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("0", for: .normal)
        button.pcornerRadius = 5
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        addSubview(button)
        addSubview(numberButton)
        
        button.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        numberButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).offset(-10)
        }
        button.addTarget(self, action: #selector(gotoCartVC), for: .touchUpInside)
        
        CartHelper.shared.goodsNumber
            .asObservable()
            .map{ return $0.toString() }
            .bind(to: numberButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        
    }
    
    @objc func gotoCartVC() {
        CartHelper.showCartVC()
    }

}
