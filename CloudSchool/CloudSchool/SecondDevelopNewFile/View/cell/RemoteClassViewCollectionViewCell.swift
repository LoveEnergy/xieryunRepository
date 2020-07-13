//
//  RemoteClassViewCollectionViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/26.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class RemoteClassViewCollectionViewCell: UICollectionViewCell {
    var model: RemoteClassDetailModel? {
        didSet{
            self.imgView.loadImage(string: model?.thumbnailUrl)
            if model?.courseType == 0 {
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
            }else{
                self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
            }
            self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
        }
    }
    lazy var imgView : UIImageView = {
        var imgView = UIImageView.init(frame: self.bounds)
        imgView.layer.cornerRadius = 4
        imgView.layer.masksToBounds = true
        imgView.image = UIImage.init(named: "default_image")
        return imgView
    }()
    
    lazy var productTypeImgView : UIImageView = {
        weak var weakSelf = self
        let imgW = 40
        var productTypeImgView = UIImageView.init(frame: CGRect(x: (weakSelf?.imgView.width)! - CGFloat(imgW), y: (weakSelf?.imgView.height)! - CGFloat(imgW), width: CGFloat(imgW), height: CGFloat(imgW)))
        return productTypeImgView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(self.imgView)
        self.contentView.addSubview(self.productTypeImgView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 圆角设置/部分圆角
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}
