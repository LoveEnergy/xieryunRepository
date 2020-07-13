//
//  ClassTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class ClassTableViewCell: UITableViewCell, CellMappable {
    func configure(model: ClassModel) {
        thumbImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
//        endTimeLabel.text = model.
        endTimeLabel.text = model.closeTime;
        progressTitleLabel.text = "得分：\(model.schedule)/100"
    }
    
    typealias Model = ClassModel
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
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
