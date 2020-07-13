//
//  FinishedDownloadTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/29.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class FinishedDownloadTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
}
