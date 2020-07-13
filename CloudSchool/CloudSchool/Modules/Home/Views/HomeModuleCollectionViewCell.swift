//
//  HomeModuleCollectionViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class HomeModuleCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(type: HomeFunctionType) {
        iconImageView.image = type.image
        titleLabel.text = type.title
    }
    
    func configure(model: HomeNavigationModel) {
//        iconImageView.image = type
//        titleLabel.text = model.navigationName
        titleLabel.text = model.seriesName
    }

}
