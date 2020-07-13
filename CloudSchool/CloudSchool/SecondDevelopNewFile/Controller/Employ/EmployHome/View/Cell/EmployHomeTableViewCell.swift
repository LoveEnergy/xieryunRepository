//
//  EmployHomeTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmployHomeTableViewCell: UITableViewCell {
    var itemArr = ["五险一金", "全勤奖", "补充医疗保险"]
    lazy var grayView : UIView = {
        var grayView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        grayView.backgroundColor = UIColor.colorWithHex(hex: "F5F5F5")
        return grayView
    }()
    lazy var whiteView : UIView = {
        var whiteView = UIView.init(frame: CGRect(x: 0, y: self.grayView.bottom, width: SCREEN_WIDTH, height: 123.5/WIDTH_6_SCALE))
        whiteView.backgroundColor = .white
        return whiteView
    }()
    lazy var positionLab : UILabel = {
        var positionLab = UILabel.init(frame: CGRect(x: 20.5/WIDTH_6_SCALE, y: 11/WIDTH_6_SCALE, width: 200/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        positionLab.font = DEF_FontSize_15
        positionLab.backgroundColor = .clear
        positionLab.textColor = .black
        positionLab.textAlignment = .left
        positionLab.text = "aaa"
        return positionLab
    }()
    lazy var cityLab : UILabel = {
        var cityLab = UILabel.init(frame: CGRect(x: 20.5/WIDTH_6_SCALE, y: 8/WIDTH_6_SCALE + self.positionLab.bottom, width: self.getLabelWidth(text: "北京", font: DEF_FontSize_12, height: 14/WIDTH_6_SCALE), height: 15/WIDTH_6_SCALE))
        cityLab.font = DEF_FontSize_12
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
        var yearLab = UILabel.init(frame: CGRect(x: 3/WIDTH_6_SCALE + self.cityLineView.right, y: self.cityLab.top, width: self.getLabelWidth(text: "1-3年", font: DEF_FontSize_12, height: self.cityLab.height), height: self.cityLab.height))
        yearLab.font = DEF_FontSize_12
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
        var collectionView = UICollectionView.init(frame: CGRect(x: 0, y: self.educationLab.bottom + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 30/WIDTH_6_SCALE), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(EmployHomeTableViewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(EmployHomeTableViewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    lazy var moneyLab : UILabel = {
        var moneyLab = UILabel.init(frame: CGRect(x: SCREEN_WIDTH - 100/WIDTH_6_SCALE - 16.5/WIDTH_6_SCALE, y: 11.5/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        moneyLab.font = DEF_FontSize_17
        moneyLab.backgroundColor = .clear
        moneyLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        moneyLab.textAlignment = .right
        moneyLab.text = "4-10K/月"
        return moneyLab
    }()
    lazy var statusLab : UILabel = {
        var statusLab = UILabel.init(frame: CGRect(x: 0, y: 5/WIDTH_6_SCALE + self.moneyLab.bottom, width: SCREEN_WIDTH - 15.5/WIDTH_6_SCALE, height: 21.5/WIDTH_6_SCALE))
        statusLab.centerY = self.cityLab.centerY + 3/WIDTH_6_SCALE
        statusLab.font = DEF_FontSize_12
        statusLab.backgroundColor = .clear
        statusLab.textColor = UIColor.colorWithHex(hex: "888888")
        statusLab.textAlignment = .right
        statusLab.text = "最新"
        return statusLab
    }()
    lazy var iconImgView : UIImageView = {
        var iconImgView = UIImageView.init(frame: CGRect(x: 21.5/WIDTH_6_SCALE, y: self.collectionView.bottom + 3.5/WIDTH_6_SCALE, width: 28.5/WIDTH_6_SCALE, height: 26.5/WIDTH_6_SCALE))
        iconImgView.backgroundColor = .orange
        return iconImgView
    }()
    lazy var companyLab : UILabel = {
        var companyLab = UILabel.init(frame: CGRect(x: 8/WIDTH_6_SCALE + self.iconImgView.right, y: 0, width: SCREEN_WIDTH - self.iconImgView.right - 16/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        companyLab.centerY = self.iconImgView.centerY
        companyLab.font = DEF_FontSize_12
        companyLab.backgroundColor = .clear
        companyLab.textColor = .black
        companyLab.textAlignment = .left
        companyLab.text = "中国环境监测总站"
        return companyLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.grayView)
        self.contentView.addSubview(self.whiteView)
        self.whiteView.addSubview(self.positionLab)
        self.whiteView.addSubview(self.cityLab)
        self.whiteView.addSubview(self.cityLineView)
        self.whiteView.addSubview(self.yearLab)
        self.whiteView.addSubview(self.yearLineView)
        self.whiteView.addSubview(self.educationLab)
        self.whiteView.addSubview(self.collectionView)
        self.whiteView.addSubview(self.moneyLab)
        self.whiteView.addSubview(self.statusLab)
        self.whiteView.addSubview(self.iconImgView)
        self.whiteView.addSubview(self.companyLab)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmployHomeTableViewCell{
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
}

extension EmployHomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
