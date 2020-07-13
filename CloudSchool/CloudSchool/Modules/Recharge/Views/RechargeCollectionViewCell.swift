//
//  RechargeCollectionViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/5/12.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class RechargeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var studyPointLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var beSelected: Bool = false {
        didSet {
            if beSelected {
                contentView.borderColor = UIColor.mainBlueColor
                contentView.borderWidth = 1
                contentView.cornerRadius = 4
            } else {
                contentView.borderWidth = 0
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: RegisteredPurchase) {
        priceLabel.text = "¥ \(model.price)"
        studyPointLabel.text = "\(model.price) 学点"
    }
    
    

}
