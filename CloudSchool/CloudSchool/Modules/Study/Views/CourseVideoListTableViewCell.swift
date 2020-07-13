//
//  CourseVideoListTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/24.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class CourseVideoListTableViewCell: UITableViewCell {

    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var teacherLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
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
    
    func configure(model: CourseWareModel) {
        coverImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.coursewareName
        teacherLabel.text = model.teacherName
        timeLabel.text = model.duration
    }
    
}
