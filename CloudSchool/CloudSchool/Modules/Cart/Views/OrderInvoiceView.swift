//
//  OrderInvoiceView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderInvoiceView: UIView {

    let disposeBag = DisposeBag()
    
    var invoiceID: String?
    var invoiceModel: InvoiceInfoModel? {
        didSet {
            guard let model = invoiceModel else {
                return
            }
            self.invoiceID = model.invoiceID.string
            self.detailLabel.text = model.invoiceString
            self.detailLabel.textColor = UIColor.colorWithHex(hex: "FF3333")
        }
    }
    public var whenNoInvoicePaperBlock:(()->())?
    var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "发票"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.colorWithHex(hex: "676767")
        return label
    }()
    
    var detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor.titleColor
        label.text = "选择发票类型"
        label.textAlignment = .right
        return label
    }()
    
    var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: R.image.more_arrow())
        return imageView
    }()
    
    var address: AddressModel? {
        didSet {
            titleLabel.text = address?.address
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .cyan
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
    }
    
    func baseConfigure() {
        backgroundColor = UIColor.white
        addSubview(titleLabel)
        addSubview(detailLabel)
        addSubview(arrowImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10.5/WIDTH_6_SCALE)
            make.height.equalTo(15/WIDTH_6_SCALE)
            make.width.equalTo(35/WIDTH_6_SCALE)
            make.centerY.equalTo(self)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(titleLabel)
            make.right.equalTo(arrowImageView.snp.left).offset(-13/WIDTH_6_SCALE)
            make.left.equalTo(self.titleLabel.snp.right)
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-13/WIDTH_6_SCALE)
            make.centerY.equalTo(self.titleLabel.snp.centerY)
            make.width.equalTo(7.5/WIDTH_6_SCALE)
            make.height.equalTo(12.5/WIDTH_6_SCALE)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(chooseAddress))
        self.addGestureRecognizer(tap)
        self.isUserInteractionEnabled = true
//        loadData()
    }
    
    func loadData() {
        UserHelper.shared.getInvoiceList()
            .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                if result.data.count > 0 {
                    self.invoiceModel = result.data.first
                }
            })
            .disposed(by: disposeBag)
    }
    
    @objc func chooseAddress() {
        let vc = R.storyboard.my.invoiceManageViewController()!
        vc.invoiceArrayNumBlock = {(num) in
            if num == 0 {
                self.whenNoInvoicePaperBlock!()
            }
        }
        CurrentControllerHelper.pushViewController(viewController: vc)
        vc.selectedInvoice.asObservable()
            .skip(1)
            .do(onNext: { (model) in
                CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
            })
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                guard let model = model else { return }
                self.invoiceModel = model
                UserDefaults.standard.setValue("\(model.invoiceID)", forKey: "InvoiceID")
            })
            .disposed(by: disposeBag)
//        let vc = SelectInvoiceTypeViewController.init()
//        vc.title = "发票填写"
//        CurrentControllerHelper.pushViewController(viewController: vc)
//
//        let view = InvoiceView.loadXib()
//        view.invoiceModel = self.invoiceModel
//        view.invoiceID = self.invoiceID
//        view.contentBlock = {[weak self] string in
//            guard let `self` = self else { return }
//            self.detailLabel.text = string
//            self.invoiceID = view.invoiceID
//            self.loadData()
//        }
//        view.bottomPopShow()
        
//        vc.selectedAddress.asObservable()
//            .skip(1)
//            .do(onNext: { (model) in
//                CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
//            })
//            .subscribe(onNext: {[weak self] (model) in
//                guard let `self` = self else { return }
//                self.address = model
//            })
//            .disposed(by: disposeBag)
        
    }

}
