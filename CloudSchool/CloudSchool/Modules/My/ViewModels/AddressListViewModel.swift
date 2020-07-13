//
//  AddressListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class AddressListViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String {
        return "收货地址"
    }
    
    var data: Variable<[AddressModel]> = Variable([])
    let disposeBag = DisposeBag()
    
    func loadData() {
        UserHelper.shared.getAddressList()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func editAddress(model: AddressModel) {
        let vc = R.storyboard.my.addAddressViewController()!
        vc.model = model
        vc.isEdit = true
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func deleteAddress(model: AddressModel) {
        UserHelper.shared.deleteAddress(id: model.addressID)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.showText(text: model.message ?? "删除成功")
                    self.loadData()
                })
            }, onError: { (error) in
                
        })
        .disposed(by: disposeBag)
    }

}

protocol AddressInfo {
    var userName: String { get set }
    var phone: String { get set }
    var address: String { get set }
    var isDefault: Bool { get set }
}
