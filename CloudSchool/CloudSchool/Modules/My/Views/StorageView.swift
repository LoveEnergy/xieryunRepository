//
//  StorageView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/28.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class StorageView: UIView {

    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.lineColor
        return view
    }()

    let freeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.deepTitleColor
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.deepTitleColor
        label.font = UIFont.systemFont(ofSize: 11)
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        backgroundColor = UIColor.gray
        addSubview(freeLabel)
        addSubview(totalLabel)
        addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.centerX.centerY.equalTo(self)
            make.width.equalTo(2)
            make.height.equalTo(10)
        }
        
        freeLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(lineView.snp.left)
        }
        
        totalLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(lineView.snp.right)
        }
        
        let freeSize = UIDevice.current.getFreeSize()
        let standardFreeSize = String(format: "%.2f", freeSize/1024.0)
        freeLabel.text = "可用： \(standardFreeSize) G"
        
        let totalSize = UIDevice.current.getTotalSize()
        let standardTotalSize = String(format: "%.2f", totalSize/1024.0)
        totalLabel.text = "总共： \(standardTotalSize) G"
    }
}
