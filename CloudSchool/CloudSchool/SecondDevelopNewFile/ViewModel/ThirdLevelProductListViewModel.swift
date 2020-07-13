//
//  CourseListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/3.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ThirdLevelProductListViewModel: NSObject, BaseListViewModel {
    var page: Int = 1
    
    var pageSize: Int = Constant.pageSize
    
    
    
    var title: String { return "" }
    
    var cellHeight: CGFloat {
        return 110
    }
    var parentID: String
    var seriesID: String
    
    var reloadBlock:(()-> Void)?
    
    typealias Cell = HomeCourseTableViewCell
    let disposeBag: DisposeBag = DisposeBag()
    var data: Variable<[HomeCourseTableViewCell.Model]> = Variable([])
    
    var cellType: HomeCourseTableViewCell.Type = HomeCourseTableViewCell.self
    
    var cellIdentifier: String { return R.nib.homeCourseTableViewCell.identifier }
    
    init(parentID: String, seriesID: String) {
        self.parentID = parentID
        self.seriesID = seriesID
        super.init()
        self.loadData()
    }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = model.productID
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
    
    func loadData() {
        self.page = 1
//        RequestHelper.shared.getCoursesProductList(id: self.parentID, type: "", classType: "", seriesID: self.seriesID, pageNo: self.page.string, pageSize: self.pageSize.string)
//            .asObservable()
//            .subscribe(onNext: {[weak self] (list) in
//                guard let `self` = self else { return }
//                self.data.value = list.data?.rows ?? []
//                self.reloadBlock?()
//            })
//            .disposed(by: disposeBag)
        RequestHelper.shared.getThirdLevelProductList(parentID: self.parentID, seriesID: self.seriesID, pageNo: self.page.string, pageSize: self.pageSize.string)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
                self.reloadBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore() {
        self.page += 1
//        RequestHelper.shared.getCoursesProductList(id: self.parentID, type: "", classType: "", seriesID: self.seriesID, pageNo: self.page.string, pageSize: self.pageSize.string)
//            .asObservable()
//            .subscribe(onNext: {[weak self] (list) in
//                guard let `self` = self else { return }
//                self.data.value.append(contentsOf: list.data?.rows ?? [])
//                self.reloadBlock?()
//            })
//            .disposed(by: disposeBag)
        RequestHelper.shared.getThirdLevelProductList(parentID: self.parentID, seriesID: self.seriesID, pageNo: self.page.string, pageSize: self.pageSize.string)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            self.data.value.append(contentsOf: list.data?.rows ?? [])
            self.reloadBlock?()
        })
        .disposed(by: disposeBag)
    }
}
