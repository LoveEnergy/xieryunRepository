//
//  InvoiceView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class InvoiceView: UIView, XibLoadable, BottomPopable {
    
    var autoDismiss: Bool {
        return false
    }
    
    var viewHeight: CGFloat {
        return kScreenHeight * 0.8
    }
    
    enum InvoiceType {
        case personal
        case company
        
        var description: String {
            switch self {
            case .personal:
                return "个人"
            case .company:
                return "公司"
            }
        }
        
        var riseType: Int {
            switch self {
            case .personal:
                return 1
            case .company:
                return 2
            }
        }
    }
    
    enum InvoiceContentType: Int {
        case detail = 1
        case classify = 2
        
        var description: String {
            switch self {
            case .detail:
                return "商品明细"
            case .classify:
                return "商品分类"
            }
        }
        
    }
    
    var invoiceString: String {
        return "\(self.invoiceType.description)-\(self.invoiceContent.description)"
    }
    
    var invoiceType: InvoiceType = InvoiceType.personal
    var invoiceContent: InvoiceContentType = InvoiceContentType.detail
    
    @IBOutlet weak var invoiceTypeButton: TagButton!
    @IBOutlet weak var invoiceTipButton: UIButton!
    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var goodsTypeButton: TagButton!
    @IBOutlet weak var goodsDetailButton: TagButton!
    @IBOutlet weak var companyButton: TagButton!
    @IBOutlet weak var personButton: TagButton!
    
    @IBOutlet weak var companyNumberContainerView: UIView!
    @IBOutlet weak var companyNameContainerView: UIView!
    
    @IBOutlet weak var companyCodeTextfield: UITextField!
    @IBOutlet weak var companyTextField: UITextField!
    let disposeBag = DisposeBag()
    var contentBlock:((String) -> Void)?
    
    var invoiceID: String?
    var invoiceModel: InvoiceInfoModel? {
        didSet {
            guard let model = invoiceModel else {
                return
            }
            companyTextField.text = model.companyName
            companyCodeTextfield.text = model.taxpayerNo
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        baseConfigure()
        buttonResponse()
    }
    
    func baseConfigure() {
        titleLabel.text = "发票"
        detailButton.setTitle("发票须知", for: .normal)
        sureButton.setTitle("确认", for: .normal)
        
        titleLabel.textColor = UIColor.titleColor
        detailButton.setTitleColor(UIColor.lightTitleColor, for: .normal)
        closeButton.addTarget(self, action: #selector(closeClick), for: .touchUpInside)
        
        sureButton.setTitleColor(UIColor.white, for: .normal)
        sureButton.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        sureButton.addTarget(self, action: #selector(sureButtonClick), for: .touchUpInside)
        invoiceTipButton.pborderColor = UIColor.mainRedColor
        invoiceTipButton.pborderWidth = 0.5
        invoiceTipButton.round()
        invoiceTipButton.setTitleColor(UIColor.mainRedColor, for: .normal)
        invoiceTipButton.titleLabel?.numberOfLines = 0
        
        invoiceTypeButton.isSelected = true
        personButton.isSelected = true
        companyNameContainerView.isHidden = true
        companyNumberContainerView.isHidden = true
    }
    
    
    
    func buttonResponse() {
        let type = Observable.merge([(personButton.rx.tap).map{ return InvoiceType.personal },
                                     (companyButton.rx.tap).map{ return InvoiceType.company }])
            .map { (value) -> Bool in
                return value == .personal
        }
        type.bind(to: companyNameContainerView.rx.isHidden).disposed(by: disposeBag)
        type.bind(to: companyNumberContainerView.rx.isHidden).disposed(by: disposeBag)
        type.bind(to: personButton.rx.isSelected).disposed(by: disposeBag)
        type.map { !$0 }.bind(to: companyButton.rx.isSelected).disposed(by: disposeBag)
        type.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.invoiceType = value ? InvoiceType.personal : InvoiceType.company
            })
        .disposed(by: disposeBag)
        
        let contentType = Observable.merge([(goodsTypeButton.rx.tap).map{ return InvoiceContentType.classify },
                                     (goodsDetailButton.rx.tap).map{ return InvoiceContentType.detail }])
            .map { (value) -> Bool in
                return value == InvoiceContentType.classify
        }
        contentType.bind(to: goodsTypeButton.rx.isSelected).disposed(by: disposeBag)
        contentType.map { !$0 }.bind(to: goodsDetailButton.rx.isSelected).disposed(by: disposeBag)
        contentType.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.invoiceContent = value ? InvoiceContentType.detail : InvoiceContentType.classify
            })
            .disposed(by: disposeBag)
    }
    
    @objc func closeClick() {
        self.popDismiss()
    }
    
    @objc func sureButtonClick() {
        if self.invoiceType == .personal {
            self.contentBlock?(self.invoiceString)
            self.popDismiss()
            return
        }
        guard let companyString = self.companyTextField.text?.emptyToNil() else {
            HUD.showError(error: "请填写公司名称")
            return
        }
        guard let companyCode = self.companyCodeTextfield.text?.emptyToNil() else {
            HUD.showError(error: "纳税人识别码")
            return
        }
        
        if let model = self.invoiceModel {
            UserHelper.shared.updateInvoice(invoiceID: model.invoiceID.string, invoiceType: 1, invoiceRise: self.invoiceType.riseType, companyName: companyString, taxpayerNo: companyCode, contentType: self.invoiceContent.rawValue.string)
                .asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    guard let `self` = self else { return }
                    result.errorDeal(successBlock: {
                        self.invoiceID = result.data?.invoiceID.string
                        let invoiceString = self.invoiceString.replacingOccurrences(of: "公司", with: companyString)
                        
                        self.contentBlock?(invoiceString)
                        self.popDismiss()
                    })
                    
                    }, onError: { (error) in
                        
                })
                .disposed(by: disposeBag)
        } else {
            UserHelper.shared.saveInvoice(invoiceType: 1, invoiceRise: self.invoiceType.riseType, companyName: companyString, taxpayerNo: companyCode, contentType: self.invoiceContent.rawValue.string, email: "")
                .asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    guard let `self` = self else { return }
                    result.errorDeal(successBlock: {
                        self.invoiceID = result.data?.invoiceID.string
                        let invoiceString = self.invoiceString.replacingOccurrences(of: "公司", with: companyString)
                        
                        self.contentBlock?(invoiceString)
                        self.popDismiss()
                    })
                    
                    }, onError: { (error) in
                        
                })
                .disposed(by: disposeBag)
        }
        
        
        
    }

}
