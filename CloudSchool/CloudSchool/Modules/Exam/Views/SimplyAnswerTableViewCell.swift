//
//  SimplyAnswerTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/12.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SimplyAnswerTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var contentTextView: IWTextView!
    public var contentTextBlock:((String)->())?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentTextView.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 20/WIDTH_6_SCALE, height: 170/WIDTH_6_SCALE)
        self.contentTextView.layer.cornerRadius = 4
        self.contentTextView.layer.masksToBounds = true
        self.contentTextView.layer.borderWidth = 0.8
        self.contentTextView.layer.borderColor = UIColor.colorWithHex(hex: "DDDDDD").cgColor
        self.contentTextView.placeholder = "请做简答:"
        self.contentTextView.font = DEF_FontSize_14
        self.contentTextView.placeholderColor = UIColor.colorWithHex(hex: "cacaca")
        self.contentTextView.textColor = .black
        self.contentTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.contentTextBlock?(textView.text!)
    }
    
}
