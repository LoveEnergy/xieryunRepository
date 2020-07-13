//
//  ExamRecordsTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/6/28.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ExamRecordsTableViewCell: UITableViewCell {
    public var checkRecordBlock:(()->())?//查看考试成绩
    var model: ExamResultInfoModel? {
        didSet{
            guard let model = model else { return }
            self.scoreLab.text = "\(model.score)分"
            self.timeLab.text = "\(model.createTime)"
            
            let string = self.scoreLab.text
            let ranStr = "分"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
            let str = NSString(string: string!)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: theRange)
            attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorWithHex(hex: "828282"), range: theRange)
            self.scoreLab.attributedText = attrstring
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.scoreLab)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.timeLab)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.checkBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.scoreLab.frame = CGRect(x: 15/375 * SCREEN_WIDTH, y: 20/375 * SCREEN_WIDTH, width: 100/375 * SCREEN_WIDTH, height: 36/375 * SCREEN_WIDTH)
        self.titleLab.frame = CGRect(x: 15/375 * SCREEN_WIDTH + self.scoreLab.right, y: self.scoreLab.top, width: 100/WIDTH_6_SCALE, height: 16/375 * SCREEN_WIDTH)
        self.timeLab.frame = CGRect(x: self.titleLab.left, y: self.titleLab.bottom + 6/375 * SCREEN_WIDTH, width: 160/375 * SCREEN_WIDTH, height: 14/375 * SCREEN_WIDTH)
        self.lineView.frame = CGRect(x: 15/375 * SCREEN_WIDTH, y: self.contentView.bottom - 0.8, width: SCREEN_WIDTH - 2 * (15/375 * SCREEN_WIDTH), height: 0.8)
        let btnW = 60/375 * SCREEN_WIDTH
        self.checkBtn.frame = CGRect(x: SCREEN_WIDTH - 15/375 * SCREEN_WIDTH - btnW, y: 0, width: btnW, height: 22/375 * SCREEN_WIDTH)
        self.checkBtn.centerY = self.scoreLab.centerY
    }
    
    lazy var scoreLab : UILabel = {
        var scoreLab = UILabel.init()
        scoreLab.font = UIFont.systemFont(ofSize: 36)
        scoreLab.backgroundColor = .clear
        scoreLab.textColor = UIColor.colorWithHex(hex: "FF6253")
        scoreLab.textAlignment = .left
        scoreLab.text = "98分"
        
        let string = scoreLab.text
        let ranStr = "分"
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
        let str = NSString(string: string!)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: theRange)
        attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorWithHex(hex: "828282"), range: theRange)
        scoreLab.attributedText = attrstring
        return scoreLab
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_16
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "第一次"
        return titleLab
    }()
    
    lazy var timeLab : UILabel = {
        var timeLab = UILabel.init()
        timeLab.font = DEF_FontSize_14
        timeLab.textColor = UIColor.colorWithHex(hex: "828282")
        timeLab.textAlignment = .left
        timeLab.text = "2020.06.28   11:33:08"
        return timeLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "D8D8D8")
        return lineView
    }()
    
    lazy var checkBtn : UIButton = {
        var checkBtn = UIButton.init()
        checkBtn.setTitle("查看考试", for: .normal)
        checkBtn.setTitleColor(UIColor.colorWithHex(hex: "4AA1F0"), for: .normal)
        checkBtn.titleLabel?.font = DEF_FontSize_12
        checkBtn.setBackgroundColor(UIColor.white, forState: .normal)
        checkBtn.layer.borderWidth = 1.0
        checkBtn.layer.borderColor = UIColor.colorWithHex(hex: "4AA1F0").cgColor
        checkBtn.addTarget(self, action: #selector(checkBtnClick), for: .touchUpInside)
        return checkBtn
    }()
    
    @objc func checkBtnClick(){
        self.checkRecordBlock?()
    }
}
