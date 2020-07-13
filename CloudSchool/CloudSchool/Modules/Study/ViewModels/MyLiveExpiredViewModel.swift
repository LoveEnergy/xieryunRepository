//
//  MyLiveExpiredViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/7/7.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyLiveExpiredViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = 10
    
    
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.study.courseVideoDetailViewController()!
        detailVC.userStudyID = model.userStudyID.string
        let viewModel: CourseWareListViewModel = CourseWareListViewModel(productID: model.productID.string)
        detailVC.viewModel = viewModel
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
    
    typealias Cell = LiveTableViewCell
    var cellType: LiveTableViewCell.Type = LiveTableViewCell.self
    
    var cellIdentifier: String {
        return R.nib.liveTableViewCell.identifier
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
        
        UserHelper.shared.getLiveList(type: "3", isExpire: "1")
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
