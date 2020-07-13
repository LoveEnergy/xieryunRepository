//
//  GetOpenCourseViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/9/1.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GetOpenCourseViewModel: NSObject, OpenCardProtocol {
    var data: Variable<[CardInfo]> = Variable([])
    
    var submitButtonTitle: String {
        return "获取开课卡"
    }
    
    
    let disposeBag = DisposeBag()
    
    var title: String {
        return "开课卡"
    }
    
    var cardPlaceHolder: String {
        return "请输入手机号"
    }
    
    var cardPasswordPlaceHolder: String {
        return "请输入激活码"
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
//        UserHelper.shared.getCourseCardList(pageNo: 0, pageSize: 20)
//            .asObservable()
//            .subscribe(onNext: {[weak self] (result) in
//                guard let `self` = self else { return }
//                self.data.value = result.data?.rows ?? []
//            })
//            .disposed(by: disposeBag)
    }
    
    func submit(card: String, password: String) {
        HUD.loading(text: "")
        UserHelper.shared.getCourseCard(phone: card, password: password)
            .subscribe(onNext: { (model) in
                HUD.hideLoading()
                model.errorDeal(successBlock: {
                    HUD.showText(text: "获取开课卡成功")
                    self.data.value = model.data
                })
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
    }
    
    
}

