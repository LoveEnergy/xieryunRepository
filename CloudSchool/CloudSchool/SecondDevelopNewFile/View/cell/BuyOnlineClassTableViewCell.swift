
//
//  BuyOnlineClassTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/2.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class BuyOnlineClassTableViewCell: UITableViewCell {
    var model: CartGoodsModel? {
        didSet{
            guard let model = model else { return }
            self.iconImgView.loadImage(string: model.thumbnailUrl)
            self.productTitleLab.text = model.productName
            self.studyValueLab.text = "学点：\(model.price)"
            
            let string = self.studyValueLab.text
            let ranStr = "学点："
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
            let str = NSString(string: string!)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: theRange)
            attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: theRange)
            self.studyValueLab.attributedText = attrstring
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.iconImgView)
        self.contentView.addSubview(self.productTitleLab)
        self.contentView.addSubview(self.studyValueLab)
        self.contentView.addSubview(self.numLab)
        self.contentView.addSubview(self.lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var iconImgView : UIImageView = {
        var iconImgView = UIImageView.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: 109/WIDTH_6_SCALE, height: 73/WIDTH_6_SCALE))
        iconImgView.backgroundColor = UIColor.gray
        return iconImgView
    }()
    
    lazy var productTitleLab : UILabel = {
        weak var weakSelf = self
        var productTitleLab = UILabel.init(frame: CGRect(x: (weakSelf?.iconImgView.right)! + 15/WIDTH_6_SCALE, y: (weakSelf?.iconImgView.top)!, width: SCREEN_WIDTH - (weakSelf?.iconImgView.right)! - 21/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        productTitleLab.font = DEF_FontSize_14
        productTitleLab.backgroundColor = .clear
        productTitleLab.textColor = .black
        productTitleLab.textAlignment = .left
        productTitleLab.text = "工业污染源污染特征与环境违法行为解析"
        productTitleLab.lineBreakMode = .byWordWrapping
        productTitleLab.numberOfLines = 2
        productTitleLab.sizeToFit()
        return productTitleLab
    }()
    
    lazy var studyValueLab : UILabel = {
        weak var weakSelf = self
        var studyValueLab = UILabel.init(frame: CGRect(x: (weakSelf?.productTitleLab.left)!, y: (weakSelf?.iconImgView.bottom)! - 25/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        studyValueLab.font = DEF_FontSize_18
        studyValueLab.backgroundColor = .clear
        studyValueLab.textColor = UIColor.colorWithHex(hex: "FF6253")
        studyValueLab.textAlignment = .left
        studyValueLab.text = "学点：118.0"
        return studyValueLab
    }()
    
    lazy var numLab : UILabel = {
        weak var weakSelf = self
        let labelW = 50/WIDTH_6_SCALE
        let labelH = 15/WIDTH_6_SCALE
        var numLab = UILabel.init(frame: CGRect(x: SCREEN_WIDTH - 15/WIDTH_6_SCALE - labelW, y: (weakSelf?.iconImgView.bottom)! - labelH, width: labelW, height: labelH))
        numLab.font = DEF_FontSize_12
        numLab.backgroundColor = .clear
        numLab.textColor = .black
        numLab.textAlignment = .right
        numLab.text = "*1"
        return numLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: 92/WIDTH_6_SCALE, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 1))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "D8D8D8")
        return lineView
    }()
}
