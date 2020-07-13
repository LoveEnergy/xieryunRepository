//
//  BindPhoneViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/12.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BindPhoneViewController: UIViewController {

    @IBOutlet weak var finishButton: BaseButton!
    @IBOutlet weak var getCodeButton: UIButton!
    @IBOutlet weak var codeInputView: BaseInputView!
    @IBOutlet weak var phoneInputView: BaseInputView!
    
    var viewModel: BindPhoneViewModel = BindPhoneViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        (phoneInputView.textField.rx.text)
            .orEmpty
            .asObservable()
            .bind(to: viewModel.phone)
            .disposed(by: disposeBag)
    
        codeInputView.textField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.code)
            .disposed(by: disposeBag)
        
        viewModel.bindabled.asObservable()
            .bind(to: finishButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
    }
    
    func configureUI() {
        title = "绑定手机"
        phoneInputView.placeHolder = "输入要绑定的手机号"
        codeInputView.placeHolder = "验证码"
        
        phoneInputView.backgroundColor = UIColor.white
        codeInputView.backgroundColor = UIColor.white
    }
}
