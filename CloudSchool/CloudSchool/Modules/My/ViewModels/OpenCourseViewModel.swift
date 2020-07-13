//
//  OpenCourseViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/3/5.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

protocol OpenCardProtocol {
    var title: String { get }
    var cardPlaceHolder: String { get }
    var cardPasswordPlaceHolder: String { get }
    var data: Variable<[CardInfo]> { get set }
    var submitButtonTitle: String { get }
    
    func submit(card: String, password: String)
    
}

import RxSwift
import RxCocoa

class OpenCourseViewModel: NSObject, OpenCardProtocol {
    var data: Variable<[CardInfo]> = Variable([])
    
    var submitButtonTitle: String {
        return "激活开课卡"
    }
    
    
    let disposeBag = DisposeBag()
    
    var title: String {
        return "开课卡"
    }
    
    var cardPlaceHolder: String {
        return "请输入开课卡卡号"
    }
    
    var cardPasswordPlaceHolder: String {
        return "请输入激活码"
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        UserHelper.shared.getCourseCardList(pageNo: 0, pageSize: 20)
            .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.data.value = result.data?.rows ?? []
            })
            .disposed(by: disposeBag)
    }
    
    func submit(card: String, password: String) {
        HUD.loading(text: "")
        UserHelper.shared.useCourseCard(cardNo: card, code: password)
            .subscribe(onNext: { (model) in
                HUD.hideLoading()
                model.errorDeal(successBlock: {
                    HUD.showText(text: "开课成功")
                    CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                })
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}
