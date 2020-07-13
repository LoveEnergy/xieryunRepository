//
//  ShareActivityTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2019/4/8.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class ShareActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var rewardButton: UIButton!
    @IBOutlet weak var titleButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
        // Initialization code
    }
    
    func baseConfigure() {
        self.titleButton.cornerRadius = 2
        self.titleButton.borderColor = UIColor.mainRedColor
        self.titleButton.borderWidth = 1
        self.titleButton.setTitleColor(UIColor.mainRedColor, for: .normal)
        self.rewardButton.setTitleColor(UIColor.titleColor, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: ShareActivityModel) {
        self.titleButton.setTitle(model.activityCategoryName, for: .normal)
        self.rewardButton.setTitle(model.activityAbbreviation, for: .normal)
        self.timeLabel.text = "截止时间：\(model.activityEndDate)"
    }
    
}
