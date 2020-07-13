//
//  GetCouponViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/7.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ActiveCouponViewController: UIViewController {

    @IBOutlet weak var activeButton: BaseButton!
    @IBOutlet weak var couponNumberInputView: BaseInputView!
    
    var viewModel: ActiveCouponViewModel = ActiveCouponViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    

    func configureUI() {
        title = viewModel.title
        couponNumberInputView.placeHolder = viewModel.placeHolder
        
        (couponNumberInputView.textField.rx.text)
            .orEmpty
            .asObservable()
            .bind(to: viewModel.couponNumber)
            .disposed(by: disposeBag)
        
        viewModel.bindActiveAction(tap: activeButton.rx.tap)
        
        viewModel.enabled.asObservable()
            .bind(to: activeButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }

}
