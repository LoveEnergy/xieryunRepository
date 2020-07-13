//
//  BaseClassifyView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol BaseClassifyViewDelegate: class {
    func clickMore()
    func clickIndexPath(indexPath: IndexPath)
}

class BaseClassifyView<T: BaseClassifyViewModel>: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    weak var delegate: BaseClassifyViewDelegate?
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 60, height: 60)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
    
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        return collectionView
    }()
    
    var topView: ClassifyTopView = {
        let view = ClassifyTopView()
        return view
    }()
    
    let disposeBag = DisposeBag()
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        self.delegate = viewModel
        super.init(frame: .zero)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        collectionView.register(UINib(nibName: viewModel.cellType.className, bundle: nil), forCellWithReuseIdentifier: viewModel.cellIdentifier)
        collectionView.delegate = self
        addSubview(topView)
        addSubview(collectionView)
        
        topView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(60)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-12)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(self).offset(-20)
        }
        
        viewModel.data.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: viewModel.cellIdentifier, cellType: viewModel.cellType)){ mum, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        collectionView.delegate = self
        
        topView.title = viewModel.title
        topView.moreButton.addTarget(self, action: #selector(moreButtonClick), for: .touchUpInside)
    }
    
    @objc func moreButtonClick() {
        self.delegate?.clickMore()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.clickIndexPath(indexPath: indexPath)
    }
}


protocol BaseClassifyViewModel: BaseClassifyViewDelegate {
    associatedtype Cell: UICollectionViewCell&CellMappable
    var data: Variable<[Cell.Model]> { get set }
    var cellType: Cell.Type { get set }
    var cellIdentifier: String { get set }
    var title: String { get }
    var cellSize: CGSize { get }
}
