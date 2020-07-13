//
//  HomeCourseTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

class HomeCourseTableViewCell: UITableViewCell, CellMappable {
    
    typealias Model = CourseProtocol

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var buyNumberButton: UIButton!
    @IBOutlet weak var priceButton: UIButton!
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
    
    func configure(model: CourseProtocol) {
        iconImageView.loadImage(string: model.imageURL)
        nameLabel.text = model.name
//        priceButton.setTitle(model.price, for: .normal)
        if model.productType == 1{
            priceButton.setTitle("学点\(model.price)", for: .normal)
        }else{
            priceButton.setTitle(model.price, for: .normal)
        }
        buyNumberButton.setTitle(model.buyNumber.toString(), for: .normal)
        locationLabel.text = model.teacherName
        if model.productType == 3 && model.objectType == 2{
            locationLabel.text = model.addressString
        }
        
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
