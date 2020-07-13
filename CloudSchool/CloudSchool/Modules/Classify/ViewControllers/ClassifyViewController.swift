//
//  ClassifyViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ClassifyViewController: UIViewController {
    var classifyViewModel: ClassifyViewModel = ClassifyViewModel()
    let disposeBag: DisposeBag = DisposeBag()

    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var subClassifyCollectionView: UICollectionView!
    @IBOutlet weak var classifyTitleLabel: UILabel!
    @IBOutlet weak var classifyTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        classifyViewModel.data.asObservable()
            .bind(to: classifyTableView.rx.items(cellIdentifier: R.nib.classifyTableViewCell.identifier, cellType: ClassifyTableViewCell.self)){ _, model, cell in
                cell.nameLabel.text = model.seriesName
            }.disposed(by: disposeBag)
        
        classifyViewModel.subData.asObservable()
            .bind(to: subClassifyCollectionView.rx.items(cellIdentifier: R.nib.subClassifyCollectionViewCell.identifier, cellType: SubClassifyCollectionViewCell.self)){ _, model, cell in
                cell.nameLabel.text = model.seriesName
            }.disposed(by: disposeBag)
    classifyTableView.rx.modelSelected(HomeNavigationModel.self).subscribe(onNext: {[weak self] (type) in
            guard let `self` = self else { return }
        self.classifyTitleLabel.text = type.seriesName
        self.classifyViewModel.choose(model: type)

        }).disposed(by: disposeBag)
        
        subClassifyCollectionView.rx.modelSelected(SubSeriesModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                let vc = R.storyboard.home.courseProductListViewController()!
                vc.title = model.seriesName
                vc.seriesID = model.seriesID.toString()
                vc.parentID = self.classifyViewModel.currentNavModel?.seriesID.toString() ?? ""
                CurrentControllerHelper.pushViewController(viewController: vc)
            })
        .disposed(by: disposeBag)
        
        selectIndex(index: self.classifyViewModel.currentIndex)
        
    }
    
    @objc func showAll() {
        let vc = R.storyboard.home.courseProductListViewController()!
        vc.title = "全部"
        vc.seriesID = ""
        vc.parentID = ""
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func configureUI() {
        title = "分类"
        classifyTableView.register(R.nib.classifyTableViewCell)
        classifyTableView.tableFooterView = UIView()
        classifyTableView.backgroundColor = UIColor.backgroundColor
        
        subClassifyCollectionView.register(R.nib.subClassifyCollectionViewCell)
        subClassifyCollectionView.delegate = self
        subClassifyCollectionView.backgroundColor = UIColor.backgroundColor
        
        scrollView.backgroundColor = UIColor.backgroundColor
        classifyViewModel.selectFirstSignal
            .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                
            })
            .disposed(by: disposeBag)
        
        subClassifyCollectionView.addRefreshHeader {
            self.classifyViewModel.loadData()
        }
        
        self.classifyViewModel.data
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.subClassifyCollectionView.endRefresh()
                self.perform(#selector(self.selectIndex(index:)), with: self.classifyViewModel.currentIndex, afterDelay: 0.2)
            })
        .disposed(by: disposeBag)
        
        allButton.addTarget(self, action: #selector(showAll), for: .touchUpInside)
    }
    
    @objc func selectIndex(index: Int) {
        let index = self.classifyViewModel.currentIndex
        if let _ = self.classifyTableView.cellForRow(at: IndexPath(item: index, section: 0)) {
            self.classifyTableView.selectRow(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: UITableView.ScrollPosition.none)
            self.classifyTitleLabel.text = self.classifyViewModel.currentNavModel?.seriesName
        }
    }
}

extension ClassifyViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.width - 30)/2, height: 50)
    }
}
