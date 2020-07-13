//
//  BookListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/2.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class BookListViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = Constant.pageSize
    
    var title: String { return "环保教材" }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    typealias Cell = BookTableViewCell
    let disposeBag: DisposeBag = DisposeBag()
    var data: Variable<[BookTableViewCell.Model]> = Variable([])
    
    var cellType: BookTableViewCell.Type = BookTableViewCell.self
    
    var cellIdentifier: String { return R.nib.bookTableViewCell.identifier }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        self.page = 1
        RequestHelper.shared.getBookList(pageNo: self.page.string, pageSize: self.pageSize.string)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
                self.reloadBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    func loadMore() {
        page += 1
        RequestHelper.shared.getBookList(pageNo: self.page.string, pageSize: self.pageSize.string)
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data.value.append(contentsOf: list.data?.rows ?? [])
                self.reloadBlock?()
            })
            .disposed(by: disposeBag)
    }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = 2
        CurrentControllerHelper.pushViewController(viewController: detailVC)
        
    }
    
    
}
