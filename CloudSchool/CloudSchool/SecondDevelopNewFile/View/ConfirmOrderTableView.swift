//
//  ConfirmOrderTableView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/21.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ConfirmOrderTableView: UITableView {
    
    var controllerFromName: String = ""
    var showCouponSign: Bool = true//true显示优惠券   false隐藏优惠券
    public var showCouponListViewBlock:((ConfirmOrderTableViewCell, Int, Int)->())?//第一个参数：获取cell的位置用，第二个参数：产品ID， 第三个参数：indexpath
    public var goodsViewChangeGoodsNum:((Int, Int)->())?
    var data: [CartGoodsModel] = [] {
        didSet {
            self.reloadData()
        }
    }
    
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44/WIDTH_6_SCALE))
        headerView.backgroundColor = UIColor.clear
        let titleLab = UILabel.init(frame: CGRect(x: 11.5/WIDTH_6_SCALE, y: 14/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 16/WIDTH_6_SCALE))
        titleLab.text = "订单商品"
        titleLab.font = DEF_FontSize_15
        titleLab.textAlignment = .left
        headerView.addSubview(titleLab)
        return headerView
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        footerView.backgroundColor = UIColor.colorWithHex(hex: "F5F5F5")
        return footerView
    }()
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        self.delegate = self
        self.dataSource = self
        self.register(ConfirmOrderTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ConfirmOrderTableViewCell.self))
        self.tableFooterView = self.footerView
        self.tableHeaderView = self.headerView
    }
}

extension ConfirmOrderTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var weakSelf = self
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ConfirmOrderTableViewCell.self), for: indexPath) as! ConfirmOrderTableViewCell
        cell.pageFromName = self.controllerFromName
//        if self.data.count > 1 {
//            cell.showVipCouponChooseBtnBool = false
//        }
        cell.configure(model: data[indexPath.row])
        cell.changeGoodsNumBlock = {(goodsNum: Int) in
            weakSelf?.goodsViewChangeGoodsNum!(goodsNum, indexPath.row)
        }
        cell.plusButton.isHidden = true
        cell.minusButton.isHidden = true
        cell.numberTextField.isUserInteractionEnabled = false
        cell.chooseCouponListViewBlock = {()
            self.showCouponListViewBlock?(cell, self.data[indexPath.row].productID, indexPath.row)
        }
        if self.data.count > 1 {
            cell.couponChooseBtn.isHidden = true
            if self.showCouponSign == true && data[indexPath.row].vipPrice < 0 {
                cell.couponChooseBtn.isHidden = false
            }
        }else{
            if self.showCouponSign == true {
                cell.couponChooseBtn.isHidden = false
            }else{
                cell.couponChooseBtn.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 89.5/WIDTH_6_SCALE
    }
}
