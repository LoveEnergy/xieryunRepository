//
//  CourseClassifyCollectionViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseClassifyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setSelected(_ selected: Bool) {
        if selected {
            self.nameLabel.textColor = UIColor.titleColor
            self.nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        } else {
            self.nameLabel.textColor = UIColor.colorWithHex(hex: "#666666")
            self.nameLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    
    
}
