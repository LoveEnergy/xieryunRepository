//
//  ProductCouponListView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/10.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Segmentio

class ProductCouponListView: UIView {
    let disposeBag: DisposeBag = DisposeBag()
    public var confirmOrderControllerNewCouponModelBlock:((NewCouponList)->())?
    public var productCouponListViewDismissBlock:(()->())?//消失
    var confirmControllerBool: Bool = false //判断是否从确认订单页来
    var array : [NewCouponList] = [NewCouponList]()
    lazy var tableView : UITableView = {
        var tableViewY = 180/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: tableViewY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - tableViewY))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(ProductCouponListViewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ProductCouponListViewTableViewCell.self))
        return tableView
    }()
    lazy var headerView : UIView = {[weak self] in
        var headerView = UIView.init(frame : CGRect(x: 0, y: self!.tableView.top - 50/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        headerView.addSubview(self!.titleLab)
        self?.titleLab.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: headerView.height)
        let btnH = 22.5/WIDTH_6_SCALE
        let cancelBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 15/WIDTH_6_SCALE - btnH, y: 0, width: btnH, height: btnH))
        cancelBtn.titleLabel?.font = DEF_FontSize_14
        cancelBtn.setBackgroundColor(.white, forState: .normal)
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        cancelBtn.centerY = headerView.height/2
        cancelBtn.setImage(UIImage.init(named: "circle_close"), for: .normal)
        headerView.addSubview(cancelBtn)
//        let lineView = UIView.init(frame: CGRect(x: 0, y: headerView.height - 1, width: SCREEN_WIDTH, height: 1))
//        lineView.backgroundColor = UIColor.colorWithHex(hex: "bcc0c1")
//        headerView.addSubview(lineView)
        return headerView
    }()
    
    lazy var titleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_18
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "优惠券"
        return titleLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.tableView)
        self.addSubview(self.headerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductCouponListView{
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func dismissView(){
        self.productCouponListViewDismissBlock!()
    }
    
    @objc func cancelBtnClick(){
        self.dismissView()
    }
}

extension ProductCouponListView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ProductCouponListViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ProductCouponListViewTableViewCell.self)) as! ProductCouponListViewTableViewCell
        if self.confirmControllerBool == false {
            cell.couponListModel = self.array[indexPath.row]
        }else{
            cell.confirmCouponListModel = self.array[indexPath.row]
        }
        cell.couponBtnClickBlock = {
            if self.confirmControllerBool == false {
                HUD.loading(text: "")
                UserHelper.shared.saveUserCoupon(promotionCouponDetialID: self.array[indexPath.row].promotionCouponDetialID).asObservable() .subscribe(onNext: {[weak self] (list) in
                    HUD.hideLoading()
                    guard let `self` = self else { return }
                    let baseModel: BaseModel = list
                    if baseModel.code == 200{
                        HUD.showText(text: "领取成功")
                    }else{
                        HUD.showError(error: baseModel.message!)
                    }
                }).disposed(by: self.disposeBag)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 105/WIDTH_6_SCALE
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.confirmControllerBool == true {
            self.confirmOrderControllerNewCouponModelBlock?(self.array[indexPath.row])
        }
    }
}
