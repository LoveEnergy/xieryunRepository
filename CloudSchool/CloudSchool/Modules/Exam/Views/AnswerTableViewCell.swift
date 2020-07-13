//
//  AnswerTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class AnswerTableViewCell: UITableViewCell {

    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var chooseButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(model: AnswerModel) {
        answerLabel.text = model.optionContent
    }
    
}
