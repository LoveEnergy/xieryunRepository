//
//  IMMessageTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class IMMessageTableViewCell: UITableViewCell {
    public var fansOptions:(()->())?//消失
    var model: IMMessageModel?{
        didSet{
            guard let model = model else { return }
            let transformModel = model.emModel.body as! EMTextMessageBody
            let nickname = model.emModel.ext["nickname"]!
            let string = "\(String(describing: nickname))：\(transformModel.text!)"
            let labelH = self.getLabelHeight(label:self.titleLab, string:string, font:14, textAlignment:.left, width:SCREEN_WIDTH - 108/WIDTH_6_SCALE)
            self.titleLab.frame = CGRect(x: 84/WIDTH_6_SCALE, y: 18.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 44/WIDTH_6_SCALE - 84/WIDTH_6_SCALE, height: labelH)
            self.bgView.frame = CGRect(x: 22.5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 43/WIDTH_6_SCALE, height: 17/WIDTH_6_SCALE + labelH + 20/WIDTH_6_SCALE)
            self.labelBgView.frame = CGRect(x: 34.5/WIDTH_6_SCALE, y: 8.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 69/WIDTH_6_SCALE, height: labelH + 17/WIDTH_6_SCALE)
            self.noTalkSignLab.frame = CGRect(x: 0, y: 0, width: self.bgView.left, height: self.bgView.height)
            self.noTalkSignLab.isHidden = true
            if model.emModel.status == EMMessageStatusFailed{
                self.noTalkSignLab.isHidden = false
            }
            let userType = model.emModel.ext["type"]!
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
    lazy var userTypeLab : UILabel = {
        var userTypeLab = UILabel.init(frame: CGRect(x: 44/WIDTH_6_SCALE, y: 18.5/WIDTH_6_SCALE, width: 35/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        userTypeLab.font = DEF_FontSize_9
        userTypeLab.textColor = .white
        userTypeLab.textAlignment = .center
        return userTypeLab
    }()
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 44/WIDTH_6_SCALE, y: 18.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 88/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .white
        titleLab.textAlignment = .left
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    lazy var copyLab : UILabel = {
        var copyLab = UILabel.init(frame: CGRect(x: 74/WIDTH_6_SCALE, y: 24.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 108/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        copyLab.font = DEF_FontSize_14
        copyLab.backgroundColor = .orange
        copyLab.textColor = .black
        copyLab.textAlignment = .left
        copyLab.lineBreakMode = .byWordWrapping
        copyLab.numberOfLines = 0
        return copyLab
    }()
    
    lazy var labelBgView : UIView = {
        var labelBgView = UIView.init()
        labelBgView.backgroundColor = UIColor.colorWithHex(hex: "c8c8c8")
        return labelBgView
    }()
    lazy var bgView : UIView = {
        var bgView = UIView.init()
        bgView.backgroundColor = UIColor.colorWithHex(hex: "FAFAFA")
        return bgView
    }()
    lazy var touchBtn : UIButton = {
        var touchBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 20/WIDTH_6_SCALE))
        touchBtn.setBackgroundColor(.orange, forState: .normal)
        touchBtn.addTarget(self, action: #selector(touchBtnClick), for: .touchUpInside)
        return touchBtn
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    lazy var noTalkSignLab : UILabel = {
        var noTalkSignLab = UILabel.init()
        noTalkSignLab.font = DEF_FontSize_16
        noTalkSignLab.backgroundColor = .clear
        noTalkSignLab.textColor = .red
        noTalkSignLab.textAlignment = .center
        noTalkSignLab.text = "!"
        return noTalkSignLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.bgView)
        self.contentView.addSubview(self.labelBgView)
        self.contentView.addSubview(self.titleLab)
        self.contentView.addSubview(self.copyLab)
        self.contentView.addSubview(self.noTalkSignLab)
        self.copyLab.isHidden = true
        self.contentView.addSubview(self.userTypeLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func touchBtnClick(){
        
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
