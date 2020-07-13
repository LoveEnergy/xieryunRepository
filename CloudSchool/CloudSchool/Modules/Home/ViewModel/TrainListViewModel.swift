//
//  TrainListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/24.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift

class TrainListViewModel: NSObject, BaseListViewModel {
    var reloadBlock: (() -> Void)?
    
    var page: Int = 1
    
    var pageSize: Int = Constant.pageSize
    
    var title: String { return "面授培训班" }
    
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
        RequestHelper.shared.getTrainList(pageNo: self.page.string, pageSize: self.pageSize.string)
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
        RequestHelper.shared.getTrainList(pageNo: self.page.string, pageSize: self.pageSize.string)
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
        detailVC.productType = 3
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
}
