//
//  PaySuccessViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/26.
//  Copyright © 2020 CEI. All rights reserved.
//
//    productType: 1、在线课程  2、书籍  3、班级(objectType: 1、开课卡远程班  2、面授  3、付费远程班)  4、实物  5、直播课程
import UIKit
import RxSwift
import RxCocoa
class PaySuccessViewController: UIViewController, UINavigationControllerDelegate {
    var productType: Int = 0
    var objectType: Int = 0
    let btnH = 45/WIDTH_6_SCALE
    let disposeBag: DisposeBag = DisposeBag()
    var orderID: String = ""
    var submitPrice: CGFloat = 0.0
    var addressString: String = ""
    var productName: String = ""
    var qrCodeImageUrl: String = "" {
        didSet{
            if qrCodeImageUrl.isEmpty {
                self.weCahtNumLab.frame = CGRect(x: 0, y: (self.addQrCodeTitleLab.bottom) + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE)
                self.instructionLab.frame = CGRect(x: 0, y: (self.weCahtNumLab.bottom) + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE)
                self.qrCodeBGView.frame = CGRect(x: 0, y: self.lineView.bottom + 45/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: (self.instructionLab.bottom))
            }
        }
    }
    var wechatNumber: String = ""
    var model: OrderDetailModel?
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        headerView.backgroundColor = .white
        headerView.addSubview(self.successIconImg)
        headerView.addSubview(self.successTitleLab)
        headerView.addSubview(self.tipsLab)
        headerView.addSubview(self.orderIDLab)
        headerView.addSubview(self.moneyLab)
        headerView.addSubview(self.payWayLab)
        headerView.addSubview(self.lineView)
        headerView.addSubview(self.addressLab)
        headerView.addSubview(self.productTitleLab)
        headerView.addSubview(self.qrCodeBGView)
        headerView.addSubview(self.orderCheckBtn)
        headerView.addSubview(self.goOnBuyBtn)
        self.tipsLab.frame = CGRect(x: 0, y: 33/WIDTH_6_SCALE + successTitleLab.bottom, width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE)
        self.orderIDLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 25/WIDTH_6_SCALE + tipsLab.bottom, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 17/WIDTH_6_SCALE)
        self.moneyLab.frame = CGRect(x: self.orderIDLab.left, y: orderIDLab.bottom + 13/WIDTH_6_SCALE, width: self.orderIDLab.width, height: self.orderIDLab.height)
        self.addressLab.frame = CGRect(x: self.moneyLab.left, y: self.moneyLab.bottom + 13/WIDTH_6_SCALE, width: self.orderIDLab.width, height: self.orderIDLab.height)
        self.productTitleLab.frame = CGRect(x: self.addressLab.left, y: self.addressLab.bottom + 13/WIDTH_6_SCALE, width: self.orderIDLab.width, height: self.orderIDLab.height)
        self.lineView.frame = CGRect(x: 14.5/WIDTH_6_SCALE, y: 17.5/WIDTH_6_SCALE + self.productTitleLab.bottom, width: SCREEN_WIDTH - 29/WIDTH_6_SCALE, height: 1)
        self.qrCodeBGView.frame = CGRect(x: 0, y: self.lineView.bottom + 45/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: self.instructionLab.bottom)
        
        self.orderCheckBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: self.qrCodeBGView.bottom + 50/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: btnH)
        self.goOnBuyBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: self.orderCheckBtn.bottom + 24/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: 45/WIDTH_6_SCALE)
        self.payWayLab.isHidden = true
        
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.goOnBuyBtn.bottom + 50/WIDTH_6_SCALE)
        return headerView
    }()
    lazy var successIconImg : UIImageView = {
        let successIconImg = UIImageView.init(frame: CGRect(x: 0, y: 31.5/WIDTH_6_SCALE, width: 68.5/WIDTH_6_SCALE, height: 68.5/WIDTH_6_SCALE))
        successIconImg.image = UIImage.init(named: "pay_success")
        successIconImg.centerX = SCREEN_WIDTH/2
        return successIconImg
    }()
    lazy var successTitleLab : UILabel = {
        let successTitleLab = UILabel.init(frame: CGRect(x: 0, y: successIconImg.bottom + 23/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 20/WIDTH_6_SCALE))
        successTitleLab.font = DEF_FontSize_15
        successTitleLab.text = "订单支付成功！"
        successTitleLab.textColor = .black
        successTitleLab.textAlignment = .center
        return successTitleLab
    }()
    lazy var tipsLab : UILabel = {
        var tipsLab = UILabel.init()
        tipsLab.font = DEF_FontSize_12
        tipsLab.backgroundColor = .clear
        tipsLab.textColor = UIColor.colorWithHex(hex: "FF6434")
        tipsLab.textAlignment = .center
        tipsLab.text = "课程已开通，有效期从现在开始计算，请合理安排学习时间"
        tipsLab.lineBreakMode = .byWordWrapping
        tipsLab.numberOfLines = 0
        return tipsLab
    }()
    lazy var orderIDLab : UILabel = {
        var orderIDLab = UILabel.init()
        orderIDLab.font = DEF_FontSize_13
        orderIDLab.backgroundColor = .clear
        orderIDLab.textColor = UIColor.colorWithHex(hex: "686868")
        orderIDLab.textAlignment = .left
        orderIDLab.text = "订单编号： "
        return orderIDLab
    }()

    lazy var moneyLab : UILabel = {
        var moneyLab = UILabel.init()
        moneyLab.font = DEF_FontSize_13
        moneyLab.backgroundColor = .clear
        moneyLab.textColor = UIColor.colorWithHex(hex: "686868")
        moneyLab.textAlignment = .left
        moneyLab.text = "实付金额： 元"
        return moneyLab
    }()
    lazy var addressLab : UILabel = {
        var addressLab = UILabel.init()
        addressLab.font = DEF_FontSize_13
        addressLab.backgroundColor = .clear
        addressLab.textColor = UIColor.colorWithHex(hex: "686868")
        addressLab.textAlignment = .left
        addressLab.text = "收货地址： "
        return addressLab
    }()
    lazy var productTitleLab : UILabel = {
//        weak var weakSelf = self
        var productTitleLab = UILabel.init()
        productTitleLab.font = DEF_FontSize_13
        productTitleLab.backgroundColor = .clear
        productTitleLab.textColor = UIColor.colorWithHex(hex: "686868")
        productTitleLab.textAlignment = .left
        productTitleLab.text = "商品名称： "
        return productTitleLab
    }()
    lazy var payWayLab : UILabel = {
        var payWayLab = UILabel.init(frame: CGRect(x: self.orderIDLab.left, y: moneyLab.bottom + 13/WIDTH_6_SCALE, width: self.orderIDLab.width, height: self.orderIDLab.height))
        payWayLab.font = DEF_FontSize_13
        payWayLab.backgroundColor = .clear
        payWayLab.textColor = UIColor.colorWithHex(hex: "686868")
        payWayLab.textAlignment = .left
        payWayLab.text = "支付方式： "
        return payWayLab
    }()
    lazy var lineView : UIView = {
        var lineView = UIView.init()
        lineView.backgroundColor = UIColor.colorWithHex(hex: "ebebeb")
        return lineView
    }()
    lazy var qrCodeBGView : UIView = {
        weak var weakSelf = self
        var qrCodeBGView = UIView.init(frame: .zero)
        qrCodeBGView.backgroundColor = UIColor.clear
        qrCodeBGView.addSubview(self.teacherTouchLab)
        qrCodeBGView.addSubview(self.addQrCodeTitleLab)
        qrCodeBGView.addSubview(self.qrCodeImg)
        qrCodeBGView.addSubview(self.weCahtNumLab)
        qrCodeBGView.addSubview(self.instructionLab)
        return qrCodeBGView
    }()
    
    lazy var teacherTouchLab : UILabel = {
        weak var weakSelf = self
        var teacherTouchLab = UILabel.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        teacherTouchLab.font = DEF_FontSize_14
        teacherTouchLab.backgroundColor = .clear
        teacherTouchLab.textColor = UIColor.colorWithHex(hex: "0378FD")
        teacherTouchLab.textAlignment = .center
        teacherTouchLab.text = "请添加老师微信，开启学习之旅"
        return teacherTouchLab
    }()
    lazy var addQrCodeTitleLab : UILabel = {
        weak var weakSelf = self
        var addQrCodeTitleLab = UILabel.init(frame: CGRect(x: 0, y: (weakSelf!.teacherTouchLab.bottom) + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE))
        addQrCodeTitleLab.font = DEF_FontSize_12
        addQrCodeTitleLab.backgroundColor = .clear
        addQrCodeTitleLab.textColor = .black
        addQrCodeTitleLab.textAlignment = .center
        addQrCodeTitleLab.text = "扫码添加老师微信，即可获得专属福利"
        return addQrCodeTitleLab
    }()
    lazy var qrCodeImg: UIImageView = {
        weak var weakSelf = self
        let imgWidth = 80/WIDTH_6_SCALE
        var qrCodeImg = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH/2 - imgWidth/2, y: (weakSelf!.addQrCodeTitleLab.bottom) + 10/WIDTH_6_SCALE, width: imgWidth, height: imgWidth))
        qrCodeImg.backgroundColor = .gray
        qrCodeImg.loadImage(string: weakSelf?.qrCodeImageUrl)
        return qrCodeImg
    }()
    lazy var weCahtNumLab : UILabel = {
        weak var weakSelf = self
        var weCahtNumLab = UILabel.init(frame: CGRect(x: 0, y: (weakSelf!.qrCodeImg.bottom + 10/WIDTH_6_SCALE), width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE))
        weCahtNumLab.font = DEF_FontSize_12
        weCahtNumLab.backgroundColor = .clear
        weCahtNumLab.textColor = .black
        weCahtNumLab.textAlignment = .center
        if !(weakSelf?.wechatNumber.isEmpty)!{
            weCahtNumLab.text = "微信号:\(weakSelf!.wechatNumber)"
        }
        return weCahtNumLab
    }()
    lazy var instructionLab : UILabel = {
        weak var weakSelf = self
        var instructionLab = UILabel.init(frame: CGRect(x: 0, y: (weakSelf!.weCahtNumLab.bottom) + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 14/WIDTH_6_SCALE))
        instructionLab.font = DEF_FontSize_12
        instructionLab.backgroundColor = .clear
        instructionLab.textColor = .black
        instructionLab.textAlignment = .center
        instructionLab.text = "课程讲义  直播答疑  在线课程"
        return instructionLab
    }()
    lazy var orderCheckBtn : UIButton = {
        let btnH = 45/WIDTH_6_SCALE
        var orderCheckBtn = UIButton.init()
        orderCheckBtn.setTitle("查看订单", for: .normal)
        orderCheckBtn.setTitleColor(UIColor.colorWithHex(hex: "686868"), for: .normal)
        orderCheckBtn.titleLabel?.font = DEF_FontSize_14
        orderCheckBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        orderCheckBtn.layer.cornerRadius = btnH/2
        orderCheckBtn.layer.masksToBounds = true
        orderCheckBtn.layer.borderWidth = 1.0
        orderCheckBtn.layer.borderColor = UIColor.colorWithHex(hex: "e2e2e2").cgColor
        orderCheckBtn.addTarget(self, action: #selector(orderCheckBtnClick), for: .touchUpInside)
        return orderCheckBtn
    }()
    lazy var goOnBuyBtn : UIButton = {
        let btnH = 45/WIDTH_6_SCALE
        var goOnBuyBtn = UIButton.init(frame: CGRect(x: 40/WIDTH_6_SCALE, y: self.orderCheckBtn.bottom + 24/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: 45/WIDTH_6_SCALE))
        goOnBuyBtn.setTitle("继续购买", for: .normal)
        goOnBuyBtn.setTitleColor(UIColor.white, for: .normal)
        goOnBuyBtn.titleLabel?.font = DEF_FontSize_14
        goOnBuyBtn.setBackgroundColor(UIColor.colorWithHex(hex: "4aa1f1"), forState: .normal)
        goOnBuyBtn.layer.cornerRadius = btnH/2
        goOnBuyBtn.layer.masksToBounds = true
        goOnBuyBtn.addTarget(self, action: #selector(goOnBuyBtnClick), for: .touchUpInside)
        return goOnBuyBtn
    }()
    lazy var goStudyBtn : UIButton = {
        var goStudyBtn = UIButton.init()
        goStudyBtn.setTitle("开始学习", for: .normal)
        goStudyBtn.setTitleColor(UIColor.white, for: .normal)
        goStudyBtn.titleLabel?.font = DEF_FontSize_14
        goStudyBtn.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        goStudyBtn.layer.cornerRadius = btnH/2
        goStudyBtn.layer.masksToBounds = true
        goStudyBtn.addTarget(self, action: #selector(goStudyBtnClick), for: .touchUpInside)
        return goStudyBtn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        if self.productType == 0 {
            self.orderIDLab.isHidden = true
            self.moneyLab.isHidden = true
            self.addressLab.isHidden = true
            self.productTitleLab.isHidden = true
            self.tipsLab.isHidden = true
            self.lineView.frame = CGRect(x: 14.5/WIDTH_6_SCALE, y: 17.5/WIDTH_6_SCALE + self.successTitleLab.bottom, width: SCREEN_WIDTH - 29/WIDTH_6_SCALE, height: 1)
            #warning("判断组合订单")
            HUD.loading(text: "")
            UserHelper.shared.getOrderDetail(orderID: Int(self.orderID)!)
            .asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    HUD.hideLoading()
                    guard let `self` = self else { return }
                    self.model = result.data
                    self.qrCodeImageUrl = self.model?.qrCodeImageUrl as! String
                    self.wechatNumber = self.model?.wechatNumber ?? ""
                }, onError: { (error) in
                    HUD.showText(text: error.localizedDescription)
                })
            .disposed(by: disposeBag)
        }else if self.objectType == 1 {
            self.orderIDLab.isHidden = true
            self.moneyLab.isHidden = true
            self.addressLab.isHidden = true
            self.productTitleLab.isHidden = true
            self.orderCheckBtn.isHidden = true
            self.goOnBuyBtn.isHidden = true
            self.headerView.addSubview(self.goStudyBtn)
            self.tipsLab.text = "课程已开通，有效期从现在开始计算，请合理安排学习时间"
            if self.qrCodeImageUrl.isEmpty {
                self.qrCodeBGView.isHidden = true
                self.goStudyBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: self.lineView.bottom + 50/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: btnH)
            }else{
                self.goStudyBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: self.qrCodeBGView.bottom + 50/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: btnH)
            }
        }else{
            if self.objectType == 3 || self.productType == 1 || self.productType == 5{
                self.addressLab.isHidden = true
                self.orderIDLab.isHidden = false
                self.moneyLab.isHidden = true
                self.orderCheckBtn.isHidden = false
                self.goOnBuyBtn.isHidden = true
                self.goStudyBtn.frame = self.goOnBuyBtn.frame
                self.headerView.addSubview(self.goStudyBtn)
                self.productTitleLab.frame = CGRect(x: self.addressLab.left, y: self.orderIDLab.bottom + 13/WIDTH_6_SCALE, width: self.orderIDLab.width, height: self.orderIDLab.height)
            }
            if self.objectType == 2 {
                self.productTitleLab.frame = self.addressLab.frame
                self.addressLab.isHidden = true
                self.tipsLab.text = "课程已开通，有效期从现在开始计算，请合理安排学习时间"
            }
            if self.productType == 2 || self.productType == 4{
                self.addressLab.isHidden = false
                self.productTitleLab.isHidden = false
                self.goStudyBtn.frame = CGRect(x: 40/WIDTH_6_SCALE, y: self.lineView.bottom + 45/WIDTH_6_SCALE, width: SCREEN_WIDTH - 80/WIDTH_6_SCALE, height: 45/WIDTH_6_SCALE)
                self.goOnBuyBtn.frame = CGRect(x: self.goStudyBtn.left, y: self.orderCheckBtn.bottom + 24/WIDTH_6_SCALE, width: self.goStudyBtn.width, height: self.goStudyBtn.height)
                self.addressLab.text = "收货地址： \(self.addressString)"
                self.tipsLab.text = "我们会尽快给您安排发货，请去订单详情查看物流信息"
            }
            HUD.loading(text: "")
            RequestHelper.shared.getOrderSuccessDetail(orderID: self.orderID).asObservable() .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                let baseModel: paySuccessModel = list
                if baseModel.code == 200{
                    let model: paySuccessDetailModel = baseModel.data!
                    self.orderIDLab.text = "订单编号： \(model.poNumber)"
                    self.moneyLab.text = "实付金额： \(model.price)元"
                    self.productTitleLab.text = "商品名称： \(self.productName)"
                }
            }).disposed(by: disposeBag)
        }
        if self.qrCodeImageUrl.isEmpty && self.wechatNumber.isEmpty {
            self.qrCodeBGView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.hidesBottomBarWhenPushed = false
    }
    override func viewDidAppear(_ animated:Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    @objc func orderCheckBtnClick(){
        self.hidesBottomBarWhenPushed = false
        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: false)
        CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 4
        let vc = R.storyboard.my.myOrderViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func goOnBuyBtnClick(){
        self.hidesBottomBarWhenPushed = false
        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func goStudyBtnClick(){
        self.hidesBottomBarWhenPushed = false
        if productType == 5 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goForMyLive"), object: self, userInfo: ["productType": 5])
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updataData"), object: self, userInfo: nil)
        }
        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: false)
        CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
    }
}
