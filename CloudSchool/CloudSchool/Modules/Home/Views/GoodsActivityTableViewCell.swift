//
//  GoodsActivityTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class GoodsActivityTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityTypeButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        activityTypeButton.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        activityTypeButton.pcornerRadius = 5
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: ActivityModel) {
        if let type = ActivityType(rawValue: model.ruleType), let mode = ActivityMode(rawValue: model.mode) {
            activityTypeButton.setTitle(type.description, for: .normal)
            let string = model.ruleList.map { (item) -> String in
                return type.getString(rule: item) + mode.getString(rule: item)
            }.joined(separator: ",")
            descriptionLabel.text = string
        }
    }
}

enum ActivityType: Int, CustomStringConvertible {
    
    case count = 1
    case price = 2
    
    var description: String {
        switch self {
        case .count:
            return "满减"
        case .price:
            return "满减"
        }
    }
    
    func getString(rule: RuleModel) -> String {
        switch self {
        case .count:
            return "满\(rule.count)件"
        case .price:
            return "满\(rule.totalPrice)元"
        }
    }
}

enum ActivityMode: Int, CustomStringConvertible {
    
    
    case discount = 1
    case minus = 2
    case backCoupon = 3
    
    var description: String {
        switch self {
        case .discount:
            return "折"
        case .backCoupon:
            return "返"
        case .minus:
            return "减"
        }
    }
    
    func getString(rule: RuleModel) -> String {
        switch self {
        case .discount:
            return "\(rule.discountRate)\(self.description)"
        case .minus:
            return "\(self.description)\(rule.price)元"
        case .backCoupon:
            return "\(rule.discountRate)\(self.description)"
        }
    }
    
}
