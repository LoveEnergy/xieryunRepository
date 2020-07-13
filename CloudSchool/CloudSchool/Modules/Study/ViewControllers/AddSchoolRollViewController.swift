//
//  AddSchoolRollViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/5.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa

class AddSchoolRollViewController: QMUICommonViewController {
    
    var viewModel: AddSchoolRollViewModel?
    var editViewModel: ModifySchollRollViewModel?
    let disposeBag: DisposeBag = DisposeBag()
    var isLiveClassSchoolRoll: Bool = false
    
    @IBOutlet weak var saveButton: BaseButton!
    @IBOutlet weak var stackView: UIStackView!
    
    lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()//地址选择器
    var model: AddressModel = AddressModel(JSON: ["provinceID":110000, "cityID":110000, "countyID": 110101])!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton.addTarget(self, action: #selector(saveButtonClick), for: .touchUpInside)
        
        self.addTitleAddressView.title = "选择地址"
        self.addTitleAddressView.delegate = self
        self.addTitleAddressView.defaultHeight = kScreenHeight * 0.7
        self.addTitleAddressView.toDistrictRow = true
        self.view.addSubview(self.addTitleAddressView.initAddressView())
    }
    
    func bindViewModel(viewModel: AddSchoolRollViewModel) {
        self.viewModel = viewModel
        self.viewModel?.showLoadBlock = {
            HUD.loading(text: "")
        }
        self.viewModel?.hideLoadBlock = {
            HUD.hideLoading()
        }
        title = viewModel.title
        viewModel.data.asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.updateUI(list: list)
            })
        .disposed(by: disposeBag)
    }
    
    func bindViewModel(viewModel: ModifySchollRollViewModel) {
        self.editViewModel = viewModel
        self.viewModel?.showLoadBlock = {
            HUD.loading(text: "")
        }
        self.viewModel?.hideLoadBlock = {
            HUD.hideLoading()
        }
        title = viewModel.title
        viewModel.data.asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.updateUI(list: list)
            })
            .disposed(by: disposeBag)
    }
    
    func updateUI(list: [SchoolRollKeyValueModel]) {
        for item in list {
            let inputView = BaseTitleInputView(frame: .zero)
            inputView.title = item.displayName
            inputView.isMust = item.isMustFill
            if inputView.isMust == false {
                inputView.startLabel.isHidden = true
            }
            inputView.property = item.property
            inputView.placeHolder = "请输入\(item.displayName)"
            inputView.value = item.value ?? ""
            inputView.isMust = item.isMustFill
            self.stackView.addArrangedSubview(inputView)
            inputView.snp.makeConstraints { (make) in
                make.height.equalTo(50)
            }
            inputView.selectAddressBlock = {
                self.addTitleAddressView.isHidden = false
                UIView.animate(withDuration:0.2, animations: {
                    self.addTitleAddressView.addAddressView.frame.origin.y = ScreenHeight - self.addTitleAddressView.defaultHeight
                }, completion: nil)
            }
            inputView.selectBirthDayBlock = {
                self.birthDayView.show()
            }
        }
        
    }
    
    lazy var birthDayView : BirthDayView = {
        var birthDayView = BirthDayView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        birthDayView.getDateBlock = {(dateString) in
            for inputView in self.stackView.arrangedSubviews {
                if let inputView = inputView as? BaseTitleInputView {
                    if inputView.property == "dateBirth"{
                        inputView.textField.text = dateString
                    }
                }
            }
        }
        return birthDayView
    }()
    
    @objc func saveButtonClick() {
        var dicArray: [[String: Any]] = []
        for inputView in self.stackView.arrangedSubviews {
            if let inputView = inputView as? BaseTitleInputView {
                if inputView.textField.isEmpty && inputView.isMust {
                    inputView.textField.becomeFirstResponder()
                    HUD.showText(text: "请填写信息完全")
                    return;
                }
                if inputView.property == "email"{
                    if inputView.textField.isEmpty == false {
                        if self.validateEmail(email: inputView.textField.text!) == false {
                            HUD.showText(text: "请正确填写邮箱地址")
                            return
                        }
                    }
                }
                if inputView.property == "phone"{
                    if inputView.textField.isEmpty == false {
                        if self.validatePhone(phone: inputView.textField.text!) == false {
                            HUD.showText(text: "请正确填写手机号码")
                            return
                        }
                    }
                }
                if inputView.property == "idCard"{
                    if inputView.textField.isEmpty == false {
                        if self.validateIDCard(cardID: inputView.textField.text!) == false {
                            HUD.showText(text: "请正确填写身份证号码")
                            return
                        }
                    }
                }
                dicArray.append(inputView.propertyDic)
            }
        }
        if self.isLiveClassSchoolRoll == true {
            self.viewModel?.submitLiveClassSchoolRollInfo(dic: dicArray)
            self.editViewModel?.submitLiveClassSchoolRollInfo(dic: dicArray)
        }else{
            self.viewModel?.submitInfo(dic: dicArray)
            self.editViewModel?.submitInfo(dic: dicArray)
        }
    }
    
    func validateEmail(email: String) -> Bool {//邮箱正则
        let temp = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: temp)
    }
    func validatePhone(phone: String) -> Bool {//手机号正则
        let temp = phone.trimmingCharacters(in: .whitespacesAndNewlines)
        let phoneRegex = "^[1][3,4,5,7,8,9][0-9]{9}$"
        let phoneTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: temp)
    }
    func validateIDCard(cardID: String) -> Bool {//身份证号正则
        let temp = cardID.trimmingCharacters(in: .whitespacesAndNewlines)
        let cardRegex = "(\\d{18}|\\d{17}X)$"
        let cardTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", cardRegex)
        return cardTest.evaluate(with: temp)
    }
}

extension AddSchoolRollViewController: ZHFAddTitleAddressViewDelegate {
    func cancelBtnClick(titleAddress: String, titleID: String) {
        for inputView in self.stackView.arrangedSubviews {
            if let inputView = inputView as? BaseTitleInputView {
                if inputView.property == "position"{
                    inputView.textField.text = titleAddress
                }
            }
        }
        let arr = addTitleAddressView.titleIDMarr.map { (value) -> Int in
            return value as! Int
        }
        if arr.count > 0 {
            model.provinceID = arr[0]
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
}
