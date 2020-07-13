//
//  BaseInputView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/7.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

enum BaseInputViewType {
    case white
    case gray
    
    var backgroundColor: UIColor {
        switch self {
        case .white:
            return UIColor.white
        case .gray:
            return UIColor.gray
        }
    }
    
    
}

class BaseInputView: UIView {
    
    var type: BaseInputViewType = .white {
        didSet {
            switch type {
            case .white:
                self.backgroundColor = UIColor.white
            case .gray:
                self.backgroundColor = UIColor.backgroundColor
            }
        }
    }
    
    var placeHolder: String = "" {
        didSet {
            textField.placeholder = placeHolder
        }
    }
    
    let textField: BaseTextField = {
        let textfield = BaseTextField()
        textfield.font = UIFont.systemFont(ofSize: 15)
        return textfield
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        self.backgroundColor = UIColor.white
        pcornerRadius = 5.0
        addSubview(textField)
        
        textField.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.height.equalTo(self)
            make.leading.equalTo(self).offset(20)
        }
    }
    

}
