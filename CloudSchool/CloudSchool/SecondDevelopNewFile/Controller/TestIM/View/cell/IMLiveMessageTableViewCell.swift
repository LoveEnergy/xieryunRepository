//
//  IMLiveMessageTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class IMLiveMessageTableViewCell: UITableViewCell {
    public var fansOptionsBlock:((String)->())?//消失
    var model: IMMessageModel?{
        didSet{
            guard let model = model else { return }
            let transformModel = model.emModel.body as! EMTextMessageBody
            let nickname = model.emModel.ext["nickname"]!
            let userType = model.emModel.ext["type"]!
            let string = "\(String(describing: nickname))：\(transformModel.text!)"
            let labelH = self.getLabelHeight(label:self.titleLab, string:string, font:14, textAlignment:.left, width:SCREEN_WIDTH - 108/WIDTH_6_SCALE)
            self.titleLab.frame = CGRect(x: 70/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 100/WIDTH_6_SCALE - 50/WIDTH_6_SCALE, height: labelH)
            self.labelBgView.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 50/WIDTH_6_SCALE - 30/WIDTH_6_SCALE, height: labelH + 20/WIDTH_6_SCALE)
            self.touchBtn.frame = CGRect(x: self.titleLab.left, y: self.titleLab.top, width: 80/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
            if userType as! String == "teacher"{
                self.userTypeLab.text = "助理"
                self.userTypeLab.backgroundColor = UIColor.colorWithHex(hex: "F5BC40")
            }
            if userType as! String == "user"{
                self.userTypeLab.text = "学员"
                self.userTypeLab.backgroundColor = UIColor.colorWithHex(hex: "0378FD")
            }
        }
    }
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 44/WIDTH_6_SCALE, y: 18.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 88/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "9edcff")
        titleLab.textAlignment = .left
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    lazy var labelBgView : UIView = {
        var labelBgView = UIView.init()
        labelBgView.backgroundColor = UIColor.black
        labelBgView.layer.masksToBounds = true
        labelBgView.layer.cornerRadius = 6
        labelBgView.alpha = 0.3
        return labelBgView
    }()
    lazy var touchBtn : UIButton = {
        var touchBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20/WIDTH_6_SCALE))
        touchBtn.setBackgroundColor(.clear, forState: .normal)
        touchBtn.addTarget(self, action: #selector(touchBtnClick), for: .touchUpInside)
        return touchBtn
    }()
    lazy var noTalkLab : UILabel = {
        var noTalkLab = UILabel.init()
        noTalkLab.font = DEF_FontSize_14
        noTalkLab.backgroundColor = .white
        noTalkLab.textColor = .black
        noTalkLab.textAlignment = .center
        titleLab.text = "禁言"
        return titleLab
    }()
    lazy var userTypeLab : UILabel = {
        var userTypeLab = UILabel.init(frame: CGRect(x: 30/WIDTH_6_SCALE, y: 11/WIDTH_6_SCALE, width: 35/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        userTypeLab.font = DEF_FontSize_9
        userTypeLab.textColor = .white
        userTypeLab.textAlignment = .center
        return userTypeLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.labelBgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.touchBtn)
        self.contentView.addSubview(self.userTypeLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchBtnClick(){
        self.fansOptionsBlock?(self.model!.emModel.from)
    }
    
    //效果最佳
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
}
