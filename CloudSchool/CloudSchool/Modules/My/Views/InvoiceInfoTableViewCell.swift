//
//  InvoiceInfoTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/20.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

protocol InvoiceInfoTableViewCellDelegate: class {
    func editInvoice(model: InvoiceInfoModel)
    func deleteInvoice(model: InvoiceInfoModel)
}

class InvoiceInfoTableViewCell: UITableViewCell, CellMappable {
    
    

    typealias Model = InvoiceInfoModel
    
    @IBOutlet weak var defaultButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: InvoiceInfoTableViewCellDelegate?
    var model: InvoiceInfoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        defaultButton.isHidden = true
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: InvoiceInfoModel) {
        self.model = model
        nameLabel.text = ""
        addressLabel.text = ""
        if model.invoiceRise == 1{//1、个人  2、公司
            actionButton.addTarget(self, action: #selector(personalActionClick), for: .touchUpInside)
            self.nameLabel.text = "电子邮箱:\(model.email)"
        }else{
            nameLabel.text = "单位名称:\(model.companyName)"
            addressLabel.text = "纳税人识别码:\(model.taxpayerNo)"
            actionButton.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
        }
    }
    
    
    
    @objc func actionClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (action) in
            if let model = self.model {
                self.delegate?.editInvoice(model: model)
            }
        }
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (action) in
            if let model = self.model {
                self.delegate?.deleteInvoice(model: model)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        CurrentControllerHelper.presentViewController(viewController: alert)
    }
    
    @objc func personalActionClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (action) in
            if let model = self.model {
                self.delegate?.deleteInvoice(model: model)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        CurrentControllerHelper.presentViewController(viewController: alert)
    }
    
}
