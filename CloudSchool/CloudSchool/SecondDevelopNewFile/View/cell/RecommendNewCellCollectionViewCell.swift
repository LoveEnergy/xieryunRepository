//
//  RecommendNewCellCollectionViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class RecommendNewCellCollectionViewCell: UICollectionViewCell {
    var model: RecommonModel? {
        didSet{
            guard let model = model else { return }
            self.titleLab.text = model.productName
            self.imgView.loadImage(string: model.thumbnailUrl)
            self.productID = model.productID
            self.productType = model.productType
        }
    }
    var productID: Int = 0
    var productType: Int = 0
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: self.imgView.bottom + 10/WIDTH_6_SCALE, width: self.imgView.width, height: self.contentView.height - self.imgView.height - 10/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "推荐名称"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 2
        titleLab.sizeToFit()
        return titleLab
    }()
    lazy var imgView : UIImageView = {
        var imgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.contentView.width, height: 80/WIDTH_6_SCALE))
        imgView.backgroundColor = UIColor.lightGray
        return imgView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.titleLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
