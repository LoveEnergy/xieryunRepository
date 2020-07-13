//
//  OrderTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/17.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OrderTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    public var applePayBlock:((Int, String, Int, CGFloat, String)->())?//苹果价格, 是否成功的code、返回message、orderID、submitPrice、productName
    
    public var showHUDViewBlock:(()->())?//显示大菊花
    var orderID : Int = 0
    var orderStatus: Int = 0
    var objectType: Int = 0
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderNumberlLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    var model: OrderModel?
    
    var goods: Variable<[OrderGoodsModel]> = Variable([])
    
    let disposeBag = DisposeBag()
    
    public var leapPageBlock : ((Int, Int) -> ())?//跳页
    @objc func clickCollectionView(){
        self.leapPageBlock?(self.orderID, self.orderStatus)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(R.nib.orderGoodsCollectionViewCell)
        collectionView.backgroundColor = UIColor.backgroundColor
        collectionView.delegate = self
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(clickCollectionView))
        collectionView.addGestureRecognizer(tap)
        
        // Initialization code
        goods.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: R.nib.orderGoodsCollectionViewCell.identifier, cellType: OrderGoodsCollectionViewCell.self)){ _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        payButton.addTarget(self, action: #selector(payOrder), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            super.setSelected(false, animated: true)
        }
        // Configure the view for the selected state
    }
    
    func configure(model: OrderModel) {
        self.model = model
        timeLabel.text = model.createTime
        totalPriceLabel.text = model.price.toString()
        orderNumberlLabel.text = "订单号：\(model.poNumber)"
        goods.value = model.detailList
        self.orderStatus = model.status
        self.orderID = model.orderID
        self.objectType = model.objectType
        if let status = OrderStatus(rawValue: model.status) {
            switch status {
            case .payed:
                self.statusLabel.text = "已支付"
                self.cancelButton.isHidden = true
                self.deleteButton.isHidden = false
                self.payButton.isHidden = true
            case .unpay:
                self.statusLabel.text = "待支付"
                self.deleteButton.isHidden = true
                self.payButton.isHidden = false
                self.cancelButton.isHidden = false
            case .finished:
                self.statusLabel.text = "已完成"
                self.cancelButton.isHidden = true
                self.deleteButton.isHidden = false
                self.payButton.isHidden = true
            case .canceled:
                self.statusLabel.text = "已取消"
                self.cancelButton.isHidden = true
                self.deleteButton.isHidden = false
                self.payButton.isHidden = true
            }
//            deleteButton.isHidden = true
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 30)/3, height: self.collectionView.height)
    }
    
    @objc func cancelOrder() {
        guard let id = self.model?.orderID else {
            HUD.showError(error: "没有订单id")
            return
        }
        UserHelper.shared.updateOrderStatus(orderID: id, status: 4)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.showText(text: "取消成功")
                    OrderManager.shared.refreshSignal.onNext(())
                })
            }, onError: { (error) in
                
            })
        .disposed(by: disposeBag)
    }
    
    @objc func deleteOrder() {
        guard let id = self.model?.orderID else {
            HUD.showError(error: "没有订单id")
            return
        }
        UserHelper.shared.deleteOrder(orderID: id)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.showText(text: "删除成功")
                    OrderManager.shared.refreshSignal.onNext(())
                })
                }, onError: { (error) in
                    
            })
            .disposed(by: disposeBag)
    }
    
    @objc func payOrder() {
        guard let id = self.model?.orderID.string else {
            HUD.showError(error: "没有订单id")
            return
        }
        let vc = R.storyboard.cart.payOrderViewController()!
        let vm = OrderPayViewModel(orderID: id)
        vc.bindViewModel(viewModel: vm)
        vc.productType = (self.model?.detailList[0].productType)!
        vc.objectType = self.objectType
        let productNum = self.model?.detailList.count
        if (self.model?.detailList.count)! > 1 {
            var productIDsArr: [String] = [String]()
            for num in 0...productNum! - 1 {
                let tempString = "\((self.model?.detailList[num].productID)!)"
                productIDsArr.append(tempString)
            }
            let result = productIDsArr.joined(separator: ",")
            UserHelper.shared.getPayOrderStatus(productIDs: result).asObservable().subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            if list != nil{
                if list.code == 200{
                    vc.productType = 0
                    CurrentControllerHelper.pushViewController(viewController: vc)
                }else{
                    //苹果价格, 是否成功的code、返回message、orderID、submitPrice、productName
                    self.applePayBlock!(1, list.message, self.orderID, self.model!.price, self.model!.detailList[0].productName)
                }
            }
        }).disposed(by: self.disposeBag)
        }else{
            UserHelper.shared.getPayOrderStatus(productIDs: "\((self.model?.detailList[0].productID)!)").asObservable().subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list != nil{
                    if list.code == 200{
                        if vc.productType == 1{
                            //走苹果内购
                            self.showHUDViewBlock!()
                            IAPHandler.shared.purchase(RegisteredPurchase(rawValue: self.model!.applePayID)!, atomically: true)
                                IAPHandler.shared.purchaseStatusBlock = { status in
                                    if status == .purchased{
                                        let defaultStand = UserDefaults.standard
                                        let defaultKey = "receipt"
                                        let receiptString = defaultStand.value(forKey: defaultKey) as! String
                                        let receiptDic = self.stringValueDic(receiptString)
                                        UserHelper.shared.getIOSOrderStatusString(poNumber: self.model!.poNumber, receipt_data: receiptString).asObservable() .subscribe(onNext: {[weak self] (list) in
                                            guard let `self` = self else { return }
                                            let baseModel: BaseModel = list
                                            self.applePayBlock!(baseModel.code, baseModel.message!, self.orderID, self.model!.price, self.model!.detailList[0].productName)
                                        }).disposed(by: self.disposeBag)
                                    }else{
                                        self.applePayBlock!(0, "购买失败", self.orderID, self.model!.price, self.model!.detailList[0].productName)
                                    }
                                }
                        }else{
                            vc.objectType = self.objectType
                            if self.model?.detailList[0].productType == 2 || self.model?.detailList[0].productType == 4 {
                                UserHelper.shared.getOrderDetail(orderID: self.orderID).asObservable().subscribe(onNext: {[weak self] (result) in
                                    guard let `self` = self else { return }
                                    if result.code == 200{
                                        vc.addressString = result.data?.addressInfo?.address as! String
                                        vc.productName = result.data?.orderDetailList[0].productName as! String
                                        CurrentControllerHelper.pushViewController(viewController: vc)
                                    }else{
                                        HUD.showText(text: result.message!)
                                    }
                                    }, onError: { (error) in
                                        HUD.showText(text: error.localizedDescription)
                                }).disposed(by: self.disposeBag)
                            }else{
                                CurrentControllerHelper.pushViewController(viewController: vc)
                            }
                        }
                    }else{
                        self.applePayBlock!(1, "购买失败", self.orderID, self.model!.price, self.model!.detailList[0].productName)
                    }
                }
            }).disposed(by: self.disposeBag)
        }
    }
    
    // MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [String : Any]?{
         let data = str.data(using: String.Encoding.utf8)
         if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
             return dict
         }
         return nil
     }
    
}

