//
//  ExamingViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/23.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import Tiercel
//班级考试
class ExamingViewModel: NSObject {
    let disposeBag = DisposeBag()
    
    var data: Variable<[ExamBaseInfoModel]> = Variable([])
    
    override init() {
        super.init()
        self.loadData()
        
    }
    
    func loadData() {
        UserHelper.shared.getMyExamList()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }

}
