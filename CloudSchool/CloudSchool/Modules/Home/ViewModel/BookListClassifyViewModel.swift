//
//  BookListViewModel.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/15.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class BookListClassifyViewModel: NSObject, BaseClassifyViewModel {
    public var showLoadBlock:(()->())?
    public var hideLoadBlock:(()->())?
    func clickIndexPath(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = 2
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
    
    func clickMore() {
        let vc = BaseListViewController<BookListViewModel>.init(viewModel: BookListViewModel())
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    var cellSize: CGSize { return CGSize(width: 100, height: 180) }
    
    var title: String { return "环保教材" }
    
    typealias Cell = BookCollectionViewCell
    
    var data: Variable<[BookModel]> = Variable([])
    
    var cellType: BookCollectionViewCell.Type = BookCollectionViewCell.self
    
    var cellIdentifier: String = R.nib.bookCollectionViewCell.identifier
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        self.showLoadBlock?()
        RequestHelper.shared.getBookList(pageNo: "0", pageSize: "10")
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                self?.hideLoadBlock?()
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
            })
            .disposed(by: disposeBag)
    }

}
