//
//  RecommendTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/28.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RecommendTableViewCell: UITableViewCell {

    @IBOutlet weak var courseCollectionView: UICollectionView!
    @IBOutlet weak var bookCollectionView: UICollectionView!
    
    let disposeBag = DisposeBag()
    
    var data: Variable<[RecommonModel]> = Variable([])
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
        // Initialization code
    }
    
    func baseConfigure() {
        bookCollectionView.register(R.nib.bookCollectionViewCell)
        bookCollectionView.delegate = self
        
        data.asObservable()
            .bind(to: bookCollectionView.rx.items(cellIdentifier: R.nib.bookCollectionViewCell.identifier, cellType: BookCollectionViewCell.self)){ _, model, cell in
                cell.configure(recommendModel: model)
            }.disposed(by: disposeBag)
        
        bookCollectionView.rx.modelSelected(RecommonModel.self).subscribe(onNext: {[weak self] (type) in
            let vc = R.storyboard.home.courseDetailViewController()!
            vc.productID = type.productID.toString()
            vc.productType = type.productType
            CurrentControllerHelper.pushViewController(viewController: vc)
        }).disposed(by: disposeBag)
        loadData()
    }
    
    func loadData() {
        RequestHelper.shared.getRecommendList(viewPageID: 1, pageNo: 1, pageSize: 10)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.data.value = model.data?.rows ?? []
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }
    
}

extension RecommendTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: bookCollectionView.height)
    }
}
