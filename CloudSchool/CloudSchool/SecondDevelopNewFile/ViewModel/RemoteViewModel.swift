//
//  RemoteViewModel.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/30.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift

class RemoteViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = Constant.pageSize
    
    var title: String { return "远程课程" }
    
    var cellHeight: CGFloat {
        return 110
    }
    
    typealias Cell = TrainTableViewCell
    let disposeBag: DisposeBag = DisposeBag()
    var data: Variable<[TrainTableViewCell.Model]> = Variable([])
    
    var cellType: TrainTableViewCell.Type = TrainTableViewCell.self
    
    var cellIdentifier: String { return R.nib.trainTableViewCell.identifier }
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        self.page = 1
        RequestHelper.shared.remoteClassData(pageNo: 1, pageSize: 10)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            let cellArr = list.data!.rows
            self.data.value = cellArr as! [TrainModel]
            self.reloadBlock?()
        })
        .disposed(by: disposeBag)
    }
    
    func loadMore() {
        self.page += 1
        RequestHelper.shared.remoteClassData(pageNo: self.page, pageSize: self.pageSize)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            let cellArr = list.data!.rows
            self.data.value.append(contentsOf: list.data!.rows as! [TrainModel] ?? [])
            self.reloadBlock?()
        })
        .disposed(by: disposeBag)
    }
    
    func didClick(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = 3
        detailVC.objectType = model.objectType
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
}
