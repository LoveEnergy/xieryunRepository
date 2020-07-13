//
//  OrderDetailViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/7.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OrderDetailViewController: UIViewController {
    var orderID: Int = 0 {
        didSet {
            self.loadData()
        }
    }
    let disposeBag = DisposeBag()
    
    //订单状态
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBOutlet weak var statusView: UIView!
    
    @IBOutlet weak var orderTimeLabel: UILabel!
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderNumberView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var LogisticsBtn: UIButton!
    //发票类型
    @IBOutlet weak var invoiceTypeLabel: UILabel!
    //发票抬头
    @IBOutlet weak var invoiceTitleLabel: UILabel!
    //发票内容
    @IBOutlet weak var invoiceContent: UILabel!
    
    //处理订单
    @IBOutlet weak var orderDealView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var invoiceView: UIView!
    
    @IBOutlet weak var payMethodView: UIView!
    
    @IBOutlet weak var payMethodLabel: UILabel!
    
    lazy var logisticsTitleLab : UILabel = {
        var logisticsTitleLab = UILabel.init()
        logisticsTitleLab.font = DEF_FontSize_14
        logisticsTitleLab.backgroundColor = .clear
        logisticsTitleLab.textColor = .black
        logisticsTitleLab.textAlignment = .left
        logisticsTitleLab.text = ""
        logisticsTitleLab.lineBreakMode = .byWordWrapping
        logisticsTitleLab.numberOfLines = 0
        return logisticsTitleLab
    }()
    lazy var logisticsTimeLab : UILabel = {
        var logisticsTimeLab = UILabel.init()
        logisticsTimeLab.font = DEF_FontSize_14
        logisticsTimeLab.backgroundColor = .clear
        logisticsTimeLab.textColor = .black
        logisticsTimeLab.textAlignment = .left
        logisticsTimeLab.text = ""
        logisticsTimeLab.lineBreakMode = .byWordWrapping
        logisticsTimeLab.numberOfLines = 0
        return logisticsTimeLab
    }()
    
    var selectedArray: [CartGoodsModel] = []
    var productType: Int = 0
    var orderStatus: Int = 0
    var status: Int = 0
    var goodsStatus: Int = 0
    var courierNumber: String = ""//快递单号
    var carrierID: String = ""//承运商ID
    var productImgURL: String = ""//商品图片
    var carrierPhone: String = ""//官方电话
    var carrierServer: String = ""//快递商
    var objectType: Int = 0
    var productAddressModel: AddressModel?
    var model: OrderDetailModel? {
        didSet {
            self.selectedArray = model?.orderDetailList ?? []
            self.configureViews()
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    var totalPrice: CGFloat = 0.0
    var discountPrice: CGFloat = 0.0
    var selectedAddress: AddressModel?
    var showAddress: Bool = true
    var priceInfoArray: [OrderPriceInfo] = []
    let priceInfoView = OrderPriceDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "订单详细"
        self.scrollView.backgroundColor = UIColor.backgroundColor
        payButton.addTarget(self, action: #selector(payOrder), for: .touchUpInside)
        cancelButton.addTarget(self, action: #selector(cancelOrder), for: .touchUpInside)
        deleteButton.addTarget(self, action: #selector(deleteOrder), for: .touchUpInside)
        LogisticsBtn.addTarget(self, action: #selector(LogisticsBtnClick), for: .touchUpInside)
        OrderManager.shared.refreshSignal
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.loadData()
            })
        .disposed(by: disposeBag)
//        deleteButton.isHidden = true
    }
    
    func getCoupons() {
        guard selectedArray.count > 0 else { return }
        let ids = selectedArray.map { (model) -> String in
            return model.productID.string
        }
        RequestHelper.shared.getOrderCoupons(productIDs: ids)
            .subscribe(onNext: { (model) in
                
            }, onError: { (error) in
                
            })
            .disposed(by: disposeBag)
        
    }
    
    func configureViews() {
        guard let model = self.model else {
            return
        }
        //清空
        for subview in self.stackView.subviews {
            self.stackView.removeArrangedSubview(subview)
//            subview.isHidden = true
        }
        //订单状态
        self.statusLabel.text = OrderStatus(rawValue: model.status)?.description
        self.statusLabel.textColor = OrderStatus(rawValue: model.status)?.color ?? UIColor.subTitleColor
        stackView.addArrangedSubview(self.statusView)
        
        self.statusView.snp.remakeConstraints { (make) in
            make.height.equalTo(37)
        }
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        let infoView = OrderUserInfoView()
        stackView.addArrangedSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.height.equalTo(60)
        }
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        
        var showAddress = false
        for item in self.selectedArray {
            if item.type == 1 {
                showAddress = true
                break
            }
        }
        self.showAddress = showAddress
        if let address = model.addressInfo {
            let addressView = OrderAddressView()
            
            addressView.isUserInteractionEnabled = false
            addressView.address = address
            addressView.arrowImageView.isHidden = true
            stackView.addArrangedSubview(addressView)
            addressView.addressBlock = { address in
                self.selectedAddress = address
            }
            addressView.snp.makeConstraints { (make) in
                make.height.equalTo(60)
            }
            stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
            
        }
        
        if selectedArray.count > 0 {
            let tableView = GoodsTableView(frame: .zero, style: .plain)
            tableView.isScrollEnabled = false
            tableView.data = self.selectedArray
            tableView.fromPageName = "OrderDetailViewController"
            stackView.addArrangedSubview(tableView)
            
            tableView.snp.makeConstraints { (make) in
                make.height.equalTo(selectedArray.count * 90)
            }
        }
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        
        self.stackView.addArrangedSubview(self.orderNumberView)
        self.orderNumberLabel.text = "订单编号:\(model.number)"
        self.orderTimeLabel.text = "下单时间:\(model.createTime)"
        self.stackView.addArrangedSubview(self.payMethodView)
        //发票信息
        self.stackView.addArrangedSubview(self.invoiceView)
        self.invoiceTypeLabel.text = "发票类型：普通发票"
        self.invoiceTitleLabel.text = "发票抬头：个人"
        self.invoiceContent.text = "发票内容：商品明细"
        if let info = model.invoiceInfo {
            self.invoiceTypeLabel.text = "发票类型：电子发票"
            self.invoiceTitleLabel.text = "发票抬头：\(info.invoiceRise == 1 ? "个人" : "\(info.companyName) \n税号：\(info.taxpayerNo)")"
            
            self.invoiceContent.text = "发票内容：\(info.contentType == 1 ? "商品明细" : "商品类别")"
        }
        
//        self.payMethodLabel.text = model.status
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        
        stackView.addArrangedSubview(priceInfoView)
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        
        let logisticsView = UIView.init(frame: .zero)
        logisticsView.backgroundColor = .white
        stackView.addArrangedSubview(logisticsView)
        logisticsView.snp.makeConstraints { (make) in
            make.height.equalTo(120/WIDTH_6_SCALE)
        }
        logisticsView.addSubview(self.logisticsTimeLab)
        logisticsTimeLab.frame = CGRect(x: 15, y: 10, width: SCREEN_WIDTH - 30, height: 20/WIDTH_6_SCALE)
        logisticsView.addSubview(self.logisticsTitleLab)
        logisticsTitleLab.frame = CGRect(x: 15, y: logisticsTimeLab.bottom + 10, width: SCREEN_WIDTH - 30, height: 60/WIDTH_6_SCALE)
        //处理订单按钮
        stackView.addArrangedSubview(self.orderDealView)
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
        }
    }
    
    func loadData() {
        UserHelper.shared.getOrderDetail(orderID: self.orderID)
        .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.model = result.data
                self.productType = self.model?.productType ?? 0
                if result.code != 200{
                    HUD.loading(text: result.message!)
                    return
                }
                let orderDetailModel: OrderDetailModel = result.data!
                var tempCarrierID: Int = orderDetailModel.carrierID
                var tempCourierNumber = orderDetailModel.courierNumber
                var tempStatus = orderDetailModel.status
                var tempGoodsStatus = orderDetailModel.goodsStatus
                self.status = tempStatus
                self.goodsStatus = tempGoodsStatus
                self.courierNumber = tempCourierNumber
                self.carrierID = "\(tempCarrierID)"
                self.carrierPhone = orderDetailModel.carrierPhone
                self.carrierServer = orderDetailModel.carrier
                let typeModel: CartGoodsModel = self.model!.orderDetailList[0]
                self.productType = typeModel.productType
                self.productImgURL = typeModel.previewImgUrl
                if self.orderStatus == 1{
                    self.LogisticsBtn.isHidden = false
                    self.productAddressModel = self.model!.addressInfo
                }
                if self.productType == 2 || self.productType == 4{
                    self.LogisticsBtn.isHidden = false
                    self.productAddressModel = self.model!.addressInfo
                }else{
                    self.LogisticsBtn.isHidden = true
                }
                if tempCarrierID != 0 {
                    UserHelper.shared.getLogisticsData(status: tempStatus, productType: self.productType, goodsStatus: tempGoodsStatus, carrierID: tempCarrierID, courierNumber: tempCourierNumber).asObservable().subscribe(onNext: {[weak self] (result) in
                        guard let `self` = self else { return }
                        let baseInfoModel: BaseInfoModel = result
                        let dataModel: LogisticsModel = baseInfoModel.data!
                        if dataModel.Traces.count > 0{
                            let lastDetail: LogisticsDetailModel = dataModel.Traces[dataModel.Traces.count - 1]
                            self.logisticsTimeLab.text = lastDetail.AcceptTime
                            self.logisticsTitleLab.text = lastDetail.AcceptStation
                        }else{
                            self.logisticsTimeLab.isHidden = true
                            self.logisticsTitleLab.isHidden = true
                        }
                    }, onError: { (error) in
                        HUD.showText(text: error.localizedDescription)
                    }).disposed(by: self.disposeBag)
                }else{
                    self.logisticsTimeLab.isHidden = true
                    self.logisticsTitleLab.isHidden = true
                }
                
            }, onError: { (error) in
                HUD.showText(text: error.localizedDescription)
            })
        .disposed(by: disposeBag)        
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
                    self.navigationController?.popViewController()
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
                    self.navigationController?.popViewController()
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
        vc.productType = self.productType
        vc.objectType = self.objectType
        if self.productType == 1{
            HUD.loading(text: "")
            IAPHandler.shared.purchase(RegisteredPurchase(rawValue: self.model!.applePayID)!, atomically: true)
            IAPHandler.shared.purchaseStatusBlock = { status in
                if status == .purchased{
                    let defaultStand = UserDefaults.standard
                    let defaultKey = "receipt"
                    let receiptString = defaultStand.value(forKey: defaultKey) as! String
                    let receiptDic = self.stringValueDic(receiptString)
                    UserHelper.shared.getIOSOrderStatusString(poNumber: self.model!.poNumber, receipt_data: receiptString).asObservable() .subscribe(onNext: {[weak self] (list) in
                        HUD.hideLoading()
                        guard let `self` = self else { return }
                        let baseModel: BaseModel = list
                        if baseModel.code == 200{
                            //跳成功页面
                            let viewController = PaySuccessViewController.init()
                            viewController.orderID = "\(self.model!.orderID)"
                            viewController.productType = self.productType
                            viewController.objectType = self.objectType
                            viewController.productName = self.model?.orderDetailList[0].productName as! String
                            CurrentControllerHelper.pushViewController(viewController: viewController)
                        }else{
                            HUD.showText(text: baseModel.message!)
                        }
                    }).disposed(by: self.disposeBag)
                }else{
                    HUD.hideLoading()
                    HUD.showText(text: "购买失败")
                }
            }
        }else{
            vc.productType = 0
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
    
    @objc func LogisticsBtnClick(){
        let vc = LogisticsProcessViewController.init()
        vc.productType = self.productType
        vc.status = self.status
        vc.goodsStatus = self.goodsStatus
        vc.courierNumber = self.courierNumber
        vc.carrierID = self.carrierID
        vc.productImgURL = self.productImgURL
        vc.carrierPhone = self.carrierPhone
        vc.carrierServer = self.carrierServer
        vc.productAddressModel = self.productAddressModel
        CurrentControllerHelper.pushViewController(viewController: vc)
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
