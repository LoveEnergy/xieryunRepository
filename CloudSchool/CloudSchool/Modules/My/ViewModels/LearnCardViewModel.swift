//
//  LearnCardViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/3/5.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LearnCardViewModel: NSObject, OpenCardProtocol {
    var data: Variable<[CardInfo]> = Variable([])
    var tempArray: [StudyCardModel] = [StudyCardModel]()
    var reloadBlock: (() -> Void)?
    var pageNo: Int = 1
    let disposeBag = DisposeBag()
    var submitButtonTitle: String {
        return "激活学习卡"
    }
    var title: String {
        return "学习卡"
    }
    
    var cardPlaceHolder: String {
        return "请输入学习卡卡号"
    }
    
    var cardPasswordPlaceHolder: String {
        return "请输入密码"
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        self.pageNo = 1
        UserHelper.shared.learnCardList(pageNo: self.pageNo, pageSize: 1)
            .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.data.value = result.data?.rows ?? []
                self.tempArray = result.data?.rows ?? []
                self.reloadBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore(){
        self.pageNo = self.pageNo + 1
        UserHelper.shared.learnCardList(pageNo: self.pageNo, pageSize: 1)
        .asObservable()
        .subscribe(onNext: {[weak self] (result) in
            guard let `self` = self else { return }
            self.tempArray = self.tempArray + result.data!.rows
            self.data.value = self.tempArray
            self.reloadBlock?()
        })
        .disposed(by: disposeBag)
    }
    
    func submit(card: String, password: String) {
        HUD.loading(text: "")
        
        UserHelper.shared.activeLearnCard(learnCardNo: card, password: password)
            .subscribe(onNext: { (model) in
                HUD.hideLoading()
                model.errorDeal(successBlock: {
                    HUD.showText(text: "添加成功")
                    CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                })
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        
    }
}
