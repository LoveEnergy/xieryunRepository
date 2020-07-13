//
//  ClassifyMoreCourseListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/30.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ClassifyMoreCourseListViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    func loadData() {
        
    }
    
    var page: Int = 1
    
    var pageSize: Int = Constant.pageSize
    
    var title: String { return model.floorName }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    var model: HomeListSection
    
    typealias Cell = HomeCourseTableViewCell
    let disposeBag: DisposeBag = DisposeBag()
    var data: Variable<[HomeCourseTableViewCell.Model]> = Variable([])
    
    var cellType: HomeCourseTableViewCell.Type = HomeCourseTableViewCell.self
    
    var cellIdentifier: String { return R.nib.homeCourseTableViewCell.identifier }
    
    init(model: HomeListSection) {
        self.model = model
        super.init()
        self.data.value = model.courseList
    }
    
    func loadMore() {
        self.reloadBlock?()
    }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = model.productType
        CurrentControllerHelper.pushViewController(viewController: detailVC)
        
    }
}
