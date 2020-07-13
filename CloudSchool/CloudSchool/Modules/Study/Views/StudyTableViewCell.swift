//
//  StudyTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class StudyTableViewCell: UITableViewCell, CellMappable {
    
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var restTimeLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    
    func configure(model: StudyModel) {
        thumbImageView.loadImage(string: model.previewImgUrl)
        nameLabel.text = model.productName
        let progressValue = max(0, min((model.schedule.float() ?? 0.0)/100.0, 1))
        progressView.progress = progressValue
        progressLabel.text = String(format: "%.1f%%", progressValue * 100.0)
        endTimeLabel.text = "结课时间:\(model.validTime)"
    }
    
    func configure(model: ClassCourseModel) {
        thumbImageView.loadImage(string: model.previewImgUrl)
        nameLabel.text = model.courseName
        endTimeLabel.text = "结课时间：\(model.closeTime)"
        progressView.progress = (model.schedule.float() ?? 0.0)/100.0
        progressLabel.text = String(format: "%@ %%", model.schedule)
        
        
    }
    
    typealias Model = StudyModel
    
    

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
