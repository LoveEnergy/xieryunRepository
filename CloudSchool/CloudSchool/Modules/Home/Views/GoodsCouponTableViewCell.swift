//
//  GoodsCouponTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/15.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class GoodsCouponTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var titleArray: [NewCouponList] = [NewCouponList]()
    public var goodsCouponBlock : (() -> ())?
    @IBOutlet weak var titleLab: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.addSubview(self.collectionView)
    }
    lazy var collectionView: UICollectionView = {
        var flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal//横向
        var collectionView = UICollectionView.init(frame: CGRect(x: 46, y: 0, width: SCREEN_WIDTH - 46, height: 50), collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(GoodsCouponTableViewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(GoodsCouponTableViewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
//    func configure(coupons: [String]) {
//        self.titleArray = coupons
//        self.collectionView.reloadData()
//    }
    func configure(coupons: [NewCouponList]) {
        self.titleArray = coupons
        self.collectionView.reloadData()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(GoodsCouponTableViewCellCollectionViewCell.self), for: indexPath) as! GoodsCouponTableViewCellCollectionViewCell
        cell.model = self.titleArray[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titleArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.goodsCouponBlock?()
    }
}
