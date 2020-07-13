//
//  AddAddressViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddAddressViewController: UIViewController {

    var isEdit: Bool = false
    
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var phoneInputView: BaseTitleInputView!
    @IBOutlet weak var nameInputView: BaseTitleInputView!
    
    @IBOutlet weak var addressPickerButton: UIButton!
    @IBOutlet weak var regionInputView: BaseTitleInputView!
    
    @IBOutlet weak var detailAddressInputView: BaseTitleInputView!
    let disposeBag: DisposeBag = DisposeBag()
    
    var model: AddressModel = AddressModel(JSON: ["provinceID":110000, "cityID":110000, "countyID": 110101])!
    
    lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        addressPickerButton.addTarget(self, action: #selector(showPicker), for: .touchUpInside)
//        AddressManager.shared.getProvinceList()
    }
    
    func configureUI() {
        title = "新建收货地址"
        nameInputView.title = "收货人"
        nameInputView.placeHolder = "请输入真实姓名"
        phoneInputView.title = "手机号码"
        phoneInputView.placeHolder = "11位手机号"
        phoneInputView.textField.maximumTextLength = 11
        regionInputView.title = "所在地区"
        regionInputView.placeHolder = "请选择"
        detailAddressInputView.title = "详细地址"
        detailAddressInputView.placeHolder = "街道、小区门牌等详细地址"
        
        addTitleAddressView.title = "选择地址"
        addTitleAddressView.userID = 7
        addTitleAddressView.delegate = self
        addTitleAddressView.defaultHeight = kScreenHeight * 0.7
        self.view.addSubview(addTitleAddressView.initAddressView())
        
        phoneInputView.textField.keyboardType = .numberPad
        
        update(model: model)
    }
    
    func update(model: AddressModel) {
        nameInputView.textField.text = model.userName
        phoneInputView.textField.text = model.phone
        detailAddressInputView.textField.text = model.address
        regionInputView.textField.text = model.provinceName
        
        (nameInputView.textField.rx.text).orEmpty
            .subscribe(onNext: { (text) in
                model.userName = text
            })
        .disposed(by: disposeBag)
        
        (phoneInputView.textField.rx.text).orEmpty
            .subscribe(onNext: { (text) in
                model.phone = text
            })
            .disposed(by: disposeBag)
        
        (regionInputView.textField.rx.text).orEmpty
            .subscribe(onNext: { (text) in
                model.address = text
            })
            .disposed(by: disposeBag)
        
        (detailAddressInputView.textField.rx.text).orEmpty
            .subscribe(onNext: {[weak self] (text) in
                guard let `self` = self else { return }
                model.address = (self.regionInputView.textField.text ?? "") + text
            })
            .disposed(by: disposeBag)
    }
    
    @objc func save() {
        if phoneInputView.textField.isEmpty {
            HUD.showText(text: "电话号码不允许为空")
            return
        }
        if isPhoneNumber(phoneNumber: phoneInputView.textField.text!) == false {
            HUD.showText(text: "请正确填写电话号码")
            return
        }
        if nameInputView.textField.isEmpty {
            HUD.showText(text: "收货人不允许为空")
            return
        }
        if regionInputView.textField.isEmpty {
            HUD.showText(text: "所在地区不允许为空")
            return
        }
        if detailAddressInputView.textField.isEmpty {
            HUD.showText(text: "详细地址不允许为空")
            return
        }
        if isEdit {
            UserHelper.shared.updateAddress(model: model)
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
            UserHelper.shared.saveAddress(model: model)
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
    
    @objc func showPicker() {
        self.view.endEditing(true)
        addTitleAddressView.addAnimate()
    }
    
    func cancelBtnClick(titleAddress: String, titleID: String) {
        self.regionInputView.textField.text = titleAddress
        self.model.address = titleAddress + (self.detailAddressInputView.textField.text ?? "")
        let arr = addTitleAddressView.titleIDMarr.map { (value) -> Int in
            return value as! Int
        }
        if arr.count > 0 {
            model.provinceID = arr[0]
            detailAddressInputView.textField.text = ""
        }
        if arr.count > 1 {
            model.cityID = arr[1]
        }
        if arr.count > 2 {
            model.countyID = arr[2]
        }
        if arr.count > 3 {
            model.streetID = arr[3]
        }
    }
    func isPhoneNumber(phoneNumber:String) -> Bool {
        if phoneNumber.count == 0 {
            return false
        }
        let mobile = "^1([358][0-9]|4[579]|66|7[0135678]|9[89])[0-9]{8}$"
        let regexMobile = NSPredicate(format: "SELF MATCHES %@",mobile)
        if regexMobile.evaluate(with: phoneNumber) == true {
            return true
        }else
        {
            return false
        }
    }
}

extension AddAddressViewController: ZHFAddTitleAddressViewDelegate {
    
}
