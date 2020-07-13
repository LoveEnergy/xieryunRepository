//
//  ExamRecordViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/8.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExamRecordViewModel: NSObject {
    let disposeBag: DisposeBag = DisposeBag()
    
    var data: Variable<[ExamResultInfoModel]> = Variable([])
    
    var examID: String
    init(examID: String) {
        self.examID = examID
        super.init()
        self.loadData()
    }
    
    func loadData() {
        UserHelper.shared.getExamRecord(examID: self.examID)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
}
