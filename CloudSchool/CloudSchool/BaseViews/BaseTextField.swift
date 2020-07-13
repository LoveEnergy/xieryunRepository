//
//  BaseTextField.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import QMUIKit

class BaseTextField: QMUITextField {

    override func awakeFromNib() {
        super.awakeFromNib()
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: 11, height: 10)
        self.leftView = leftView
        self.leftViewMode = .always
        self.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        backgroundColor = UIColor.textfieldBackgroundColor
    }

}
