//
//  AddInVoidceViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddInVoidceViewController: UIViewController {

    var isEdit: Bool = false
    
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var phoneInputView: BaseTitleInputView!
    @IBOutlet weak var nameInputView: BaseTitleInputView!
    
    let disposeBag: DisposeBag = DisposeBag()
    
    var model: InvoiceInfoModel = InvoiceInfoModel(JSON: ["provinceID":110000, "cityID":110000, "countyID": 110101])!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        AddressManager.shared.getProvinceList()
    }
    
    func configureUI() {
        title = "新建发票"
        nameInputView.title = "公司名称"
        nameInputView.placeHolder = "请输入公司名称"
        phoneInputView.title = "企业税号"
        phoneInputView.placeHolder = "请输入税号"
        
        update(model: model)
    }
    
    func update(model: InvoiceInfoModel) {
        nameInputView.textField.text = model.companyName
        phoneInputView.textField.text = model.taxpayerNo
        
        
        (nameInputView.textField.rx.text).orEmpty
            .subscribe(onNext: { (text) in
                model.companyName = text
            })
            .disposed(by: disposeBag)
        
        (phoneInputView.textField.rx.text).orEmpty
            .subscribe(onNext: { (text) in
                model.taxpayerNo = text
            })
            .disposed(by: disposeBag)
        
    }
    
    @objc func save() {
        if isEdit {
            UserHelper.shared.updateInvoice(invoiceID: self.model.invoiceID.string, invoiceType: self.model.invoiceType, invoiceRise: self.model.invoiceRise, companyName: self.model.companyName, taxpayerNo: self.model.taxpayerNo, contentType: self.model.contentType.string)
                .asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    guard let `self` = self else { return }
                    result.errorDeal(successBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    }, onError: { (error) in
                        HUD.showError(error: error.localizedDescription)
                })
                .disposed(by: disposeBag)
        } else {
            UserHelper.shared.saveInvoice(invoiceType: self.model.invoiceType, invoiceRise: self.model.invoiceRise, companyName: self.model.companyName, taxpayerNo: self.model.taxpayerNo, contentType: self.model.contentType.string, email: "")
                .asObservable()
                .subscribe(onNext: {[weak self] (object) in
                    guard let `self` = self else { return }
                    object.errorDeal(successBlock: {
                        self.navigationController?.popViewController(animated: true)
                    })
                    }, onError: { (error) in
                        HUD.showError(error: error.localizedDescription)
                })
                .disposed(by: disposeBag)
        }
        
    }
    
    
    

}
