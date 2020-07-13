//
//  TrainListClassifyViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

class TrainListClassifyViewModel: NSObject, BaseClassifyViewModel {
    public var showLoadBlock:(()->())?
    public var hideLoadBlock:(()->())?
    
    func clickIndexPath(indexPath: IndexPath) {
        let model = data.value[indexPath.row]
        let detailVC = R.storyboard.home.courseDetailViewController()!
        detailVC.productID = model.productID.toString()
        detailVC.productType = 3
        CurrentControllerHelper.pushViewController(viewController: detailVC)
    }
    
    func clickMore() {
        let vc = BaseListViewController<TrainListViewModel>.init(viewModel: TrainListViewModel())
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    var cellSize: CGSize { return CGSize(width: 124, height: 90) }
    var title: String { return "面授培训班" }
    
    typealias Cell = TrainCollectionViewCell
    
    var data: Variable<[TrainModel]> = Variable([])
    
    var cellType: TrainCollectionViewCell.Type = TrainCollectionViewCell.self
    
    var cellIdentifier: String = R.nib.trainCollectionViewCell.identifier
    
    let disposeBag: DisposeBag = DisposeBag()
    
    override init() {
        super.init()
        loadData()
    }
    
    func loadData() {
        self.showLoadBlock?()
        RequestHelper.shared.getTrainList(pageNo: "1", pageSize: "20")
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                self?.hideLoadBlock?()
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
            })
        .disposed(by: disposeBag)
    }
    
}
