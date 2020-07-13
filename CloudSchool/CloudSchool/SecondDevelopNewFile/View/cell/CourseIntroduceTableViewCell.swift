//
//  CourseIntroduceTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/27.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class CourseIntroduceTableViewCell: UITableViewCell {
    var model: ProductDetailModel? {
            didSet{
                guard let model = model else { return }
//                let splitedArray = model.characteristicList.characters.split{$0 == ","}.map(String.init)
//                self.itemArray = splitedArray
                if model.certificateAuthority.isEmpty {
                    self.certificateContentLab.text = "无"
                }else{
                    self.certificateContentLab.text = model.certificateAuthority
                }
                self.certificateBelongContentLab.text = model.openingName
                self.classNumContentLab.text = "\(model.courseCount)"
                self.teacherContentLab.text = model.teachersName
                self.deadlineContentLab.text = model.closeTime
            }
        }
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 17.5/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: 4/WIDTH_6_SCALE, height: 16.5/WIDTH_6_SCALE))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "5595eb")
        return lineView
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: self.lineView.right + 5/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_15
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "课程介绍"
        return titleLab
    }()
    
    lazy var teacherTitleLab : UILabel = {
        var systemLab = UILabel.init()
        systemLab.font = DEF_FontSize_14
        systemLab.backgroundColor = .clear
        systemLab.textColor = .black
        systemLab.textAlignment = .left
        systemLab.text = "主讲老师:"
        return systemLab
    }()
    lazy var teacherContentLab : UILabel = {
        var teacherContentLab = UILabel.init()
        teacherContentLab.font = DEF_FontSize_14
        teacherContentLab.backgroundColor = .clear
        teacherContentLab.textColor = .black
        teacherContentLab.textAlignment = .left
        teacherContentLab.text = "毛应准"
        return teacherContentLab
    }()
    lazy var classNumTitleLab : UILabel = {
        var classNumTitleLab = UILabel.init()
        classNumTitleLab.font = DEF_FontSize_14
        classNumTitleLab.backgroundColor = .clear
        classNumTitleLab.textColor = .black
        classNumTitleLab.textAlignment = .left
        classNumTitleLab.text = "课程时长:"
        return classNumTitleLab
    }()
    lazy var classNumContentLab : UILabel = {
        var classNumContentLab = UILabel.init()
        classNumContentLab.font = DEF_FontSize_14
        classNumContentLab.backgroundColor = .clear
        classNumContentLab.textColor = .black
        classNumContentLab.textAlignment = .left
        classNumContentLab.text = "20"
        return classNumContentLab
    }()
    lazy var deadlineTitleLab : UILabel = {
        var deadlineTitleLab = UILabel.init()
        deadlineTitleLab.font = DEF_FontSize_14
        deadlineTitleLab.backgroundColor = .clear
        deadlineTitleLab.textColor = .black
        deadlineTitleLab.textAlignment = .left
        deadlineTitleLab.text = "截止日期:"
        return deadlineTitleLab
    }()
    lazy var deadlineContentLab : UILabel = {
        var deadlineContentLab = UILabel.init()
        deadlineContentLab.font = DEF_FontSize_14
        deadlineContentLab.backgroundColor = .clear
        deadlineContentLab.textColor = .black
        deadlineContentLab.textAlignment = .left
        deadlineContentLab.text = "2020-03-27"
        return deadlineContentLab
    }()
    lazy var certificateTitleLab : UILabel = {
        var certificateTitleLab = UILabel.init()
        certificateTitleLab.font = DEF_FontSize_14
        certificateTitleLab.backgroundColor = .clear
        certificateTitleLab.textColor = .black
        certificateTitleLab.textAlignment = .left
        certificateTitleLab.text = "证书:"
        return certificateTitleLab
    }()
    lazy var certificateContentLab : UILabel = {
        var certificateContentLab = UILabel.init()
        certificateContentLab.font = DEF_FontSize_14
        certificateContentLab.backgroundColor = .clear
        certificateContentLab.textColor = .black
        certificateContentLab.textAlignment = .left
        certificateContentLab.text = "颁发机构"
        return certificateContentLab
    }()
    
    lazy var certificateBelongTitleLab : UILabel = {
        var certificateBelongTitleLab = UILabel.init()
        certificateBelongTitleLab.font = DEF_FontSize_14
        certificateBelongTitleLab.backgroundColor = .clear
        certificateBelongTitleLab.textColor = .black
        certificateBelongTitleLab.textAlignment = .left
        certificateBelongTitleLab.text = "所属机构:"
        return certificateBelongTitleLab
    }()
    lazy var certificateBelongContentLab : UILabel = {
        var certificateBelongContentLab = UILabel.init()
        certificateBelongContentLab.font = DEF_FontSize_14
        certificateBelongContentLab.backgroundColor = .clear
        certificateBelongContentLab.textColor = .black
        certificateBelongContentLab.textAlignment = .left
        certificateBelongContentLab.text = "所属机构"
        return certificateBelongContentLab
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.certificateTitleLab)
        self.contentView.addSubview(self.certificateContentLab)
        self.contentView.addSubview(self.certificateBelongTitleLab)
        self.contentView.addSubview(self.certificateBelongContentLab)
        self.contentView.addSubview(self.teacherTitleLab)
        self.contentView.addSubview(self.teacherContentLab)
        self.contentView.addSubview(self.classNumTitleLab)
        self.contentView.addSubview(self.classNumContentLab)
        self.contentView.addSubview(self.deadlineTitleLab)
        self.contentView.addSubview(self.deadlineContentLab)
        self.lineView.centerY = self.titleLab.centerY
        
        self.certificateTitleLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 15/WIDTH_6_SCALE, width: 70/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.certificateContentLab.frame = CGRect(x: self.certificateTitleLab.right + 10/WIDTH_6_SCALE, y: self.certificateTitleLab.top, width: SCREEN_WIDTH - teacherTitleLab.right - 20/WIDTH_6_SCALE, height: self.certificateTitleLab.height)
        
        self.certificateBelongTitleLab.frame = CGRect(x: self.titleLab.left, y: self.certificateTitleLab.bottom + 15/WIDTH_6_SCALE, width: self.certificateTitleLab.width, height: self.certificateTitleLab.height)
        self.certificateBelongContentLab.frame = CGRect(x: self.certificateBelongTitleLab.right + 10/WIDTH_6_SCALE, y: self.certificateBelongTitleLab.top, width: SCREEN_WIDTH - certificateBelongTitleLab.right - 20/WIDTH_6_SCALE, height: self.certificateTitleLab.height)
        
        self.teacherTitleLab.frame = CGRect(x: self.titleLab.left, y: self.certificateBelongTitleLab.bottom + 15/WIDTH_6_SCALE, width: self.certificateBelongTitleLab.width, height: self.certificateTitleLab.height)
        self.teacherContentLab.frame = CGRect(x: self.teacherTitleLab.right + 10/WIDTH_6_SCALE, y: self.teacherTitleLab.top, width: SCREEN_WIDTH - teacherTitleLab.right - 20/WIDTH_6_SCALE, height: self.certificateTitleLab.height)
        
        self.classNumTitleLab.frame = CGRect(x: self.teacherTitleLab.left, y: self.teacherTitleLab.bottom + 15/WIDTH_6_SCALE, width: self.teacherTitleLab.width, height: self.teacherTitleLab.height)
        self.classNumContentLab.frame = CGRect(x: self.classNumTitleLab.right + 10/WIDTH_6_SCALE, y: self.classNumTitleLab.top, width: SCREEN_WIDTH - classNumTitleLab.right - 20/WIDTH_6_SCALE, height: self.classNumTitleLab.height)
        
        self.deadlineTitleLab.frame = CGRect(x: self.teacherTitleLab.left, y: self.classNumTitleLab.bottom + 15/WIDTH_6_SCALE, width: self.classNumTitleLab.width, height: self.classNumTitleLab.height)
        self.deadlineContentLab.frame = CGRect(x: self.deadlineTitleLab.right + 10/WIDTH_6_SCALE, y: self.deadlineTitleLab.top, width: SCREEN_WIDTH - deadlineTitleLab.right - 20/WIDTH_6_SCALE, height: self.deadlineTitleLab.height)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
