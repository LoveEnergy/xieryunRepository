//
//  OrderAddressView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderAddressView: UIView {
    
    let disposeBag = DisposeBag()
    
    var addressBlock: ((AddressModel) -> (Void))?

    var addressLabel: UILabel = {
        let label = UILabel()
        label.text = "请选择收货地址"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.titleColor
        return label
    }()
    var locationImg: UIImageView = {
        let locationImg = UIImageView(image: UIImage.init(named: "location"))
        return locationImg
    }()
    var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.more_arrow())
        return imageView
    }()
    lazy var userNameLab : UILabel = {
        var userNameLab = UILabel.init()
        userNameLab.font = DEF_FontSize_14
        userNameLab.textColor = UIColor.titleColor
        userNameLab.textAlignment = .left
        return userNameLab
    }()
    lazy var detailAddressLab : UILabel = {
        var detailAddressLab = UILabel.init()
        detailAddressLab.font = DEF_FontSize_14
        detailAddressLab.textColor = UIColor.titleColor
        detailAddressLab.textAlignment = .left
        return detailAddressLab
    }()
    var address: AddressModel? {
        didSet {
            userNameLab.isHidden = false
            detailAddressLab.isHidden = false
            addressLabel.isHidden = true
            userNameLab.text = "\(address!.userName)       \(address!.phone)"
            detailAddressLab.text = address?.address
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        baseConfigure()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        backgroundColor = UIColor.white
        addSubview(arrowImageView)
        addSubview(addressLabel)
        addSubview(userNameLab)
        addSubview(detailAddressLab)
        addSubview(locationImg)
        userNameLab.isHidden = true
        detailAddressLab.isHidden = true
        locationImg.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(20/WIDTH_6_SCALE)
            make.width.equalTo(12/WIDTH_6_SCALE)
            make.height.equalTo(15/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        addressLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.locationImg.snp.right).offset(18/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-15)
            make.width.equalTo(7.5/WIDTH_6_SCALE)
            make.height.equalTo(12.5/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        userNameLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp.left)
            make.centerY.equalTo(self).offset(-10/WIDTH_6_SCALE)
            make.right.equalTo(arrowImageView.snp.left).offset(-5/WIDTH_6_SCALE)
        }
        detailAddressLab.snp.makeConstraints { (make) in
            make.left.equalTo(addressLabel.snp.left)
            make.centerY.equalTo(self).offset(10/WIDTH_6_SCALE)
            make.right.equalTo(arrowImageView.snp.left).offset(-5/WIDTH_6_SCALE)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAddress))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
    }
    
    @objc func chooseAddress() {
        let vc = R.storyboard.my.addressListViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
        
        vc.selectedAddress.asObservable()
            .skip(1)
            .do(onNext: { (model) in
                CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
            })
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                guard let model = model else { return }
                self.address = model
                
                self.addressBlock?(model)
            })
        .disposed(by: disposeBag)
        
    }


}
