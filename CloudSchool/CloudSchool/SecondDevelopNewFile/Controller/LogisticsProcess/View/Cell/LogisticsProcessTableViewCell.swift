//
//  LogisticsProcessTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/24.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LogisticsProcessTableViewCell: UITableViewCell {
    var model: LogisticsDetailModel? {
        didSet{
            guard let model = model else { return }
            self.statusLab.text = model.AcceptStation
            let dateString = model.AcceptTime.trimmingCharacters(in: .whitespacesAndNewlines)
            //截取字符串
            let yearTempString = (dateString as NSString).substring(to: 10)
            let index = yearTempString.index(yearTempString.startIndex, offsetBy: 5)
            let timeString = dateString.suffix(8)
            self.dateLab.text = "\(yearTempString.suffix(from: index))"
            self.timeLab.text = "\(timeString)"
        }
    }
    lazy var dateLab : UILabel = {
        var dateLab = UILabel.init(frame: CGRect(x: 0, y: 7.5/WIDTH_6_SCALE, width: 54/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE))
        dateLab.font = DEF_FontSize_12
        dateLab.textColor = UIColor.colorWithHex(hex: "868686")
        dateLab.textAlignment = .right
        dateLab.text = "05-09"
        return dateLab
    }()
    lazy var timeLab : UILabel = {
        var timeLab = UILabel.init(frame: CGRect(x: 0, y: self.dateLab.bottom + 4/WIDTH_6_SCALE, width: self.dateLab.width, height: 11/WIDTH_6_SCALE))
        timeLab.font = DEF_FontSize_9
        timeLab.textColor = UIColor.colorWithHex(hex: "868686")
        timeLab.textAlignment = .right
        timeLab.text = "11:47"
        return timeLab
    }()
    lazy var topLineView : UIView = {
        var topLineView = UIView.init(frame: CGRect(x: self.dateLab.right + 15.5/WIDTH_6_SCALE, y: 0, width: 1, height: 6/WIDTH_6_SCALE))
        topLineView.backgroundColor = UIColor.colorWithHex(hex: "F0F0F0")
        return topLineView
    }()
    lazy var bottomLineView : UIView = {
        var bottomLineView = UIView.init(frame: CGRect(x: self.topLineView.left, y: self.circleView.bottom + 1.5/WIDTH_6_SCALE, width: 1, height: 34/WIDTH_6_SCALE))
        bottomLineView.backgroundColor = UIColor.colorWithHex(hex: "F0F0F0")
        return bottomLineView
    }()
    lazy var circleView : UIView = {
        var circleView = UIView.init(frame: CGRect(x: 0, y: self.topLineView.bottom + 1.5/WIDTH_6_SCALE, width: 6/WIDTH_6_SCALE, height: 6/WIDTH_6_SCALE))
        circleView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        circleView.layer.cornerRadius = 3/WIDTH_6_SCALE
        circleView.layer.masksToBounds = true
        return circleView
    }()
    lazy var statusLab : UILabel = {
        var statusLab = UILabel.init(frame: CGRect(x: 18/WIDTH_6_SCALE + self.topLineView.right, y: 6/WIDTH_6_SCALE, width: SCREEN_WIDTH - self.topLineView.right - 13/WIDTH_6_SCALE - 5/WIDTH_6_SCALE, height: 38/WIDTH_6_SCALE))
        statusLab.font = DEF_FontSize_11
        statusLab.backgroundColor = .clear
        statusLab.textColor = .black
        statusLab.textAlignment = .left
        statusLab.text = "【运输中】"
        statusLab.lineBreakMode = .byWordWrapping
        statusLab.numberOfLines = 0
        return statusLab
    }()
    lazy var deliveryPlaceLab : UILabel = {
        var deliveryPlaceLab = UILabel.init(frame: CGRect(x: 18/WIDTH_6_SCALE + self.topLineView.right, y: self.statusLab.bottom + 4.5/WIDTH_6_SCALE, width: self.statusLab.width, height: self.contentView.height - self.statusLab.bottom - 4.5/WIDTH_6_SCALE - 5/WIDTH_6_SCALE))
        deliveryPlaceLab.font = DEF_FontSize_10
        deliveryPlaceLab.backgroundColor = .clear
        deliveryPlaceLab.textColor = .black
        deliveryPlaceLab.textAlignment = .left
        deliveryPlaceLab.text = "aaa"
        deliveryPlaceLab.lineBreakMode = .byWordWrapping
        deliveryPlaceLab.numberOfLines = 0
        return deliveryPlaceLab
    }()
    lazy var iconImgView : UIImageView = {
        var iconImgView = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 28/WIDTH_6_SCALE, height: 28/WIDTH_6_SCALE))
        iconImgView.backgroundColor = UIColor.clear
        iconImgView.image = UIImage.init(named: "post_posting")
        return iconImgView
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.dateLab)
        self.contentView.addSubview(self.timeLab)
        self.contentView.addSubview(self.topLineView)
        self.contentView.addSubview(self.circleView)
        self.contentView.addSubview(self.bottomLineView)
        self.contentView.addSubview(self.statusLab)
//        self.contentView.addSubview(self.deliveryPlaceLab)
        self.circleView.centerX = self.topLineView.centerX
        self.contentView.addSubview(self.iconImgView)
        self.iconImgView.centerX = self.topLineView.centerX
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
