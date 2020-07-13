//
//  JobFeedbackTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class JobFeedbackTableViewCell: UITableViewCell {
    
    var cityLabel: UILabel?
    var educationLabl: UILabel?
    var experienceLabel: UILabel?
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "平面设计"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    
    lazy var companyLab : UILabel = {
        var companyLab = UILabel.init()
        companyLab.font = DEF_FontSize_12
        companyLab.backgroundColor = .clear
        companyLab.textColor = .black
        companyLab.textAlignment = .left
        companyLab.text = "环保技有限公司"
        return companyLab
    }()
    
    lazy var salaryLab : UILabel = {
        var salaryLab = UILabel.init()
        salaryLab.font = DEF_FontSize_16
        salaryLab.backgroundColor = .clear
        salaryLab.textColor = UIColor.colorWithHex(hex: "0378fd")
        salaryLab.textAlignment = .right
        salaryLab.text = "4-6k"
        return salaryLab
    }()
    
    lazy var statusLab : UILabel = {
        var statusLab = UILabel.init()
        statusLab.font = DEF_FontSize_14
        statusLab.backgroundColor = .clear
        statusLab.textColor = UIColor.colorWithHex(hex: "0378fd")
        statusLab.textAlignment = .right
        statusLab.text = "已查看"
        return statusLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.salaryLab)
        self.contentView.addSubview(self.companyLab)
        self.contentView.addSubview(self.statusLab)
        self.contentView.addSubview(self.lineView)
        self.titleLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 13.5/WIDTH_6_SCALE, width: SCREEN_WIDTH/2, height: 24/WIDTH_6_SCALE)
        
        let labelW = 50/WIDTH_6_SCALE
        for num in 0...2 {
            let label = UILabel.init(frame: CGRect(x: 16/WIDTH_6_SCALE + labelW * CGFloat(num), y: 5.5/WIDTH_6_SCALE + self.titleLab.bottom, width: 50/WIDTH_6_SCALE, height: 14/WIDTH_6_SCALE))
            label.text = "北京"
            label.tag = 2000 + num
            label.font = DEF_FontSize_11
            label.textColor = UIColor.colorWithHex(hex: "999999")
            self.contentView.addSubview(label)
        }
        self.cityLabel = contentView.viewWithTag(2000) as! UILabel
        self.educationLabl = contentView.viewWithTag(2001) as! UILabel
        self.experienceLabel = contentView.viewWithTag(2002) as! UILabel
        self.cityLabel?.textAlignment = .left
        self.educationLabl?.textAlignment = .center
        self.experienceLabel?.textAlignment = .right
        
        let cityLineView = UIView.init(frame: CGRect(x: self.cityLabel!.right, y: self.cityLabel!.top, width: 1, height: self.cityLabel!.height))
        cityLineView.backgroundColor = UIColor.colorWithHex(hex: "999999")
        self.contentView.addSubview(cityLineView)
        
        let educationLineView = UIView.init(frame: CGRect(x: self.educationLabl!.right, y: self.cityLabel!.top, width: 1, height: self.cityLabel!.height))
        educationLineView.backgroundColor = UIColor.colorWithHex(hex: "999999")
        self.contentView.addSubview(educationLineView)

        self.companyLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 35.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - self.titleLab.left - 100/WIDTH_6_SCALE, height: 14/WIDTH_6_SCALE)
        
        self.salaryLab.frame = CGRect(x: SCREEN_WIDTH - 100/WIDTH_6_SCALE - 16/WIDTH_6_SCALE, y: 0, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        
        self.statusLab.frame = CGRect(x: self.salaryLab.left + 20/WIDTH_6_SCALE, y: 0, width: self.salaryLab.width - 20/WIDTH_6_SCALE, height: self.salaryLab.height)
        
        self.salaryLab.centerY = self.titleLab.centerY
        self.statusLab.centerY = self.companyLab.centerY
        
        self.lineView.frame = CGRect(x: 0, y: self.companyLab.bottom + 9.5/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
