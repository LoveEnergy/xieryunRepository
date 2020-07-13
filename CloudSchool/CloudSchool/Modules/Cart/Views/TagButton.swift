//
//  TagButton.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TagButton: UIButton {
    
    let disposeBag = DisposeBag()
    
    @IBInspectable var defaultSelected: Bool = false
    {
        didSet {
            self.pborderColor = UIColor(hex: "b2b2b2")
            self.isSelected = defaultSelected
            if defaultSelected {
                self.pborderColor = UIColor.mainRedColor
                
            } else {
                self.pborderColor = UIColor(hex: "b2b2b2")
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }

    func baseConfigure() {
        
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        setTitleColor(UIColor.mainRedColor, for: .selected)
        setTitleColor(UIColor.titleColor, for: .normal)
        
        setBackgroundColor(UIColor.white, forState: .normal)
        setBackgroundColor(UIColor.mainLightRedColor, forState: .selected)
//
        pborderWidth = 0.5
        self.rx.observeWeakly(Bool.self, "selected", options: KeyValueObservingOptions.new)
        .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                guard let value = value else { return }
                if value {
                    self.pborderColor = UIColor.mainRedColor
                } else {
                    self.pborderColor = UIColor(hex: "b2b2b2")
                }
            })
        .disposed(by: disposeBag)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.round()
    }
    

}
