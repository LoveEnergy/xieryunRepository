//
//  CartListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/22.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CartListViewModel: NSObject {
    var data: [CartListModel] = []
    let disposeBag: DisposeBag = DisposeBag()
    var refreshSignal: PublishSubject<Void> = PublishSubject<Void>()
    
    override init() {
        super.init()
        CartHelper.shared.data.asObservable()
            .subscribe(onNext: {[weak self] (array) in
                guard let `self` = self else { return }
                if array.count > 0{
                    let tempArr = array[0]
                    let cellModelArr = tempArr.productList
//                    let afterFilterArr = cellModelArr.filter{$0.type == 2 || $0.type == 4}
//                    self.data = array
//                    self.data[0].productList = afterFilterArr
//                    self.refreshSignal.onNext(())
                    self.data = array
                    self.data[0].productList = cellModelArr
                    self.refreshSignal.onNext(())
                }
            })
        .disposed(by: disposeBag)
        CartHelper.shared.loadData()
        
        CartHelper.shared.refresh
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                CartHelper.shared.loadData()
            })
        .disposed(by: disposeBag)
    }
}
