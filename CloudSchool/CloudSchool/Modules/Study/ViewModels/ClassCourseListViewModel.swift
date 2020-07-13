//
//  ClassCourseListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/29.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ClassCourseListViewModel: NSObject {
  
    
    var title: String {
        return ""
    }

    
    var data: Variable<[ClassCourseModel]> = Variable([])
    let disposeBag = DisposeBag()
    var studyID: String
    //    var data: Variable<[StudyModel]> = Variable([])
    
    init(studyID: String) {
        self.studyID = studyID
        super.init()
        self.loadData()
    }
    func loadData() {
        UserHelper.shared.getClassCourseList(userStudyID: self.studyID)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
    }
    
    func didClick(indexPath: IndexPath) {
//        let model = data.value[indexPath.row]
//        let detailVC = R.storyboard.study.courseVideoListViewController()!
//        detailVC.title = model.productName
//        detailVC.model = model
//        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
}
