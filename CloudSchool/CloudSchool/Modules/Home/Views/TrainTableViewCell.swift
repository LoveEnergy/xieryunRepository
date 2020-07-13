//
//  TrainTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/24.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class TrainTableViewCell: UITableViewCell, CellMappable {
    
    @IBOutlet weak var priceButton: UIButton!
    
    @IBOutlet weak var numberButton: UIButton!

    typealias Model = TrainModel

    @IBOutlet weak var locationLabel: UILabel!
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
    
    func configure(model: TrainModel) {
        iconImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
        locationLabel.text = "地址：\(model.addressString)"
        priceButton.setTitle("¥\(model.basicPrice.toString())/人", for: .normal)
        numberButton.setTitle("\(model.buyCount)人购买", for: .normal)
        if model.courseType == 0 {
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
    }
    
    func addDataToCell(model: RemoteClassDetailModel){
        iconImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
//        locationLabel.text = "地址：\(model.addressString)"
        priceButton.setTitle("¥\(model.basicPrice.toString())/人", for: .normal)
        numberButton.setTitle("\(model.buyCount)人购买", for: .normal)
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
