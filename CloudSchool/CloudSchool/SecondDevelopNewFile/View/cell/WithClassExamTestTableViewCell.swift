//
//  WithClassExamTestTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/16.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class WithClassExamTestTableViewCell: UITableViewCell {
    public var checkTestBtnClickBlock:((String, String)->())?//查看考试
    public var startTestBtnClickBlock:((String, String)->())?//开始测验
    var paperID: Int = 0
    var examID: Int = 0
    var model: ExamBaseInfoModel? {
        didSet{
            guard let model = model else { return }
            self.paperID = model.paperID
            self.examID = model.examID
            self.classTitleLab.text = model.examTitle
            self.startTimeLab.text = "开始时间：\(model.startTime)"
            self.endTimeLab.text = "结束时间：\(model.endTime)"
            self.scoreLab.text = "考试成绩：\(model.score)分"
            self.paperID = model.paperID
            self.examID = model.examID
            if model.haveScore == 0 {
                self.scoreLab.text = "考试成绩：未考试"
            }else{
                let string = self.scoreLab.text
                let ranStr = "\(model.score)"
                let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
                let str = NSString(string: string!)
                let theRange = str.range(of: ranStr)
                attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: theRange)
                attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: theRange)
                self.scoreLab.attributedText = attrstring
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.classTitleLab)
        self.contentView.addSubview(self.startTimeLab)
        self.contentView.addSubview(self.endTimeLab)
        self.contentView.addSubview(self.scoreLab)
        self.contentView.addSubview(self.checkTestBtn)
        self.contentView.addSubview(self.startTestBtn)
        self.contentView.addSubview(self.lineView)

        self.classTitleLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.startTimeLab.frame = CGRect(x: self.classTitleLab.left, y: self.classTitleLab.bottom + 10/WIDTH_6_SCALE, width: self.classTitleLab.width, height: self.classTitleLab.height)
        self.endTimeLab.frame = CGRect(x: self.classTitleLab.left, y: self.startTimeLab.bottom + 10/WIDTH_6_SCALE, width: self.classTitleLab.width, height: self.classTitleLab.height)
        self.scoreLab.frame = CGRect(x: self.classTitleLab.left, y: self.endTimeLab.bottom + 10/WIDTH_6_SCALE, width: self.classTitleLab.width, height: self.classTitleLab.height)
        self.checkTestBtn.frame = CGRect(x: self.classTitleLab.left, y: self.scoreLab.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - 32/WIDTH_6_SCALE, height: 35/WIDTH_6_SCALE)
        self.startTestBtn.frame = CGRect(x: SCREEN_WIDTH/2 + 16/WIDTH_6_SCALE, y: self.checkTestBtn.top, width: self.checkTestBtn.width, height: self.checkTestBtn.height)
        self.lineView.frame = CGRect(x: 0, y: self.startTestBtn.bottom + 9/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 1/WIDTH_6_SCALE)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var classTitleLab : UILabel = {
        var classTitleLab = UILabel.init()
        classTitleLab.font = DEF_FontSize_14
        classTitleLab.backgroundColor = .clear
        classTitleLab.textColor = .black
        classTitleLab.textAlignment = .left
        classTitleLab.text = "随堂测试标题"
        return classTitleLab
    }()
    
    lazy var startTimeLab : UILabel = {
        var startTimeLab = UILabel.init()
        startTimeLab.font = DEF_FontSize_14
        startTimeLab.backgroundColor = .clear
        startTimeLab.textColor = .black
        startTimeLab.textAlignment = .left
        startTimeLab.text = "2019-12-12 10:07:17"
        return startTimeLab
    }()
    
    lazy var endTimeLab : UILabel = {
        var endTimeLab = UILabel.init()
        endTimeLab.font = DEF_FontSize_14
        endTimeLab.backgroundColor = .clear
        endTimeLab.textColor = .black
        endTimeLab.textAlignment = .left
        endTimeLab.text = "2020-04-30 10:07:17"
        return endTimeLab
    }()
    
    lazy var scoreLab : UILabel = {
        var scoreLab = UILabel.init()
        scoreLab.font = DEF_FontSize_14
        scoreLab.backgroundColor = .clear
        scoreLab.textColor = .black
        scoreLab.textAlignment = .left
        scoreLab.text = "考试成绩：10 分"
        return scoreLab
    }()
    
    lazy var checkTestBtn : UIButton = {
        var checkTestBtn = UIButton.init()
        checkTestBtn.setTitle("查看考试", for: .normal)
        checkTestBtn.setTitleColor(UIColor.white, for: .normal)
        checkTestBtn.titleLabel?.font = DEF_FontSize_14
        checkTestBtn.setBackgroundColor(UIColor.colorWithHex(hex: "4aa1f1"), forState: .normal)
        checkTestBtn.layer.cornerRadius = 4
        checkTestBtn.layer.masksToBounds = true
        checkTestBtn.addTarget(self, action: #selector(checkTestBtnClick), for: .touchUpInside)
        return checkTestBtn
    }()
    
    lazy var startTestBtn : UIButton = {
        var startTestBtn = UIButton.init()
        startTestBtn.setTitle("开始测验", for: .normal)
        startTestBtn.setTitleColor(UIColor.white, for: .normal)
        startTestBtn.titleLabel?.font = DEF_FontSize_14
        startTestBtn.setBackgroundColor(UIColor.colorWithHex(hex: "4aa1f1"), forState: .normal)
        startTestBtn.layer.cornerRadius = 4
        startTestBtn.layer.masksToBounds = true
        startTestBtn.addTarget(self, action: #selector(startTestBtnClick), for: .touchUpInside)
        return startTestBtn
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    
    @objc func checkTestBtnClick(){
        self.checkTestBtnClickBlock?("\(self.paperID)", "\(self.examID)")
    }
    
    @objc func startTestBtnClick(){
        self.startTestBtnClickBlock?("\(self.paperID)", "\(self.examID)")
    }
}
