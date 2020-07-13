//
//  SpecialServiceTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/27.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SpecialServiceTableViewCell: UITableViewCell {
    var itemArray: [String]?{
        didSet{
            var lineNum: Int = 0
            if itemArray!.count%2 == 0 {
                lineNum = itemArray!.count/2
            }else{
                lineNum = itemArray!.count/2 + 1
            }            
            self.collectionView.frame = CGRect(x: 26/WIDTH_6_SCALE, y: self.titleLab.bottom + 16/WIDTH_6_SCALE, width: SCREEN_WIDTH - 52/WIDTH_6_SCALE, height: (25/WIDTH_6_SCALE) * CGFloat(lineNum))
            self.collectionView.reloadData()
        }
    }
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 17.5/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: 4/WIDTH_6_SCALE, height: 16.5/WIDTH_6_SCALE))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "5595eb")
        return lineView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: self.lineView.right + 5/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "特色服务"
        return titleLab
    }()
    
    lazy var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize(width: (SCREEN_WIDTH - 52/WIDTH_6_SCALE)/2 - 11/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        layout.minimumLineSpacing = 10/WIDTH_6_SCALE
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10/WIDTH_6_SCALE
        var collectionView = UICollectionView.init(frame: CGRect(x: 26/WIDTH_6_SCALE, y: self.titleLab.bottom + 16/WIDTH_6_SCALE, width: SCREEN_WIDTH - 52/WIDTH_6_SCALE, height: 50/WIDTH_6_SCALE), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(SpecialServiceTableViewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(SpecialServiceTableViewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.collectionView)
        self.lineView.centerY = self.titleLab.centerY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SpecialServiceTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(SpecialServiceTableViewCellCollectionViewCell.self), for: indexPath) as! SpecialServiceTableViewCellCollectionViewCell
        cell.titleLab.text = self.itemArray?[indexPath.row] ?? ""
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArray?.count ?? 0
    }
}
