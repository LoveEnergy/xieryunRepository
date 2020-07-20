//
//  ConfirmOrderTableViewCell.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/21.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import SwipeCellKit
import RxSwift
import RxCocoa

class ConfirmOrderTableViewCell: UITableViewCell {
    var showVipCouponChooseBtnBool: Bool = true
    var pageFromName: String = ""
    public var changeGoodsNumBlock:((Int)->())?//选择商品数量
    public var chooseCouponListViewBlock:(()->())?
    lazy var numberContainerView : UIView = {
        let viewW = 48.5/WIDTH_6_SCALE
        var numberContainerView = UIView.init(frame: CGRect(x: SCREEN_WIDTH - viewW - 20/WIDTH_6_SCALE, y: 56/WIDTH_6_SCALE, width: viewW, height: 32.5/WIDTH_6_SCALE))
        numberContainerView.backgroundColor = UIColor.clear
        return numberContainerView
    }()
    lazy var thumbImageView : UIImageView = {
        var thumbImageView = UIImageView.init(frame: CGRect(x: 12/WIDTH_6_SCALE, y: 0, width: 79.5/WIDTH_6_SCALE, height: 79.5/WIDTH_6_SCALE))
        thumbImageView.backgroundColor = UIColor.gray
        return thumbImageView
    }()
    lazy var numberTextField : UITextField = {
        var numberTextField = UITextField.init(frame: CGRect(x: 0, y: 0, width: self.numberContainerView.width, height: self.numberContainerView.height))
        numberTextField.backgroundColor = UIColor.colorWithHex(hex: "F5F5F5")
        numberTextField.textAlignment = .center
        numberTextField.font = DEF_FontSize_15
        numberTextField.layer.cornerRadius = 4
        numberTextField.layer.masksToBounds = true
        numberTextField.delegate = self
        return numberTextField
    }()
    lazy var plusButton : UIButton = {
        var plusButton = UIButton.init(frame: CGRect(x: self.numberTextField.right + 8/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        plusButton.titleLabel?.font = DEF_FontSize_14
        plusButton.setBackgroundColor(UIColor.clear, forState: .normal)
        plusButton.addTarget(self, action: #selector(plusButtonClick), for: .touchUpInside)
        plusButton.setImage(UIImage.init(named: "order_plus"), for: .normal)
        return plusButton
    }()
    lazy var minusButton : UIButton = {
        var minusButton = UIButton.init(frame: CGRect(x: 0, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        minusButton.titleLabel?.font = DEF_FontSize_14
        minusButton.setBackgroundColor(UIColor.clear, forState: .normal)
        minusButton.addTarget(self, action: #selector(minusButtonClick), for: .touchUpInside)
        minusButton.setImage(UIImage.init(named: "order_minus"), for: .normal)
        return minusButton
    }()
    lazy var priceLabel : UILabel = {
        var priceLabel = UILabel.init(frame: CGRect(x: self.numberContainerView.left - 100/WIDTH_6_SCALE, y: self.thumbImageView.bottom - 20/WIDTH_6_SCALE, width: 80/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        priceLabel.font = DEF_FontSize_16
        priceLabel.backgroundColor = .clear
        priceLabel.textColor = UIColor.colorWithHex(hex: "FF3333")
        priceLabel.textAlignment = .right
        priceLabel.text = "￥aaa"
        return priceLabel
    }()
    lazy var nameLabel : UILabel = {
        var nameLabel = UILabel.init(frame: CGRect(x: 7/WIDTH_6_SCALE + self.thumbImageView.right, y: self.thumbImageView.top + 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - self.thumbImageView.right - 14/WIDTH_6_SCALE, height: self.numberContainerView.top - self.thumbImageView.top - 10/WIDTH_6_SCALE))
        nameLabel.font = DEF_FontSize_14
        nameLabel.backgroundColor = .clear
        nameLabel.textColor = .black
        nameLabel.textAlignment = .left
        nameLabel.text = "aaa"
        nameLabel.numberOfLines = 0
        nameLabel.lineBreakMode = .byWordWrapping
        return nameLabel
    }()
    
    lazy var couponChooseBtn : UIButton = {
        var couponChooseBtn = UIButton.init(frame: CGRect(x: self.nameLabel.left, y: 0, width: 120/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        couponChooseBtn.centerY = self.priceLabel.centerY
        couponChooseBtn.setTitle("不使用优惠券", for: .normal)
        couponChooseBtn.setTitleColor(UIColor.black, for: .normal)
        couponChooseBtn.titleLabel?.font = DEF_FontSize_12
        couponChooseBtn.setBackgroundColor(UIColor.colorWithHex(hex: "F4F5F6"), forState: .normal)
        couponChooseBtn.layer.cornerRadius = 2
        couponChooseBtn.layer.masksToBounds = true
        couponChooseBtn.layer.borderWidth = 0.8
        couponChooseBtn.layer.borderColor = UIColor.gray.cgColor
        couponChooseBtn.addTarget(self, action: #selector(couponChooseBtnClick(btn:)), for: .touchUpInside)
        return couponChooseBtn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(self.numberContainerView)
        self.contentView.addSubview(self.thumbImageView)
        self.contentView.addSubview(self.nameLabel)
        self.contentView.addSubview(self.priceLabel)
        self.numberContainerView.addSubview(self.minusButton)
        self.numberContainerView.addSubview(self.numberTextField)
        self.numberContainerView.addSubview(self.plusButton)
        self.contentView.addSubview(self.couponChooseBtn)
        self.numberContainerView.centerY = self.priceLabel.centerY
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var currentNumber: Int = 0 {
            didSet {
                if currentNumber < 1 {
                    currentNumber = 1
                }
                self.numberTextField.text = currentNumber.toString()
                model?.count = currentNumber
            }
        }

    var isChoosed: Bool = false {
        didSet {
            guard let model = self.model else {
                return
            }
        }
    }

    var model: CartGoodsModel?

    let disposeBag = DisposeBag()
    
    @objc func minusButtonClick() {
        currentNumber -= 1
        self.changeGoodsNumBlock!(currentNumber)
    }

    @objc func plusButtonClick() {
        currentNumber += 1
        self.changeGoodsNumBlock!(currentNumber)
    }
    
    @objc func couponChooseBtnClick(btn: UIButton){
        print("优惠券")
        self.chooseCouponListViewBlock?()
    }
    
    func configure(model: CartGoodsModel) {
        self.model = model
        if model.discountCouponRate == 0 {
            self.couponChooseBtn.setTitle("不使用优惠券", for: .normal)
        }else{
            self.couponChooseBtn.setTitle("\(model.discountCouponRate)折优惠", for: .normal)
        }
        model.isChoosed.asObservable()
            .subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.isChoosed = value
            })
        .disposed(by: disposeBag)
        currentNumber = model.count
        thumbImageView.loadImage(string: model.thumbnailUrl)
        nameLabel.text = model.productName
        numberTextField.text = "*\(model.count.toString())"
        if model.type == 1{
            priceLabel.text = "学点\(model.price.toString())"
            if self.pageFromName == "cartViewController" {
                priceLabel.text = "学点\(model.price.toString())"
            }
        }else{
            priceLabel.text = "￥\(model.price.toString())"
        }
        numberContainerView.isHidden = true
        if model.type == 2{
            numberContainerView.isHidden = false
        }
    }
}

extension ConfirmOrderTableViewCell: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        weak var weakSelf = self
        //判断输入的是否是数字 否则无效
        var cs = CharacterSet();
        // 获取除以下数字所有的字符集合
        cs = CharacterSet(charactersIn: "0123456789").inverted;
        let filterArr = string.components(separatedBy: cs);
        let filtered = filterArr.joined(separator: "")
        if filtered != string{
            return false
        }else{
            if textField.text!.count == 1 {
                if string == ""{
                    return false
                }else{
                    weakSelf?.changeGoodsNumBlock!(Int(textField.text! + string)!)
                }
            }else{
                if string == ""{
                    weakSelf?.changeGoodsNumBlock!(Int(textField.text!.prefix((textField.text?.count)! - 1))!)
                }else{
                    weakSelf?.changeGoodsNumBlock!(Int(textField.text! + string)!)
                }
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text == "" || textField.text?.count == 0{
            textField.text = "1"
        }
    }
}
