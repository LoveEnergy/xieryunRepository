//
//  InvoiceListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvoiceListViewModel: NSObject, ViewControllerBaseInfoProtocol {
    var title: String {
        return "发票管理"
    }
    
    var data: Variable<[InvoiceInfoModel]> = Variable([])
    let disposeBag = DisposeBag()
    
    func loadData() {
        UserHelper.shared.getInvoiceList()
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
    
    func editInvoice(model: InvoiceInfoModel) {
        let vc = R.storyboard.my.addInVoidceViewController()!
        vc.model = model
        vc.isEdit = true
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func deleteInvoice(model: InvoiceInfoModel) {
        UserHelper.shared.deleteInovice(invoiceID: model.invoiceID.string)
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
