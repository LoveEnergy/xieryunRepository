//
//  RemoteClassView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/26.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RemoteClassView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var model: [RemoteClassDetailModel] = [RemoteClassDetailModel]()
    public var moreRemoteClassBlock:(()->())?//点击查看更多远程课程
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.collectionView)
        self.bgView.addSubview(self.moreButton)
        
        
        moreButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.titleLab)
            make.right.equalTo(self).offset(-15)
        }
        
    }
    lazy var bgView: UIView = {
        weak var weakSelf = self
        var bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: weakSelf!.height))
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 12, y: 0, width: 100, height: 60))
        titleLab.font = DEF_FontSize_17
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "远程班级"
        return titleLab
    }()
    
    var moreButton: LayoutableButton = {
        let button = LayoutableButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11, weight: .light)
        button.setTitleColor(UIColor.subTitleColor, for: .normal)
        button.setTitle("更多", for: .normal)
        button.setImage(R.image.more_arrow(), for: .normal)
        button._layoutType = "right"
        button.addTarget(self, action: #selector(buttonClick(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var collectionView : UICollectionView = {
        weak var weakSelf = self
        var layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 124, height: 90)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        var collectionView = UICollectionView.init(frame: CGRect(x: 12, y: (weakSelf?.titleLab.bottom)!, width: SCREEN_WIDTH - 24, height: 170 - (weakSelf?.titleLab.height)! - 20), collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(RemoteClassViewCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(RemoteClassViewCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(RemoteClassViewCollectionViewCell.self), for: indexPath) as! RemoteClassViewCollectionViewCell
        item.model = self.model[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.model[indexPath.row]
        let vc = R.storyboard.home.courseDetailViewController()!
        vc.productID = model.productID.toString()
        vc.productType = 3
        vc.objectType = model.objectType
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func buttonClick(btn: UIButton){
        self.moreRemoteClassBlock?()
//        let vc = RemoteListClassViewController.init()
//        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
