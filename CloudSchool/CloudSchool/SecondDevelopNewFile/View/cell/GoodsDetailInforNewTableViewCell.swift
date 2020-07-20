//
//  GoodsDetailInforNewTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GoodsDetailInforNewTableViewCell: UITableViewCell {
    public var shareGetMoneyBtnClickBlock:(()->())?
    var model : ProductDetailModel? {
        didSet{
            guard let model = model else { return }
            self.configPrice(oldPrice: "\(model.originalPrice)]", label: self.orderPriceLab)
            if model.originalPrice < 0.0 {
                self.orderPriceLab.isHidden = true
            }
            if model.productType == 1 {
                self.priceLab.text = "学点\(model.basicPrice)"
            }else{
                self.priceLab.text = "￥\(model.basicPrice)"
            }
            self.productTitleLab.text = model.productName
            if model.productType == 1 || model.productType == 3{
                self.storeImg.isHidden = true
                self.storeTitleLab.isHidden = true
            }else{
                let stroeNum = model.stock - model.buyCount
                self.storeTitleLab.text = "库存\(stroeNum)"
                if stroeNum < 0 {
                    self.storeTitleLab.text = "库存0"
                }
            }
            self.likeTitleLab.text = "\(model.likeCount)喜欢"
            self.buyTitleLab.text = "\(model.buyCount)人已购买"
            self.vipPriceLab.text = "￥\(model.vipPrice)"
            if model.productType == 1{
                self.buyTitleLab.text = "\(model.buyCount)人已报名"
            }
            if model.productType == 2 {
                self.buyTitleLab.text = "已售出\(model.buyCount)本"
            }
            if model.parentSeriesName.count == 0 {
                self.systemImg.isHidden = true
                self.systemTitleLab.isHidden = true
            }else{
                if model.seriesName.count == 0{
                    self.systemTitleLab.text = "体系:\(model.seriesName)"
                }else{
                    self.systemTitleLab.text = "体系:\(model.parentSeriesName)-\(model.seriesName)"
                }
                var systemW: CGFloat = self.getLabelWidth(text: self.systemTitleLab.text ?? "", font: DEF_FontSize_14, height: 15/WIDTH_6_SCALE)
                if systemW > SCREEN_WIDTH - 70/WIDTH_6_SCALE - self.systemImg.right - 6/WIDTH_6_SCALE{
                    systemW = SCREEN_WIDTH - 70/WIDTH_6_SCALE - self.systemImg.right - 6/WIDTH_6_SCALE
                }
                self.systemTitleLab.frame = CGRect(x: self.systemImg.right + 6/WIDTH_6_SCALE, y: self.productTitleLab.top + 40/WIDTH_6_SCALE + 10/WIDTH_6_SCALE, width: systemW, height: 15/WIDTH_6_SCALE)
                self.teacherImg.frame = CGRect(x: self.systemTitleLab.right + 15/WIDTH_6_SCALE, y: self.systemImg.top, width: 13.5/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
                self.teacherTitleLab.frame = CGRect(x: self.teacherImg.right + 6/WIDTH_6_SCALE, y: self.systemTitleLab.top, width: SCREEN_WIDTH - self.teacherImg.right - 4/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: self.systemTitleLab.height)
            }
            if model.teacherName.count == 0{
                self.teacherImg.isHidden = true
                self.teacherTitleLab.isHidden = true
            }else{
                self.teacherTitleLab.text = "教师:\(model.teacherName)"
            }
            if let shareModel = model.activityMap, let _ = shareModel.activityCategoryName.emptyToNil() {
                if model.vipPrice < 0{
                    self.setUpUIWithMoneyShare()
                }else{
                    self.setUpUIWithMoneyShareWithVIPPrice()
                }
                self.shareTitleLab.text = shareModel.activityCategoryName
                self.describeLab.text = shareModel.activityAbbreviation
                self.shareTitleLab.frame = CGRect(x: self.priceTitleLab.left, y: 0, width: self.getLabelWidth(text: shareModel.activityCategoryName, font: DEF_FontSize_16, height: 25/WIDTH_6_SCALE) + 15/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE)
                self.deadlineLab.frame = CGRect(x: self.shareTitleLab.left, y: self.shareTitleLab.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 + 50/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
                self.moneyImgView.frame = CGRect(x: SCREEN_WIDTH - 50/WIDTH_6_SCALE, y: 0, width: 23/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE)
                self.describeLab.frame = CGRect(x: 0, y: self.moneyImgView.bottom + 5/WIDTH_6_SCALE, width: self.getLabelWidth(text: shareModel.activityAbbreviation, font: DEF_FontSize_14, height: 15/WIDTH_6_SCALE), height: 15/WIDTH_6_SCALE)
                self.describeLab.centerX = self.moneyImgView.centerX
                self.shareGetMoneyBtn.frame = CGRect(x: self.describeLab.left, y: self.moneyImgView.top, width: self.describeLab.width, height: self.deadlineLab.bottom)
            } else {
                if model.vipPrice < 0 {
                    self.setUpNoneCharacterViewUI()
                }else{
                    self.setUpNoneCharacterWithVIPPriceViewUI()
                }
                if model.seriesName.isEmpty {
                    self.teacherImg.frame = self.systemImg.frame
                    self.teacherTitleLab.frame = self.systemTitleLab.frame
                }
            }
        }
    }
    let labelW = 90/WIDTH_6_SCALE
    
    lazy var priceLab : UILabel = {
        var priceLab = UILabel.init()
        priceLab.font = UIFont.systemFont(ofSize: 16)
        priceLab.backgroundColor = .clear
        priceLab.textColor = UIColor.black
        priceLab.textAlignment = .left
        priceLab.text = "￥123.00"
        return priceLab
    }()
    lazy var productTitleLab : UILabel = {
        var productTitleLab = UILabel.init()
        productTitleLab.font = DEF_FontSize_16
        productTitleLab.backgroundColor = .clear
        productTitleLab.textColor = .black
        productTitleLab.textAlignment = .left
        productTitleLab.text = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaabbbbbbbccccccccccccccccccccc"
        productTitleLab.lineBreakMode = .byWordWrapping
        productTitleLab.numberOfLines = 2
        productTitleLab.sizeToFit()
        return productTitleLab
    }()
    lazy var systemImg : UIImageView = {
        var systemImg = UIImageView.init()
        systemImg.image = UIImage.init(named: "blue_system")
        return systemImg
    }()
    lazy var systemTitleLab : UILabel = {
        var systemTitleLab = UILabel.init()
        systemTitleLab.font = DEF_FontSize_14
        systemTitleLab.backgroundColor = .clear
        systemTitleLab.textColor = .black
        systemTitleLab.textAlignment = .left
        systemTitleLab.text = "体系:xxxx"
        return systemTitleLab
    }()
    lazy var teacherImg : UIImageView = {
        var teacherImg = UIImageView.init()
        teacherImg.image = UIImage.init(named: "blue_teacher")
        return teacherImg
    }()
    lazy var teacherTitleLab : UILabel = {
        var teacherTitleLab = UILabel.init()
        teacherTitleLab.font = DEF_FontSize_14
        teacherTitleLab.backgroundColor = .clear
        teacherTitleLab.textColor = .black
        teacherTitleLab.textAlignment = .left
        teacherTitleLab.text = "教师:xxxx"
        return teacherTitleLab
    }()
    
    lazy var buyImg : UIImageView = {
        var buyImg = UIImageView.init()
        buyImg.image = UIImage.init(named: "goodsdetail_new_buy")
        return buyImg
    }()
    lazy var buyTitleLab : UILabel = {
        var buyTitleLab = UILabel.init()
        buyTitleLab.font = DEF_FontSize_12
        buyTitleLab.backgroundColor = .clear
        buyTitleLab.textColor = UIColor.ColorHex("999999")
        buyTitleLab.textAlignment = .left
        buyTitleLab.text = "100人购买"
        return buyTitleLab
    }()
    
    lazy var likeImg : UIImageView = {
        var likeImg = UIImageView.init()
        likeImg.image = UIImage.init(named: "goodsdetail_new_like")
        return likeImg
    }()
    lazy var likeTitleLab : UILabel = {
        var likeTitleLab = UILabel.init()
        likeTitleLab.font = DEF_FontSize_12
        likeTitleLab.backgroundColor = .clear
        likeTitleLab.textColor = UIColor.ColorHex("999999")
        likeTitleLab.textAlignment = .left
        likeTitleLab.text = "999人喜欢"
        return likeTitleLab
    }()
    
    lazy var storeImg : UIImageView = {
        var storeImg = UIImageView.init()
        storeImg.image = UIImage.init(named: "goodsdetail_new_store")
        return storeImg
    }()
    lazy var storeTitleLab : UILabel = {
        var storeTitleLab = UILabel.init()
        storeTitleLab.font = DEF_FontSize_12
        storeTitleLab.backgroundColor = .clear
        storeTitleLab.textColor = UIColor.ColorHex("999999")
        storeTitleLab.textAlignment = .left
        storeTitleLab.text = "库存999"
        return storeTitleLab
    }()
    
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return lineView
    }()
    
    lazy var shareView: UIView = {
        var shareView = UIView.init()
        shareView.backgroundColor = .white
        return shareView
    }()
    lazy var shareTitleLab : UILabel = {
        var shareTitleLab = UILabel.init()
        shareTitleLab.font = DEF_FontSize_16
        shareTitleLab.backgroundColor = .clear
        shareTitleLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        shareTitleLab.textAlignment = .center
        shareTitleLab.text = "分享下单立减xx元"
        shareTitleLab.layer.cornerRadius = 4
        shareTitleLab.layer.masksToBounds = true
        shareTitleLab.layer.borderColor = UIColor.colorWithHex(hex: "FF6434").cgColor
        shareTitleLab.layer.borderWidth = 0.8
        return shareTitleLab
    }()
    lazy var deadlineLab : UILabel = {
        var deadlineLab = UILabel.init()
        deadlineLab.font = DEF_FontSize_12
        deadlineLab.backgroundColor = .clear
        deadlineLab.textColor = .black
        deadlineLab.textAlignment = .left
        deadlineLab.text = "截止时间:2021-01-01 00:00:00"
        return deadlineLab
    }()
    lazy var moneyImgView : UIImageView = {
        var moneyImgView = UIImageView.init()
        moneyImgView.image = UIImage.init(named: "share_wallet")
        moneyImgView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return moneyImgView
    }()
    lazy var describeLab : UILabel = {
        var describeLab = UILabel.init()
        describeLab.font = DEF_FontSize_14
        describeLab.backgroundColor = .clear
        describeLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        describeLab.textAlignment = .right
        describeLab.text = "赚"
        return describeLab
    }()
    lazy var shareGetMoneyBtn: UIButton = {
        var shareGetMoneyBtn = UIButton.init()
        shareGetMoneyBtn.setBackgroundColor(.clear, forState: .normal)
        shareGetMoneyBtn.addTarget(self, action: #selector(shareGetMoneyBtnClick), for: .touchUpInside)
        return shareGetMoneyBtn
    }()
    lazy var priceTitleLab : UILabel = {
        var priceTitleLab = UILabel.init()
        priceTitleLab.font = DEF_FontSize_14
        priceTitleLab.backgroundColor = .clear
        priceTitleLab.textColor = .black
        priceTitleLab.textAlignment = .left
        priceTitleLab.text = "价格"
        return priceTitleLab
    }()
    lazy var vipImgView : UIImageView = {
        var vipImgView = UIImageView.init()
        vipImgView.image = UIImage.init(named: "goodsdetail_vip")
        return vipImgView
    }()
    lazy var vipPriceLab : UILabel = {
        var vipPriceLab = UILabel.init()
        vipPriceLab.font = DEF_FontSize_24
        vipPriceLab.backgroundColor = .clear
        vipPriceLab.textColor = UIColor.colorWithHex(hex: "#FF9E27")
        vipPriceLab.textAlignment = .left
        vipPriceLab.text = ""
        return vipPriceLab
    }()
    lazy var orderPriceLab : UILabel = {
        var orderPriceLab = UILabel.init()
        orderPriceLab.font = DEF_FontSize_12
        orderPriceLab.backgroundColor = .clear
        orderPriceLab.textColor = UIColor.colorWithHex(hex: "#828282")
        orderPriceLab.textAlignment = .left
        orderPriceLab.text = "[定价￥]"
        return orderPriceLab
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.backgroundColor = .white
        self.contentView.addSubview(self.shareView)
        self.shareView.addSubview(self.shareTitleLab)
        self.shareView.addSubview(self.deadlineLab)
        self.shareView.addSubview(self.moneyImgView)
        self.shareView.addSubview(self.describeLab)
        self.shareView.addSubview(self.shareGetMoneyBtn)
        self.contentView.addSubview(self.priceTitleLab)
        self.contentView.addSubview(self.priceLab)
        self.contentView.addSubview(self.orderPriceLab)
        self.contentView.addSubview(self.vipImgView)
        self.contentView.addSubview(self.vipPriceLab)
        self.contentView.addSubview(self.productTitleLab)
        self.contentView.addSubview(self.systemImg)
        self.contentView.addSubview(self.systemTitleLab)
        self.contentView.addSubview(self.teacherImg)
        self.contentView.addSubview(self.teacherTitleLab)
        self.contentView.addSubview(self.buyImg)
        self.contentView.addSubview(self.buyTitleLab)
        self.contentView.addSubview(self.likeImg)
        self.contentView.addSubview(self.likeTitleLab)
        self.contentView.addSubview(self.storeImg)
        self.contentView.addSubview(self.storeTitleLab)
    }
    
    func setUpNoneCharacterWithVIPPriceViewUI(){
        self.priceTitleLab.frame = CGRect(x: 17/375 * SCREEN_WIDTH, y: 10.5/375 * SCREEN_WIDTH, width: 30/375 * SCREEN_WIDTH, height: 14/375 * SCREEN_WIDTH)
        self.priceLab.frame = CGRect(x: self.priceTitleLab.right + 40/375 * SCREEN_WIDTH, y: 0, width: 80/WIDTH_6_SCALE, height: 20.5/WIDTH_6_SCALE)
        self.priceLab.centerY = self.priceTitleLab.centerY
        self.orderPriceLab.frame = CGRect(x: self.priceLab.right + 5/375 * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH/2, height: 12/375 * SCREEN_WIDTH)
        self.orderPriceLab.centerY = self.priceLab.centerY
        self.vipImgView.frame = CGRect(x: self.priceTitleLab.left, y: self.priceTitleLab.bottom + 15/375 * SCREEN_WIDTH, width: 38/375 * SCREEN_WIDTH, height: 15/375 * SCREEN_WIDTH)
        self.vipPriceLab.frame = CGRect(x: self.priceLab.left, y: 0, width: 150, height: 24/375 * SCREEN_WIDTH)
        self.vipPriceLab.centerY = self.vipImgView.centerY
        self.productTitleLab.frame = CGRect(x: self.priceTitleLab.left, y: self.vipPriceLab.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2 * 16.5/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.systemImg.frame = CGRect(x: 17.5/WIDTH_6_SCALE, y: self.productTitleLab.bottom + 5/WIDTH_6_SCALE, width: 14.4/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.systemTitleLab.frame = CGRect(x: self.systemImg.right + 6/WIDTH_6_SCALE, y: self.productTitleLab.top + 40/WIDTH_6_SCALE + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - self.systemImg.right - 6/WIDTH_6_SCALE + 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.teacherImg.frame = CGRect(x: SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE, y: 0, width: 13.5/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.teacherTitleLab.frame = CGRect(x: self.teacherImg.right + 6/WIDTH_6_SCALE, y: self.systemTitleLab.top, width: SCREEN_WIDTH - self.teacherImg.right - 4/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: self.systemTitleLab.height)
        self.buyImg.frame = CGRect(x: self.systemImg.left, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.buyTitleLab.frame = CGRect(x: self.buyImg.right + 5/WIDTH_6_SCALE, y: self.systemTitleLab.bottom + 14/WIDTH_6_SCALE, width: self.labelW, height: 15/WIDTH_6_SCALE)
        self.likeImg.frame = CGRect(x: self.buyTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14.5/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.likeTitleLab.frame = CGRect(x: self.likeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.storeImg.frame = CGRect(x: self.likeTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.storeTitleLab.frame = CGRect(x: self.storeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.systemImg.centerY = self.systemTitleLab.centerY
        self.teacherImg.centerY = self.systemImg.centerY
        self.buyImg.centerY = self.buyTitleLab.centerY
        self.likeImg.centerY = self.likeTitleLab.centerY
        self.storeImg.centerY = self.storeTitleLab.centerY
    }
    func setUpNoneCharacterViewUI(){
        self.priceTitleLab.frame = CGRect(x: 17/375 * SCREEN_WIDTH, y: 10.5/375 * SCREEN_WIDTH, width: 30/375 * SCREEN_WIDTH, height: 14/375 * SCREEN_WIDTH)
        self.priceLab.frame = CGRect(x: self.priceTitleLab.right + 40/375 * SCREEN_WIDTH, y: 0, width: 80/WIDTH_6_SCALE, height: 20.5/WIDTH_6_SCALE)
        self.priceLab.centerY = self.priceTitleLab.centerY
        self.orderPriceLab.frame = CGRect(x: self.priceLab.right + 5/375 * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH/2, height: 12/375 * SCREEN_WIDTH)
        self.orderPriceLab.centerY = self.priceLab.centerY
        self.productTitleLab.frame = CGRect(x: self.priceTitleLab.left, y: self.priceLab.bottom + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2 * 16.5/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.systemImg.frame = CGRect(x: 17.5/WIDTH_6_SCALE, y: self.productTitleLab.bottom + 5/WIDTH_6_SCALE, width: 14.4/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.systemTitleLab.frame = CGRect(x: self.systemImg.right + 6/WIDTH_6_SCALE, y: self.productTitleLab.top + 40/WIDTH_6_SCALE + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - self.systemImg.right - 6/WIDTH_6_SCALE + 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.teacherImg.frame = CGRect(x: SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE, y: 0, width: 13.5/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.teacherTitleLab.frame = CGRect(x: self.teacherImg.right + 6/WIDTH_6_SCALE, y: self.systemTitleLab.top, width: SCREEN_WIDTH - self.teacherImg.right - 4/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: self.systemTitleLab.height)
        self.buyImg.frame = CGRect(x: self.systemImg.left, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.buyTitleLab.frame = CGRect(x: self.buyImg.right + 5/WIDTH_6_SCALE, y: self.systemTitleLab.bottom + 14/WIDTH_6_SCALE, width: self.labelW, height: 15/WIDTH_6_SCALE)
        self.likeImg.frame = CGRect(x: self.buyTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14.5/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.likeTitleLab.frame = CGRect(x: self.likeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.storeImg.frame = CGRect(x: self.likeTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.storeTitleLab.frame = CGRect(x: self.storeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.systemImg.centerY = self.systemTitleLab.centerY
        self.teacherImg.centerY = self.systemImg.centerY
        self.buyImg.centerY = self.buyTitleLab.centerY
        self.likeImg.centerY = self.likeTitleLab.centerY
        self.storeImg.centerY = self.storeTitleLab.centerY
    }
    
    func setUpUIWithMoneyShare(){
        self.priceTitleLab.frame = CGRect(x: 17/375 * SCREEN_WIDTH, y: 10.5/375 * SCREEN_WIDTH, width: 30/375 * SCREEN_WIDTH, height: 14/375 * SCREEN_WIDTH)
        self.priceLab.frame = CGRect(x: self.priceTitleLab.right + 40/375 * SCREEN_WIDTH, y: 0, width: 80/WIDTH_6_SCALE, height: 20.5/WIDTH_6_SCALE)
        self.priceLab.centerY = self.priceTitleLab.centerY
        self.orderPriceLab.frame = CGRect(x: self.priceLab.right + 5/375 * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH/2, height: 12/375 * SCREEN_WIDTH)
        self.orderPriceLab.centerY = self.priceLab.centerY
        self.shareView.frame = CGRect(x: 0, y: self.priceLab.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 55/WIDTH_6_SCALE)
        self.productTitleLab.frame = CGRect(x: self.priceTitleLab.left, y: self.shareView.bottom + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2 * 16.5/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.systemImg.frame = CGRect(x: 17.5/WIDTH_6_SCALE, y: self.productTitleLab.bottom + 5/WIDTH_6_SCALE, width: 14.4/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.systemTitleLab.frame = CGRect(x: self.systemImg.right + 6/WIDTH_6_SCALE, y: self.productTitleLab.top + 40/WIDTH_6_SCALE + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - self.systemImg.right - 6/WIDTH_6_SCALE + 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.teacherImg.frame = CGRect(x: SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE, y: 0, width: 13.5/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.teacherTitleLab.frame = CGRect(x: self.teacherImg.right + 6/WIDTH_6_SCALE, y: self.systemTitleLab.top, width: SCREEN_WIDTH - self.teacherImg.right - 4/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: self.systemTitleLab.height)
        self.buyImg.frame = CGRect(x: self.systemImg.left, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.buyTitleLab.frame = CGRect(x: self.buyImg.right + 5/WIDTH_6_SCALE, y: self.systemTitleLab.bottom + 14/WIDTH_6_SCALE, width: self.labelW, height: 15/WIDTH_6_SCALE)
        self.likeImg.frame = CGRect(x: self.buyTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14.5/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.likeTitleLab.frame = CGRect(x: self.likeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.storeImg.frame = CGRect(x: self.likeTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.storeTitleLab.frame = CGRect(x: self.storeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.systemImg.centerY = self.systemTitleLab.centerY
        self.teacherImg.centerY = self.systemImg.centerY
        self.buyImg.centerY = self.buyTitleLab.centerY
        self.likeImg.centerY = self.likeTitleLab.centerY
        self.storeImg.centerY = self.storeTitleLab.centerY
    }
    
    func setUpUIWithMoneyShareWithVIPPrice(){
        self.priceTitleLab.frame = CGRect(x: 17/375 * SCREEN_WIDTH, y: 10.5/375 * SCREEN_WIDTH, width: 30/375 * SCREEN_WIDTH, height: 14/375 * SCREEN_WIDTH)
        self.priceLab.frame = CGRect(x: self.priceTitleLab.right + 40/375 * SCREEN_WIDTH, y: 0, width: 80/WIDTH_6_SCALE, height: 20.5/WIDTH_6_SCALE)
        self.priceLab.centerY = self.priceTitleLab.centerY
        self.orderPriceLab.frame = CGRect(x: self.priceLab.right + 5/375 * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH/2, height: 12/375 * SCREEN_WIDTH)
        self.orderPriceLab.centerY = self.priceLab.centerY
        self.vipImgView.frame = CGRect(x: self.priceTitleLab.left, y: self.priceTitleLab.bottom + 15/375 * SCREEN_WIDTH, width: 38/375 * SCREEN_WIDTH, height: 15/375 * SCREEN_WIDTH)
        self.vipPriceLab.frame = CGRect(x: self.priceLab.left, y: 0, width: 150, height: 24/375 * SCREEN_WIDTH)
        self.vipPriceLab.centerY = self.vipImgView.centerY
        self.shareView.frame = CGRect(x: 0, y: self.vipPriceLab.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 55/WIDTH_6_SCALE)
        self.productTitleLab.frame = CGRect(x: self.priceTitleLab.left, y: self.shareView.bottom + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2 * 16.5/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE)
        self.systemImg.frame = CGRect(x: 17.5/WIDTH_6_SCALE, y: self.productTitleLab.bottom + 5/WIDTH_6_SCALE, width: 14.4/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.systemTitleLab.frame = CGRect(x: self.systemImg.right + 6/WIDTH_6_SCALE, y: self.productTitleLab.top + 40/WIDTH_6_SCALE + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH/2 - self.systemImg.right - 6/WIDTH_6_SCALE + 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.teacherImg.frame = CGRect(x: SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE, y: 0, width: 13.5/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.teacherTitleLab.frame = CGRect(x: self.teacherImg.right + 6/WIDTH_6_SCALE, y: self.systemTitleLab.top, width: SCREEN_WIDTH - self.teacherImg.right - 4/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: self.systemTitleLab.height)
        self.buyImg.frame = CGRect(x: self.systemImg.left, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.buyTitleLab.frame = CGRect(x: self.buyImg.right + 5/WIDTH_6_SCALE, y: self.systemTitleLab.bottom + 14/WIDTH_6_SCALE, width: self.labelW, height: 15/WIDTH_6_SCALE)
        self.likeImg.frame = CGRect(x: self.buyTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14.5/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE)
        self.likeTitleLab.frame = CGRect(x: self.likeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.storeImg.frame = CGRect(x: self.likeTitleLab.right + 20/WIDTH_6_SCALE, y: 0, width: 14/WIDTH_6_SCALE, height: 13.5/WIDTH_6_SCALE)
        self.storeTitleLab.frame = CGRect(x: self.storeImg.right + 5/WIDTH_6_SCALE, y: self.buyTitleLab.top, width: self.buyTitleLab.width, height: self.buyTitleLab.height)
        self.systemImg.centerY = self.systemTitleLab.centerY
        self.teacherImg.centerY = self.systemImg.centerY
        self.buyImg.centerY = self.buyTitleLab.centerY
        self.likeImg.centerY = self.likeTitleLab.centerY
        self.storeImg.centerY = self.storeTitleLab.centerY
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
    
    @objc func shareGetMoneyBtnClick(){
        self.shareGetMoneyBtnClickBlock?()
    }
    
    func configPrice(oldPrice: String, label: UILabel) -> Void {
        let prefix = "[定价"
        let suffix = "￥" + oldPrice
        let string = prefix + suffix
        let myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.lightGray,
                           NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                           NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)] as [NSAttributedString.Key : Any]
        let attString = NSMutableAttributedString(string: string)
        attString.addAttributes(myAttribute, range: NSRange.init(location: prefix.count, length: suffix.count - 1))
        label.attributedText = attString
    }
}
