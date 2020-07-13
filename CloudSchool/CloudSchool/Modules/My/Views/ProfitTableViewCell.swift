//
//  ProfitTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class ProfitTableViewCell: UITableViewCell {

    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: MonthProfitModel) {
        dateLabel.text = model.month
        moneyLabel.text = model.money
    }
    
}
