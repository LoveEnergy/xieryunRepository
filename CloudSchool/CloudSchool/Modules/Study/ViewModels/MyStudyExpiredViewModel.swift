//
//  MyStudyExpiredViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class MyStudyExpiredViewModel: NSObject,BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = 10
    
    func loadMore() {
        self.reloadBlock?()
    }
    
    var cellType: StudyTableViewCell.Type = StudyTableViewCell.self
    
    var cellIdentifier: String {
        return R.nib.studyTableViewCell.identifier
    }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    var title: String {
        return ""
    }
    
    
    typealias Cell = StudyTableViewCell
    
    enum StudyClassifyType {
        case all
        case course
        case myClass
    }
    
    var data: Variable<[StudyModel]> = Variable([])
    let disposeBag = DisposeBag()
    
    override init() {
        super.init()
        LoginHelper.shared.currentUser
        .asObservable()
            .subscribe(onNext: {[weak self] (_) in
                guard let `self` = self else { return }
                self.loadData()
            })
        .disposed(by: disposeBag)
        loadData()
    }

    func loadData() {
        UserHelper.shared.getStudyList(type: "2", isExpire: "1")
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
                self.reloadBlock?()
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.study.courseVideoDetailViewController()!
        detailVC.userStudyID = model.userStudyID.string
        if model.mediaType == 1{//音频
            let vc = FrequencyViewController.init()
            vc.teacherNameString = model.teacherName
            vc.courseID = model.courseID
            vc.teacherImgString = model.smallPhotoUrl
            vc.userStudyID = model.userStudyID.string
            CurrentControllerHelper.pushViewController(viewController: vc)
        }else{
            let viewModel: CourseWareListViewModel = CourseWareListViewModel(courseID: model.objectID.string)
            detailVC.viewModel = viewModel
            CurrentControllerHelper.pushViewController(viewController: detailVC)
        }
    }
}
