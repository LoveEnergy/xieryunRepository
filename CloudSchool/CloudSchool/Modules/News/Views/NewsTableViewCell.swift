//
//  NewsTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var numberButton: UIButton!

    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.setSelected(false, animated: true)
        }
    }
    
    func configure(model: PageModel) {
        self.titleLabel.text = model.pageName
        self.thumbImageView.loadImage(string: model.thumbnailUrl)
        self.dateLabel.text = model.updateTime
    }
    
}
