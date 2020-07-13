//
//  MyClassExpiredViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyClassExpiredViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = 10
    
    
    
    func didClick(indexPath: IndexPath) {
        //如果需要填写学籍并且没填写
        let model = self.data.value[indexPath.row]
        if model.isNeedSchoolRoll && !model.isHasSchoolRoll {
            let vc = R.storyboard.study.addSchoolRollViewController()!
            let vm = AddSchoolRollViewModel(eclassID: model.objectID.string)
            vm.fillCompleteBlock = {
                let vc = R.storyboard.study.classCoursesListViewController()!
                vc.model = model
                vc.studyID = self.data.value[indexPath.row].userStudyID.string
                vc.eclassID = model.objectID.string
                let title = self.data.value[indexPath.row].productName
                if title.count > 14 {
                    vc.title = title.nsString.substring(to: 13) + "..."
                } else {
                    vc.title = title
                }
                CurrentControllerHelper.pushViewController(viewController: vc)
            }
            vc.bindViewModel(viewModel: vm)
            CurrentControllerHelper.pushViewController(viewController: vc)
        } else {
            let vc = R.storyboard.study.classCoursesListViewController()!
            vc.model = model
            vc.studyID = self.data.value[indexPath.row].userStudyID.string
            vc.eclassID = model.objectID.string
            let title = self.data.value[indexPath.row].productName
            if title.count > 14 {
                vc.title = title.nsString.substring(to: 13) + "..."
            } else {
                vc.title = title
            }
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        
    }
    
    typealias Cell = ClassTableViewCell
    var cellType: ClassTableViewCell.Type = ClassTableViewCell.self
    
    var cellIdentifier: String {
        return R.nib.classTableViewCell.identifier
    }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    var title: String {
        return ""
    }
    
    
    
    
    enum StudyClassifyType {
        case all
        case course
        case myClass
    }
    
    var data: Variable<[ClassModel]> = Variable([])
    let disposeBag = DisposeBag()
    
    //    var data: Variable<[StudyModel]> = Variable([])
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
        
        UserHelper.shared.getClassList(type: "1", isExpire: "1")
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
        
    }
    
    func loadMore() {
        self.reloadBlock?()
    }
}
