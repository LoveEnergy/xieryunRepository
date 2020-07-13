//
//  MyTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var numberView: RedNumberView!
    
    @IBOutlet weak var bottomLineView: UIView!
    @IBOutlet weak var shortBottomLineView: UIView!
    @IBOutlet weak var topLineView: UIView!
    var disposeBag = DisposeBag()
    
    var number: Binder<Int> {
        return Binder(self) { view, value in
            self.numberView.isHidden = value == 0
            self.numberView.number = value
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bottomLineView.backgroundColor = UIColor.colorWithHex(hex: "dedfe1")
        self.shortBottomLineView.backgroundColor = UIColor.colorWithHex(hex: "dedfe1")
        self.topLineView.backgroundColor = UIColor.colorWithHex(hex: "dedfe1")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
}
