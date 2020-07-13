//
//  CartTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift
import RxCocoa

class CartTableViewCell: SwipeTableViewCell {
    var fromPageName: String = ""
    @IBOutlet weak var numberContainerView: UIView!
    @IBOutlet weak var chooseButton: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var chooseButtonWidthConstraint: NSLayoutConstraint!
    var canEdit: Bool = true {
        didSet {
            chooseButtonWidthConstraint.constant = canEdit ? 40 : 0
//            numberContainerView.isHidden = canEdit ? false : true
            plusButton.isHidden = canEdit ? false : true
            minusButton.isHidden = canEdit ? false : true
        }
    }
    
    var currentNumber: Int = 0 {
        didSet {
            if currentNumber < 1 {
                currentNumber = 1
            }
            self.numberTextField.text = currentNumber.toString()
            model?.count = currentNumber
            CartHelper.shared.updateTotalPrice()
        }
    }
    
    var isChoosed: Bool = false {
        didSet {
            self.chooseButton.isSelected = isChoosed
            guard let model = self.model else {
                return
            }
            
            if isChoosed {
                CartHelper.shared.selectGoods(model: model)
            } else {
                CartHelper.shared.diselectGoods(model: model)
            }
        }
    }
    
    var model: CartGoodsModel?
    
    let disposeBag = DisposeBag()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        chooseButton.addTarget(self, action: #selector(chooseButtonClick), for: .touchUpInside)
        minusButton.addTarget(self, action: #selector(minusButtonClick), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        
        CartHelper.shared.selectAll
        .asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                guard let model = self.model else { return }
                model.isChoosed.value = value
            })
        .disposed(by: disposeBag)
    }
    
    @objc func chooseButtonClick() {
        guard let model = self.model else {
            return
        }
        model.isChoosed.value = !model.isChoosed.value
        
    }
    
    @objc func minusButtonClick() {
        currentNumber -= 1
        
    }
    
    @objc func plusButtonClick() {
        currentNumber += 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: CartGoodsModel) {
        self.model = model
        model.isChoosed.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.isChoosed = value
            })
        .disposed(by: disposeBag)
        currentNumber = model.count
        thumbImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
        numberTextField.text = model.count.toString()
        priceLabel.text = model.price.toString()
        
        if model.type == 1 {
            //产品类型（1、课程3、班级）
            
        } else if model.type == 3 {
//            numberContainerView.isHidden = true
            plusButton.isHidden = true
            minusButton.isHidden = true
        }
        if self.fromPageName == "OrderDetailViewController" {
            priceLabel.text = "￥\(model.price.toString())"
            numberTextField.text = "x  \(model.count.toString())"
        }
        if self.fromPageName == "CartViewController" {
            if model.type != 2 && model.type != 4 {
                plusButton.isHidden = true
                minusButton.isHidden = true
                numberTextField.text = "x  \(model.count.toString())"
            }else{
                plusButton.isHidden = false
                minusButton.isHidden = false
            }
        }
        if model.productType == 1{
            priceLabel.text = "学点\(model.price)"
            let string = priceLabel.text
            let ranStr = "学点"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
            let str = NSString(string: string!)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: theRange)
            priceLabel.attributedText = attrstring
        }else{
            priceLabel.text = "￥\(model.price)"
            let string = priceLabel.text
            let ranStr = "￥"
            let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
            let str = NSString(string: string!)
            let theRange = str.range(of: ranStr)
            attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 12), range: theRange)
            priceLabel.attributedText = attrstring
        }
    }
    
    @objc func delete() {
        guard let model = self.model else {
            HUD.showText(text: "没有数据")
            return
        }
        UserHelper.shared.deleteGoodsInCart(cardID: model.cardID.toString(), count: model.count.toString())
        .asObservable()
            .subscribe(onNext: { (result) in
                result.errorDeal(successBlock: {
                    self.isChoosed = false
                    CartHelper.shared.loadData()
                })
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
}


extension CartTableViewCell: SwipeTableViewCellDelegate {
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        guard canEdit else { return nil }
        let deleteAction = SwipeAction(style: .default, title: "删除") {[weak self] action, indexPath in
            self?.delete()
        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")
        deleteAction.backgroundColor = UIColor.mainRedColor
        deleteAction.textColor = UIColor.white
        return [deleteAction]
    }
}
