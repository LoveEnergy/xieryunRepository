//
//  GoodsInfoTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

protocol GoodsInfoTableViewCellDelegate: class {
    func didClickReward()
}

class GoodsInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var seriesLabel: UILabel!
    @IBOutlet weak var buyNumberButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    
    weak var delegate: GoodsInfoTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleButton.cornerRadius = 2
        self.titleButton.borderColor = UIColor.mainRedColor
        self.titleButton.borderWidth = 1
        self.titleButton.setTitleColor(UIColor.mainRedColor, for: .normal)
        self.rewardButton.setTitleColor(UIColor.titleColor, for: .normal)
        
        self.rewardButton.addTarget(self, action: #selector(rewardButtonClick), for: .touchUpInside)
    }
    
    @objc func rewardButtonClick() {
        self.delegate?.didClickReward()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: ProductDetailModel) {
        if model.basicPrice <= 0 {
            priceLabel.text = "免费"
        } else {
            priceLabel.text = "¥ \(model.basicPrice.toString())"
        }
        nameLabel.text = model.productName
        teacherLabel.text = "教师：\(model.teacherName)"
        seriesLabel.text = "体系：\(model.seriesName)"
        buyNumberButton.setTitle("\(model.buyCount.toString())人购买", for: .normal)
        likeButton.setTitle("\(model.likeCount.toString())人喜欢", for: .normal)
        
        if let shareModel = model.activityMap, let _ = shareModel.activityCategoryName.emptyToNil() {
            self.titleButton.setTitle(shareModel.activityCategoryName, for: .normal)
            self.rewardButton.setTitle(shareModel.activityAbbreviation, for: .normal)
            self.timeLabel.text = "截止时间：\(shareModel.activityEndDate)"
            shareView.isHidden = false
        } else {
            shareView.isHidden = true
        }
    }
    
}
