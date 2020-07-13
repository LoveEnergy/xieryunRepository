//
//  ModifyPasswordViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/12.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ModifyPasswordViewController: UIViewController {
    @IBOutlet weak var originalInputView: BaseInputView!
    
    @IBOutlet weak var sureNewPasswordInputView: BaseInputView!
    @IBOutlet weak var newPasswordInputView: BaseInputView!
    @IBOutlet weak var sureButton: BaseButton!
    
    var viewModel: ModifyPasswordViewModel = ModifyPasswordViewModel()
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        (originalInputView.textField.rx.text)
            .orEmpty
            .asObservable()
            .bind(to: viewModel.originalPassword)
            .disposed(by: disposeBag)
        
        newPasswordInputView.textField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.newPassword)
            .disposed(by: disposeBag)
        
        sureNewPasswordInputView.textField.rx.text
            .orEmpty
            .asObservable()
            .bind(to: viewModel.repeateNewPassword)
            .disposed(by: disposeBag)
        
        viewModel.finishEnabled.asObservable()
            .bind(to: sureButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        title = "修改密码"
        originalInputView.placeHolder = "请输入原始密码"
        newPasswordInputView.placeHolder = "请输入新密码"
        sureNewPasswordInputView.placeHolder = "确认密码"
        sureButton.setTitle("完成", for: .normal)
        
        view.backgroundColor = UIColor.backgroundColor
        
        originalInputView.backgroundColor = UIColor.white
        newPasswordInputView.backgroundColor = UIColor.white
        sureNewPasswordInputView.backgroundColor = UIColor.white
    }

}
