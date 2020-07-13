//
//  ClassifyViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClassifyViewModel: NSObject {
    let disposeBag: DisposeBag = DisposeBag()
    
    var data: Variable<[HomeNavigationModel]> = Variable([])
    var subData: Variable<[SubSeriesModel]> = Variable([])
    var selectFirstSignal: PublishSubject<Void> = PublishSubject()
    
    var currentIndex: Int = 0 {
        didSet {
            if self.data.value.count > currentIndex {
                self.subData.value = self.data.value[currentIndex].childrenList
            }
        }
    }
    
    var currentNavModel: HomeNavigationModel? {
        if self.data.value.count > currentIndex {
            return self.data.value[currentIndex]
        }
        return nil
    }
    
    override init() {
        super.init()
        loadData()
    }
    
    func choose(model: HomeNavigationModel) {
        let index = self.data.value.indices(of: model)
        if let i = index.first {
            currentIndex = i
        }
    }
    
    func loadData() {
        RequestHelper.shared.getCourseSeriesList()
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
                let value = self.currentIndex
                self.currentIndex = value
                self.selectFirstSignal.onNext(())
//                self.datas = list.data
            })
            .disposed(by: disposeBag)
    }
}
