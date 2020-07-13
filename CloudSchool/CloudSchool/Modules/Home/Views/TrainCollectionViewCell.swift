//
//  TrainCollectionViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class TrainCollectionViewCell: UICollectionViewCell, CellMappable {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var getGroupImageView: UIImageView!
    @IBOutlet weak var typeSignImg: UIImageView!
    func configure(model: TrainModel) {
        thumbImageView.loadImage(string: model.thumbnailUrl)
        if model.courseType == 0 {
            self.typeSignImg.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.typeSignImg.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        self.configRectCorner(view: self.typeSignImg, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
        if model.isGroup == 0{
            self.getGroupImageView.isHidden = true
        }else{
            self.getGroupImageView.isHidden = false
        }
    }
    
    typealias Model = TrainModel
    

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
