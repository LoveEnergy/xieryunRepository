//
//  BaseSegmentView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/31.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class BaseSegmentView: UIView {
    
    var sectionTitles: [String] = [] {
        didSet {
            
        }
    }
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        return stack
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        pcornerRadius = 3.0
        pborderColor = UIColor.lineColor
        pborderWidth = 1.0
        
        addSubview(stackView)
        
        stackView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        
    }

}
