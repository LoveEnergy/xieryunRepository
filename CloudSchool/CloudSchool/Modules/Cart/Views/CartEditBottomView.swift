//
//  CartEditBottomView.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/11.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartEditBottomView: UIView {

    let disposeBag = DisposeBag()
    
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
    
    var deleteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        button.setTitle("删除", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        return button
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(selectAllButton)
        addSubview(deleteButton)
        
        selectAllButton.snp.makeConstraints { (make) in
            make.top.left.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.25)
        }
       
        deleteButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(self)
            make.width.equalTo(self).multipliedBy(0.25)
        }
        
        deleteButton.addTarget(self, action: #selector(deleteButtonClick), for: .touchUpInside)
        
        addResponse()
        
    }
    
    func addResponse() {
        let tap = (selectAllButton.rx.tap).map { () -> Bool in
            return !self.selectAllButton.isSelected
        }
        tap.bind(to: selectAllButton.rx.isSelected)
            .disposed(by: disposeBag)
        
        tap.asObservable()
            .subscribe(onNext: { (value) in
                CartHelper.shared.selectAll.onNext(!value)
            })
            .disposed(by: disposeBag)
        
        
    }
    
    @objc func deleteButtonClick() {
        CartHelper.shared.deleteAll()
    }

}
