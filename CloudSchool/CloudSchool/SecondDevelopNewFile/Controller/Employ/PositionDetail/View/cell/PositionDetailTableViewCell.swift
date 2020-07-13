//
//  PositionDetailTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class PositionDetailTableViewCell: UITableViewCell {
    public var companyDetailBlock:(()->())?//公司详情页
    var itemArr = ["五险一金", "全勤奖", "补充医疗保险"]
    lazy var bgImgView : UIImageView = {
        var bgImgView = UIImageView.init(frame: CGRect(x: 7/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 14/WIDTH_6_SCALE, height: 207.5/WIDTH_6_SCALE))
        bgImgView.image = UIImage.init(named: "employBG")
        return bgImgView
    }()
    
    lazy var positionLab : UILabel = {
        var positionLab = UILabel.init(frame: CGRect(x: 24.5/WIDTH_6_SCALE, y: 29/WIDTH_6_SCALE, width: 200/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        positionLab.font = DEF_FontSize_15
        positionLab.backgroundColor = .clear
        positionLab.textColor = .black
        positionLab.textAlignment = .left
        positionLab.text = "aaa"
        return positionLab
    }()
    lazy var cityLab : UILabel = {
        var cityLab = UILabel.init(frame: CGRect(x: self.positionLab.left, y: 13/WIDTH_6_SCALE + self.positionLab.bottom, width: self.getLabelWidth(text: "北京", font: DEF_FontSize_13, height: 15/WIDTH_6_SCALE), height: 15/WIDTH_6_SCALE))
        cityLab.font = DEF_FontSize_13
        cityLab.backgroundColor = .clear
        cityLab.textColor = UIColor.colorWithHex(hex: "888888")
        cityLab.textAlignment = .center
        cityLab.text = "北京"
        return cityLab
    }()
    lazy var cityLineView : UIView = {
        var cityLineView = UIView.init(frame: CGRect(x: 3/WIDTH_6_SCALE + self.cityLab.right, y: self.cityLab.top, width: 1, height: self.cityLab.height))
        cityLineView.backgroundColor = UIColor.colorWithHex(hex: "888888")
        return cityLineView
    }()
    lazy var yearLab : UILabel = {
        var yearLab = UILabel.init(frame: CGRect(x: 3/WIDTH_6_SCALE + self.cityLineView.right, y: self.cityLab.top, width: self.getLabelWidth(text: "1-3年", font: DEF_FontSize_13, height: self.cityLab.height), height: self.cityLab.height))
        yearLab.font = DEF_FontSize_13
        yearLab.backgroundColor = .clear
        yearLab.textColor = UIColor.colorWithHex(hex: "888888")
        yearLab.textAlignment = .center
        yearLab.text = "1-3年"
        return yearLab
    }()
    lazy var yearLineView : UIView = {
        var yearLineView = UIView.init(frame: CGRect(x: self.yearLab.right + 3/WIDTH_6_SCALE, y: self.cityLab.top, width: 1, height: self.cityLab.height))
        yearLineView.backgroundColor = UIColor.colorWithHex(hex: "888888")
        return yearLineView
    }()
    lazy var educationLab : UILabel = {
        var educationLab = UILabel.init(frame: CGRect(x: 3/WIDTH_6_SCALE + self.yearLineView.right, y: self.cityLab.top, width: self.getLabelWidth(text: "1-3年", font: DEF_FontSize_12, height: self.cityLab.height), height: self.cityLab.height))
        educationLab.font = DEF_FontSize_12
        educationLab.backgroundColor = .clear
        educationLab.textColor = UIColor.colorWithHex(hex: "888888")
        educationLab.textAlignment = .center
        educationLab.text = "大专"
        return educationLab
    }()
    lazy var collectionView: UICollectionView = {
        var layout = EmployCollectionViewLayout.init(.left, 9.5/WIDTH_6_SCALE)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10/WIDTH_6_SCALE, bottom: 0, right: 10/WIDTH_6_SCALE)
        var collectionView = UICollectionView.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: self.educationLab.bottom + 13.5/WIDTH_6_SCALE, width: self.bgImgView.width - 40/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(EmployHomeTableViewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(EmployHomeTableViewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    lazy var grayLineView : UIView = {
        var grayLineView = UIView.init(frame: CGRect(x: 25.5/WIDTH_6_SCALE, y: self.collectionView.bottom + 10/WIDTH_6_SCALE, width: self.bgImgView.width - 51/WIDTH_6_SCALE, height: 1))
        grayLineView.backgroundColor = UIColor.colorWithHex(hex: "f5f5f5")
        return grayLineView
    }()
    lazy var moneyLab : UILabel = {
        var moneyLab = UILabel.init(frame: CGRect(x: self.bgImgView.width - 100/WIDTH_6_SCALE - 30/WIDTH_6_SCALE, y: 30.5/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        moneyLab.font = DEF_FontSize_17
        moneyLab.backgroundColor = .clear
        moneyLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        moneyLab.textAlignment = .right
        moneyLab.text = "4-10K/月"
        return moneyLab
    }()
    lazy var iconBtn : UIButton = {
        var iconBtn = UIButton.init(frame: CGRect(x: self.positionLab.left, y: self.grayLineView.bottom + 5/WIDTH_6_SCALE, width: 47/WIDTH_6_SCALE, height: 47/WIDTH_6_SCALE))
        iconBtn.setBackgroundColor(.orange, forState: .normal)
        iconBtn.addTarget(self, action: #selector(iconBtnClick), for: .touchUpInside)
        return iconBtn
    }()
    lazy var companyLab : UILabel = {
        var companyLab = UILabel.init(frame: CGRect(x: 8/WIDTH_6_SCALE + self.iconBtn.right, y: self.iconBtn.top, width: self.bgImgView.width - 86/WIDTH_6_SCALE - 32/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        companyLab.font = DEF_FontSize_12
        companyLab.backgroundColor = .clear
        companyLab.textColor = .black
        companyLab.textAlignment = .left
        companyLab.text = "中国环境监测总站"
        return companyLab
    }()
    lazy var contentLab : UILabel = {
        var contentLab = UILabel.init(frame: CGRect(x: self.companyLab.left, y: self.companyLab.bottom + 5/WIDTH_6_SCALE, width: self.companyLab.width, height: self.companyLab.height))
        contentLab.font = DEF_FontSize_12
        contentLab.backgroundColor = .clear
        contentLab.textColor = .black
        contentLab.textAlignment = .left
        contentLab.text = "不需要融资·10000以上"
        return contentLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.bgImgView)
        self.bgImgView.addSubview(self.positionLab)
        self.bgImgView.addSubview(self.cityLab)
        self.bgImgView.addSubview(self.cityLineView)
        self.bgImgView.addSubview(self.yearLab)
        self.bgImgView.addSubview(self.yearLineView)
        self.bgImgView.addSubview(self.educationLab)
        self.bgImgView.addSubview(self.collectionView)
        self.bgImgView.addSubview(self.moneyLab)
        self.bgImgView.addSubview(self.iconBtn)
        self.bgImgView.addSubview(self.companyLab)
        self.bgImgView.addSubview(self.contentLab)
        self.bgImgView.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PositionDetailTableViewCell{
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
    
    @objc func iconBtnClick(){
        self.companyDetailBlock?()
    }
}

extension PositionDetailTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: EmployHomeTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(EmployHomeTableViewCellCollectionViewCell.self), for: indexPath) as! EmployHomeTableViewCellCollectionViewCell
        item.model = self.itemArr[indexPath.row]
        return item
    }
    
    //label大小
    func sizeWithText(text: String, font: UIFont, size: CGSize) -> CGRect {
        let attributes = [NSAttributedString.Key.font: font]
        let option = NSStringDrawingOptions.usesLineFragmentOrigin
        let rect:CGRect = text.boundingRect(with: size, options: option, attributes: attributes, context: nil)
        return rect
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.getLabelWidth(text: self.itemArr[indexPath.row], font: DEF_FontSize_12, height: 15/WIDTH_6_SCALE) + 10/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
    }
}
