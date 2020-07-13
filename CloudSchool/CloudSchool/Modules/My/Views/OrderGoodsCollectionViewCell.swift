//
//  OrderGoodsCollectionViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/27.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class OrderGoodsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(model: OrderGoodsModel) {
        thumbImageView.loadImage(string: model.previewImgUrl)
    }

}
