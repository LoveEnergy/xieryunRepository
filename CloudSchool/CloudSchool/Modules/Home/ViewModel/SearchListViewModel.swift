//
//  SearchListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2019/3/19.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchListViewModel: NSObject, BaseListViewModel {
    var page: Int = 1
    var title: String { return self.name }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    typealias Cell = HomeCourseTableViewCell
    let disposeBag: DisposeBag = DisposeBag()
    var data: Variable<[HomeCourseTableViewCell.Model]> = Variable([])
    
    var cellType: HomeCourseTableViewCell.Type = HomeCourseTableViewCell.self
    
    var cellIdentifier: String { return R.nib.homeCourseTableViewCell.identifier }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = model.productType
        CurrentControllerHelper.pushViewController(viewController: detailVC)
        
    }
    var name: String
    var pageNo: Int = 0
    var pageSize: Int = 20
    
    var reloadBlock:(()-> Void)?
    
    init(name: String) {
        self.name = name
        super.init()
        self.loadData()
    }
    
    func loadData() {
        self.page = 1
        RequestHelper.shared.search(name: self.name, pageNo: self.page, pageSize: self.pageSize)
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
                self.reloadBlock?()
            }, onError: { (error) in
                self.reloadBlock?()
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func loadMore() {
        self.page += 1
        RequestHelper.shared.search(name: self.name, pageNo: self.page, pageSize: self.pageSize)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value.append(contentsOf: list.data?.rows ?? [])
                self.reloadBlock?()
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
                    self.reloadBlock?()
            })
            .disposed(by: disposeBag)
    }
}
