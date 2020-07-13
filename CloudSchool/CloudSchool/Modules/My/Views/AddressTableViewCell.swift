//
//  AddressTableViewCell.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import ObjectMapper

protocol AddressTableViewCellDelegate: class {
    func editAddress(model: AddressModel)
    func deleteAddress(model: AddressModel)
}

class AddressTableViewCell: UITableViewCell, CellMappable {
    typealias Model = AddressModel
    
    @IBOutlet weak var defaultButton: UIButton!
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    weak var delegate: AddressTableViewCellDelegate?
    var model: AddressModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        actionButton.addTarget(self, action: #selector(actionClick), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            self.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: AddressInfo) {
        
        nameLabel.text = model.userName
        phoneLabel.text = model.phone
        defaultButton.isHidden = !model.isDefault
        addressLabel.text = model.address
    }
    
    func configure(model: AddressModel) {
        self.model = model
        nameLabel.text = model.userName
        phoneLabel.text = model.phone
        defaultButton.isHidden = !model.isDefault
        addressLabel.text = model.address
    }
    
    @objc func actionClick() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "编辑", style: .default) { (action) in
            if let model = self.model {
                self.delegate?.editAddress(model: model)
            }
        }
        let deleteAction = UIAlertAction(title: "删除", style: .destructive) { (action) in
            if let model = self.model {
                self.delegate?.deleteAddress(model: model)
            }
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action) in
            
        }
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        CurrentControllerHelper.presentViewController(viewController: alert)
        
    }
    
}
