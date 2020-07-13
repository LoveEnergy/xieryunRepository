//
//  RecommendNewTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class RecommendNewTableViewCell: UITableViewCell {
    public var recommendToProductDetailBlock:((Int, Int)->())?
    var model: [RecommonModel]? {
        didSet{
            guard let model = model else { return }
            self.collectionView.reloadData()
        }
    }
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 17.5/WIDTH_6_SCALE, y: 0, width: 4/WIDTH_6_SCALE, height: 16.5/WIDTH_6_SCALE))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "5595eb")
        return lineView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: self.lineView.right + 5/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "西尔推荐"
        return titleLab
    }()
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: 158/WIDTH_6_SCALE, height: 120/WIDTH_6_SCALE)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10/WIDTH_6_SCALE//左右
        var collectionView = UICollectionView.init(frame: CGRect(x: 0, y: self.titleLab.bottom + 6.5/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 120/WIDTH_6_SCALE), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10/WIDTH_6_SCALE, bottom: 0, right: 10/WIDTH_6_SCALE)
        collectionView.register(RecommendNewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(RecommendNewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.collectionView)
        self.lineView.centerY = self.titleLab.centerY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension RecommendNewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(RecommendNewCellCollectionViewCell.self), for: indexPath) as! RecommendNewCellCollectionViewCell
        item.model = self.model![indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("商品类型：\(self.model![indexPath.row].productType), 商品ID：\(self.model![indexPath.row].productID)")
        self.recommendToProductDetailBlock?(self.model![indexPath.row].productType, self.model![indexPath.row].productID)
    }
}
