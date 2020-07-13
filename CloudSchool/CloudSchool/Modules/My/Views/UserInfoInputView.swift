//
//  UserInfoInputView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/1/12.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa



class UserInfoInputView: UIView, XibLoadable, Popable {
    @IBOutlet weak var titleButton: UIButton!
    
    @IBOutlet weak var textInputView: BaseInputView!
    
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var sureBlock: ((String) -> Void)?
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var autoDismiss: Bool {
        return true
    }
    
    var title: String? {
        didSet {
            titleButton.setTitle(title, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        self.pcornerRadius = 5
        (cancelButton.rx.tap).asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.popDismiss()
            })
        .disposed(by: disposeBag)
        
        (sureButton.rx.tap).asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.sureBlock?(self.textInputView.textField.text ?? "")
                self.popDismiss()
            })
            .disposed(by: disposeBag)
    }

}
