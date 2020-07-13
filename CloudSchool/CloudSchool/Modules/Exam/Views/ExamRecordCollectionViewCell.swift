//
//  ExamRecordCollectionViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/8.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit

class ExamRecordCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var scoreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(model: ExamResultInfoModel) {
        self.scoreLabel.text = model.score.string
    }

}
