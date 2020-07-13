//
//  BookCollectionViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class BookCollectionViewCell: UICollectionViewCell, CellMappable {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var productTypeImgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    func configure(model: BookModel) {
        thumbImageView.loadImage(string: model.thumbnailUrl)
        priceLabel.text = "¥ \(model.basicPrice)"
        nameLabel.text = model.productName
        if model.courseType == 0 {
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
    }
    
    func configure(recommendModel: RecommonModel) {
        thumbImageView.loadImage(string: recommendModel.thumbnailUrl)
        priceLabel.text = "¥ \(recommendModel.basicPrice)"
    }
    
    typealias Model = BookModel
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
