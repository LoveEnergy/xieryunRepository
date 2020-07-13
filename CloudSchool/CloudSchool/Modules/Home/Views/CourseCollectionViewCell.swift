//
//  CourseCollectionViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var likeNumberButton: UIButton!
    @IBOutlet weak var buyNumberButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    
    @IBOutlet weak var productTypeImgView: UIImageView!
    var disposeBag: DisposeBag = DisposeBag()
    var model: CourseModel?
    var inviteModel: InviteCodeModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        priceLabel.textColor = UIColor.mainRedColor
        shareButton.borderColor = UIColor.mainRedColor
        shareButton.borderWidth = 0.5
        shareButton.cornerRadius = 2
        shareButton.setTitleColor(UIColor.mainRedColor, for: .normal)
        // Initialization code
        shareButton.addTarget(self, action: #selector(shareButtonClick), for: .touchUpInside)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func configure(model: CourseModel) {
        self.model = model
        nameLabel.text = model.name
        if model.productType == 1 {
            priceLabel.text = "学点\(model.basicPrice.toString())"
        }else{
            priceLabel.text = "¥ \(model.basicPrice.toString())"
        }
        thumbImageView.loadImage(string: model.imageURL)
        likeNumberButton.setTitle("\(model.likeCount.toString())人喜欢", for: .normal)
        buyNumberButton.setTitle("\(model.buyCount.toString())人购买", for: .normal)
        
        if let shareModel = model.activityMap, let _ = shareModel.activityCategoryName.emptyToNil() {
            shareButton.isHidden = false
            shareButton.setTitle(model.activityMap?.activityAbbreviation ?? "分享", for: .normal)
        } else {
            shareButton.isHidden = true
        }
        
        if model.courseType == 0 {
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        self.configRectCorner(view: self.productTypeImgView, corner: [.bottomRight], radii: CGSize(width: 5, height: 5))
    }
    
    lazy var btn : UIButton = {
        var btn = UIButton.init()
        btn.setImage(UIImage.init(named: "player_play_btn"), for: .normal)
        btn.setBackgroundColor(UIColor.clear, forState: .normal)
        return btn
    }()
    
    @objc func shareButtonClick() {
        LoginHelper.checkLoginStatus {
            self.getInviteCode()
        }
    }
    
    func requestShare() {
        guard let model = self.model else {
            return
        }
        var urlString = "http://www.cei.net.cn/mobile/cdetail?id=\(model.productID)"
        if let inviteCode = self.inviteModel?.code.emptyToNil() {
            urlString.append("&invitationCode=\(inviteCode)")
        }
        var image = self.thumbImageView.image
        var contentType: SSDKContentType = .webPage
        if let base64String = self.inviteModel?.code, let inviteImage = base64String.base64StringImage() {
            image = inviteImage
            contentType = .image
        }
        
        ShareHelper.customShare(url: URL(string: urlString)!, image: image, title: self.model?.name, content: self.model?.name, contentType: contentType)
    }
    
    func getInviteCode() {
        if let model = inviteModel {
            requestShare()
            return
        }
        guard let activityID = self.model?.activityMap?.activityID.string.emptyToNil(), let productID = self.model?.productID else {
            HUD.showError(error: "没有活动")
            return
        }
        UserHelper.shared.getInviteCode(activityID: activityID, productID: productID.string)
            .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.inviteModel = result.data
                self.requestShare()
            })
            .disposed(by: disposeBag)
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
