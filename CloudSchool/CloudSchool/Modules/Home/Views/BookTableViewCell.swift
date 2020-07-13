//
//  BookTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/2.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell, CellMappable {

    @IBOutlet weak var priceButton: UIButton!
    
    @IBOutlet weak var numberButton: UIButton!
    
    typealias Model = BookModel
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var productTypeImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: BookModel) {
        nameLabel.text = model.productName
        priceButton.setTitle("¥\(model.basicPrice.toString())", for: .normal)
        iconImageView.loadImage(string: model.thumbnailUrl)
        self.numberButton.setTitle("\(model.buyCount)", for: .normal)
        if model.courseType == 0 {
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
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
