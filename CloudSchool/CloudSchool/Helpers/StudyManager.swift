//
//  StudyManager.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/22.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class StudyManager: NSObject {
    static let shared: StudyManager = StudyManager()
    var startTime: String = Date().videoTimeFormatterString
    var endTime: String = Date().videoTimeFormatterString
    var userStudyID: String = ""
    var currentModel: CourseWareModel?
    let disposeBag: DisposeBag = DisposeBag()
    
    func recordEndTime() {
        guard let model = self.currentModel else { return }
        self.endTime = Date().videoTimeFormatterString
        self.updateTime(model: model)
    }

    
    func updateTime(model: CourseWareModel) {
        UserHelper.shared.updateCourseProgress(userStudyID: self.userStudyID, courseID: model.courseID.string, startTime: self.startTime, endTime: self.endTime)
            .asObservable()
            .subscribe(onNext: { (result) in
                
            })
            .disposed(by: disposeBag)
        self.endTime = ""
    }
}
