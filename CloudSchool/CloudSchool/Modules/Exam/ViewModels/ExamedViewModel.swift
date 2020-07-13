//
//  ExamedViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/23.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MZDownloadManager
//课程考试
class ExamedViewModel: NSObject {
    var downloadedFilesArray : Variable<[String]> = Variable([])
//    var data: Variable<[DownloadInfoModel]> = Variable([])
    var data: Variable<[ExamBaseInfoModel]> = Variable([])
    
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        
        self.update()
//        DownloadManager.shared.refreshSignal
//            .asObservable()
//            .subscribe(onNext: {[weak self] () in
//                guard let `self` = self else { return }
//                self.update()
//            })
//            .disposed(by: disposeBag)
    }
    
    func update() {
//        data.value = DownloadManager.shared.downloadedArray.map({ (task) -> DownloadInfoModel in
//            return DownloadInfoModel(task: task)
//        })
//        print(data.value)
        UserHelper.shared.getCourseExamList()
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
            }, onError: { (error) in
            })
        .disposed(by: disposeBag)
//        UserHelper.shared.getMyExamList()
//        .asObservable()
//            .subscribe(onNext: {[weak self] (list) in
//                guard let `self` = self else { return }
//                self.data.value = list.data
//            }, onError: { (error) in
//
//            })
//        .disposed(by: disposeBag)
    }
}
