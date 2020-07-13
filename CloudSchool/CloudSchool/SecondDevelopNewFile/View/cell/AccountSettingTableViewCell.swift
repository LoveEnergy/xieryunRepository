//
//  AccountSettingTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/2.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class AccountSettingTableViewCell: UITableViewCell {
    var model : [String : String]? {
        didSet{
            guard let model = model else { return }
            self.titleLab.text = model["title"]
            self.iconImg.image = UIImage.init(named: model["icon"]!)
            if model["bindStatus"] == "0"{
                self.unbindBtn.isHidden = true
                self.bindBtn.isHidden = false
            }else{
                self.unbindBtn.isHidden = false
                self.bindBtn.isHidden = true
            }
        }
    }
    public var bindBtnBlock:(()->())?//绑定按钮回调
    public var unbindBtnBlock:(()->())?//解绑按钮回调
    let borderW = 20/WIDTH_6_SCALE
    let imgW = 35/WIDTH_6_SCALE
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: self.iconImg.right + 12.5/WIDTH_6_SCALE, y: 5/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .left
        titleLab.text = "微博"
        titleLab.lineBreakMode = .byWordWrapping
        titleLab.numberOfLines = 0
        return titleLab
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 0, y: self.bgView.bottom - 1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.clear
        return lineView
    }()
    lazy var bgView : UIView = {
        var bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 60/WIDTH_6_SCALE))
        bgView.backgroundColor = UIColor.white
        return bgView
    }()
    
    lazy var bindBtn : UIButton = {
        let btnW = 60/WIDTH_6_SCALE
        let btnH = 30/WIDTH_6_SCALE
        var bindBtn = UIButton.init(frame: CGRect(x: self.bgView.width - btnW - 23/WIDTH_6_SCALE, y: 0, width: btnW, height: btnH))
        bindBtn.setTitle("绑定", for: .normal)
        bindBtn.setTitleColor(UIColor.white, for: .normal)
        bindBtn.titleLabel?.font = DEF_FontSize_12
        bindBtn.setBackgroundColor(UIColor.ColorHex("5595eb"), forState: .normal)
        bindBtn.layer.cornerRadius = btnH/2
        bindBtn.layer.masksToBounds = true
        bindBtn.addTarget(self, action: #selector(bindBtnClick), for: .touchUpInside)
        return bindBtn
    }()
    lazy var unbindBtn : UIButton = {
        let btnW = 60/WIDTH_6_SCALE
        let btnH = 30/WIDTH_6_SCALE
        var unbindBtn = UIButton.init(frame: CGRect(x: self.bgView.width - btnW - 23/WIDTH_6_SCALE, y: 0, width: btnW, height: btnH))
        unbindBtn.titleLabel?.font = DEF_FontSize_12
        unbindBtn.setBackgroundColor(UIColor.ColorHex("f7f6fb"), forState: .normal)
        unbindBtn.layer.cornerRadius = btnH/2
        unbindBtn.layer.masksToBounds = true
        unbindBtn.setTitle("已绑定", for: .normal)
        unbindBtn.setTitleColor(UIColor.black, for: .normal)
        unbindBtn.addTarget(self, action: #selector(unbindBtnClick), for: .touchUpInside)
        return unbindBtn
    }()
    lazy var iconImg : UIImageView = {
        let imgX = 35/WIDTH_6_SCALE
        var iconImg = UIImageView.init(frame: CGRect(x: imgX, y: 0, width: self.imgW, height: self.imgW))
        iconImg.backgroundColor = .clear
        return iconImg
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.bgView)
        self.contentView.addSubview(self.lineView)
        self.bgView.addSubview(self.iconImg)
        self.bgView.addSubview(self.titleLab)
        self.bgView.addSubview(self.bindBtn)
        self.bgView.addSubview(self.unbindBtn)
        self.iconImg.centerY = self.bgView.centerY
        self.titleLab.centerY = self.bgView.centerY
        self.bindBtn.centerY = self.bgView.centerY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func bindBtnClick(){
        self.bindBtnBlock!()
    }
    
    @objc func unbindBtnClick(){
        self.unbindBtnBlock!()
    }
}
