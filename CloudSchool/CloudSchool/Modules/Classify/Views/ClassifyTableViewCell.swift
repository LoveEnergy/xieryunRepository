//
//  ClassifyTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class ClassifyTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let view = UIView()
        view.backgroundColor = UIColor.backgroundColor
        selectedBackgroundView = view
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.backgroundColor = UIColor.backgroundColor
            self.nameLabel.textColor = UIColor.titleColor
            self.nameLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        } else {
            self.backgroundColor = UIColor.white
            self.nameLabel.textColor = UIColor.subTitleColor
            self.nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
        // Configure the view for the selected state
    }
    
}
