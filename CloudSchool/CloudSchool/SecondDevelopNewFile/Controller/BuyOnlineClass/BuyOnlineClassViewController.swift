//
//  BuyOnlineClassViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/6/29.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BuyOnlineClassViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    var orderID: Int = 0
    var productPrice: String = ""
    var cellArray: [CartGoodsModel] = [CartGoodsModel]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    func setUpUI(){
        self.title = "学点支付"
        self.view.addSubview(self.tableView)
    }
    
    
    lazy var tableView : UITableView = {
        weak var weakSelf = self
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = UIColor.colorWithHex(hex: "F7F8F9")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(BuyOnlineClassTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(BuyOnlineClassTableViewCell.self))
        tableView.tableFooterView = self.footerView
        tableView.rowHeight = 93/WIDTH_6_SCALE
        return tableView
    }()
    
    lazy var footerView : UIView = {
        weak var weakSelf = self
        var footerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 300))
        footerView.backgroundColor = UIColor.clear
        footerView.addSubview(weakSelf!.footerWhiteView)
        footerView.addSubview(weakSelf!.submitBtn)
        return footerView
    }()
    lazy var footerWhiteView : UIView = {
        weak var weakSelf = self
        var footerWhiteView = UIView.init(frame: CGRect(x: 0, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 93/WIDTH_6_SCALE))
        footerWhiteView.backgroundColor = UIColor.white
        footerWhiteView.addSubview(weakSelf!.studyValueLab)
        footerWhiteView.addSubview(weakSelf!.lineView)
        footerWhiteView.addSubview(weakSelf!.orderNumLab)
        footerWhiteView.addSubview(weakSelf!.goForRechargeBtn)
        return footerWhiteView
    }()
    
    lazy var studyValueLab : UILabel = {
        var studyValueLab = UILabel.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 60/WIDTH_6_SCALE - 30/WIDTH_6_SCALE, height: 46/WIDTH_6_SCALE))
        studyValueLab.font = DEF_FontSize_16
        studyValueLab.backgroundColor = .clear
        studyValueLab.textColor = .black
        studyValueLab.textAlignment = .left
        studyValueLab.text = "剩余学点："
        return studyValueLab
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: 46/WIDTH_6_SCALE, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 1/WIDTH_6_SCALE))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "D8D8D8")
        return lineView
    }()
    lazy var orderNumLab : UILabel = {
        weak var weakSelf = self
        var orderNumLab = UILabel.init(frame: CGRect(x: (weakSelf?.studyValueLab.left)!, y: (weakSelf?.lineView.bottom)!, width: (weakSelf?.studyValueLab.width)!, height: (weakSelf?.studyValueLab.height)!))
        orderNumLab.font = DEF_FontSize_16
        orderNumLab.backgroundColor = .clear
        orderNumLab.textColor = .black
        orderNumLab.textAlignment = .left
        orderNumLab.text = "订单编号：          \(orderID)"
        return orderNumLab
    }()
    
    lazy var submitBtn : UIButton = {
        weak var weakSelf = self
        var submitBtn = UIButton.init(frame: CGRect(x: 0, y: (weakSelf?.footerWhiteView.bottom)! + 30, width: 280/WIDTH_6_SCALE, height: 40/WIDTH_6_SCALE))
        submitBtn.centerX = SCREEN_WIDTH/2
        submitBtn.setTitle("学点支付", for: .normal)
        submitBtn.setTitleColor(UIColor.white, for: .normal)
        submitBtn.titleLabel?.font = DEF_FontSize_16
        submitBtn.setBackgroundColor(UIColor.colorWithHex(hex: "4AA1F0"), forState: .normal)
        submitBtn.layer.cornerRadius = 20/WIDTH_6_SCALE
        submitBtn.layer.masksToBounds = true
        submitBtn.addTarget(self, action: #selector(submitBtnClick), for: .touchUpInside)
        return submitBtn
    }()
    
    lazy var goForRechargeBtn : UIButton = {
        weak var weakSelf = self
        let btnW = 60/WIDTH_6_SCALE
        var goForRechargeBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - btnW - 10/WIDTH_6_SCALE, y: (weakSelf?.studyValueLab.top)!, width: btnW, height: (weakSelf?.studyValueLab.height)!))
        goForRechargeBtn.setTitle("去充值", for: .normal)
        goForRechargeBtn.setTitleColor(UIColor.colorWithHex(hex: "FEAA5C"), for: .normal)
        goForRechargeBtn.titleLabel?.font = DEF_FontSize_14
        goForRechargeBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        goForRechargeBtn.addTarget(self, action: #selector(goForRechargeBtnClick), for: .touchUpInside)
        return goForRechargeBtn
    }()
    
    @objc func goForRechargeBtnClick(){
        let vc = MyAccountViewController.init()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func submitBtnClick(){
        HUD.loading(text: "")
        UserHelper.shared.studyCardPay(orderID: self.orderID).subscribe(onNext: { (model) in
            if model.code == 200{
                HUD.loading(text: "购买成功")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    HUD.hideLoading()
                    CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: false)
                    CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
                }
            }else if model.code == 6003{
                let vc = MyAccountViewController.init()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                HUD.hideLoading()
                HUD.showText(text: model.message)
            }
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription ?? "未知错误")
        }).disposed(by: disposeBag)
    }
    
    func getUserInfo(){
        HUD.loading(text: "")
        UserHelper.shared.getUserInfo()
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.hideLoading()
                    guard let user = model.data else { return }
                    self.studyValueLab.text = "剩余学点：          \(user.money)"
                })
                
                }, onError: { (error) in
            
            })
        .disposed(by: disposeBag)
    }
}

extension BuyOnlineClassViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(BuyOnlineClassTableViewCell.self), for: indexPath) as! BuyOnlineClassTableViewCell
        cell.model = self.cellArray[indexPath.row]
        if indexPath.row == cellArray.count - 1 {
            cell.lineView.isHidden = true
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellArray.count
    }
}
