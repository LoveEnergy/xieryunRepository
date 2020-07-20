//
//  ConfirmOrderViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/12/21.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import StoreKit
import SwiftyStoreKit
import SwiftyJSON

class ConfirmOrderViewController: UIViewController {
    var window: UIWindow?
    var pageFromControllerName: String = ""
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    var selectedArray: [CartGoodsModel] = []
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    let disposeBag: DisposeBag = DisposeBag()
    var totalPrice: CGFloat = 0.0
    var discountPrice: CGFloat = 0.0
    var postMoneyPrice : CGFloat = 0.0
    var selectedAddress: AddressModel?
    var showAddress: Bool = true
    var goodsNum: Int = 1
    var priceInfoArray: [OrderPriceInfo] = []
    let priceInfoView = OrderPriceDetailView()
    let learnCardView = OrderLearnCardView()//学习卡栏
    let couponView = OrderCouponView()//优惠券栏
    let invoiceView = OrderInvoiceView(frame: CGRect(x: 0, y: 0, width: 0, height: 32.5/WIDTH_6_SCALE))
    var invoiceID : String = ""//发票ID
    var virtualType: Bool = true
    var submitPrice: String = ""
    var selectCouponID: String = ""//选择优惠券的ID
    var productType: Int = 0
    var applePayID: String = ""
    var storePostPriceTemp: CGFloat = 0.0
    var objectType: Int = 0
    var qrCodeImageUrl: String = ""
    var wechatNumber: String = ""
    var addressDetailString: String = ""
    var productName: String = ""
    var productNum: Int = 0
    var freePostMoney: CGFloat = 0.0//包邮价格
    var provincePostInfoArr: [PostProvinceModel] = [PostProvinceModel]()//各个省邮费
    var isStudyCardPay: Int = 0//0 不可用  1 可以用
    var referrerNameTextField: UITextField?//推荐人
    var freePostType: Bool = false
    var isMember: Int = 0//0.非会员  1.会员
    var singleProductID: Int = 0//单个商品的ID
    var productIndexPathRow: Int = 0//组合订单时判断商品的cell位置
    var userCouponIDString: String = ""//优惠券传给后台的字符串
    var couponSign: Bool = true{//判断优惠方式，选择vip折扣的时候隐藏cell中的打折券，选择使用优惠券的时候显示
        didSet{
            self.updateTotalPrice()
        }
    }
//    var couponModel: (GoodsCouponModel, RuleModel)? {
//        didSet {
//            updateTotalPrice()
//        }
//    }
    var couponModel: NewCouponList? {
        didSet {
            updateTotalPrice()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //取出发票ID
        self.invoiceID = UserDefaults.standard.object(forKey: "InvoiceID") as? String ?? ""
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "确认订单"
        self.scrollView.backgroundColor = UIColor.backgroundColor
        configureViews()
        getCoupons()
//        if self.isMember == 0 {//非会员
//            submitButton.addTarget(self, action: #selector(submitVipOrder), for: .touchUpInside)
//        }else{//会员
            submitButton.addTarget(self, action: #selector(submitOrdinaryOrder), for: .touchUpInside)
//        }
        HUD.loading(text: "")
        RequestHelper.shared.postInfoData().subscribe(onNext: { (model) in
            HUD.hideLoading()
            self.freePostMoney = model.data?.freeShippingPrice as! CGFloat
            self.provincePostInfoArr = model.data?.regionFreightList ?? []
            self.freePostType = false
            self.updateTotalPrice()
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription ?? "未知错误")
        }).disposed(by: disposeBag)
    }
    
    func getCoupons() {
        guard selectedArray.count > 0 else { return }
        //数组转string
        var productIDsArray: [String] = []
        var vipProductIDsArray: [String] = []
        for item in 0...self.selectedArray.count - 1 {
            productIDsArray.append("\(self.selectedArray[item].productID)")
            if self.selectedArray[item].vipPrice > 0 {
                vipProductIDsArray.append("\(self.selectedArray[item].productID)")
            }
        }
        let productIDsString = productIDsArray.joined(separator: ",")
        let vipProductIDsString = vipProductIDsArray.joined(separator: ",")
        UserHelper.shared.getConfirmOrderCoupons(productIDs: productIDsString, vipProductIDs: vipProductIDsString).subscribe(onNext: { (model) in
            HUD.hideLoading()
            if model.code == 200{
                self.couponView.productCouponListView.array = model.data
            }else{
                HUD.showText(text: model.message!)
            }
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription ?? "未知错误")
        }).disposed(by: self.disposeBag)
    }
    
    func configureViews() {
        let infoView = OrderUserInfoView()
        stackView.addArrangedSubview(infoView)
        infoView.snp.makeConstraints { (make) in
            make.height.equalTo(0)
        }
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        
        var showAddress = false
        for item in self.selectedArray {
            if item.type == 2 || item.type == 4 {
                showAddress = true
                self.virtualType = false
                break
            }
        }
        self.showAddress = showAddress
        if showAddress {
            let addressView = OrderAddressView()
            stackView.addArrangedSubview(addressView)
            addressView.addressBlock = {[weak self] address in
                self!.selectedAddress = address
                let selectProvinceName = String(address.provinceName.prefix(2))
                for num in 0...self!.provincePostInfoArr.count - 1 {
                    let tempProvinceName = self?.provincePostInfoArr[num].regionName ?? ""
                    let compareProvinceName = String(tempProvinceName.prefix(2))
                    if compareProvinceName == selectProvinceName {
                        //返回的double是个可选值，所以需要给个默认值或者用!强制解包
                        self!.postMoneyPrice = self?.provincePostInfoArr[num].freightPrice as! CGFloat
                        self!.storePostPriceTemp = self?.provincePostInfoArr[num].freightPrice as! CGFloat
                    }
                }
                
                self!.updateTotalPrice()
            }
            addressView.snp.makeConstraints { (make) in
                make.height.equalTo(72)
            }
            let addressLineView = UIImageView()
            addressLineView.image = UIImage.init(named: "order_line")
            addressView.addSubview(addressLineView)
            addressLineView.snp.makeConstraints { (make) in
                make.height.equalTo(2)
                make.bottom.equalTo(addressView.snp.bottom)
                make.left.right.equalTo(addressView)
            }
        }
        
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        if selectedArray.count > 0 {
            stackView.addArrangedSubview(self.tableView)
            self.tableView.snp.makeConstraints { (make) in
                make.height.equalTo(CGFloat(selectedArray.count) * 89.5/WIDTH_6_SCALE + 54/WIDTH_6_SCALE)
            }
        }
        stackView.addArrangedSubview(invoiceView)
        invoiceView.snp.makeConstraints { (make) in
            make.height.equalTo(35/WIDTH_6_SCALE)
        }
        invoiceView.whenNoInvoicePaperBlock = {()in
            self.invoiceView.invoiceID = ""
            self.invoiceView.detailLabel.text = "发票选择"
            self.invoiceID = ""
        }
        
        if self.isMember == 1 {
//            if self.selectedArray.count <= 1 {
//
//            }
            self.discountChooseView.addSubview(self.discountChooseTitleLab)
            self.discountChooseView.addSubview(self.couponChooseBtn)
            self.discountChooseView.addSubview(self.vipDiscountChooseBtn)
            self.discountChooseView.snp.makeConstraints { (make) in
                make.height.equalTo(35/WIDTH_6_SCALE)
            }
            //优惠方式
            self.discountChooseTitleLab.snp.makeConstraints { (make) in
                make.height.equalTo(self.discountChooseView)
                make.left.equalToSuperview().offset(10)
            }
            //使用优惠券
            self.couponChooseBtn.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.height.equalTo(20/WIDTH_6_SCALE)
                make.right.equalToSuperview().offset(-20/WIDTH_6_SCALE)
            }
            //VIP折扣
            self.vipDiscountChooseBtn.snp.makeConstraints { (make) in
                make.centerY.height.equalTo(self.couponChooseBtn)
                make.right.equalToSuperview().offset(-120/WIDTH_6_SCALE)
            }
            stackView.addArrangedSubview(self.discountChooseView)
            
        }
        couponView.selectCouponModel = {(model) in
            self.couponModel = model
            self.selectCouponID = "\(model.userCouponID)"
            self.couponView.productCouponListView.dismissView()
        }
        couponView.products = self.getProductIDS()
        couponView.totalPrice = self.totalPrice
        if self.productType != 1{
            if WXApi.isWXAppInstalled(){
                stackView.addArrangedSubview(couponView)
            }
        }
        couponView.snp.makeConstraints { (make) in
            make.height.equalTo(35/WIDTH_6_SCALE)
        }
        
        if CartHelper.shared.learnCardAmount >= 0 {
            learnCardView.learnViewSelectBlock = {(isSelect: Bool) in
                self.updateTotalPrice()
            }
            if WXApi.isWXAppInstalled(){
                if self.isStudyCardPay == 1 {
                    stackView.addArrangedSubview(learnCardView)
                }
            }
            learnCardView.snp.makeConstraints { (make) in
                make.height.greaterThanOrEqualTo(35/WIDTH_6_SCALE)
            }
        }
        //推荐人
        if self.objectType == 3 {
            let referrerNameView = UIView.init()
            referrerNameView.backgroundColor = .white
            stackView.addArrangedSubview(referrerNameView)
            referrerNameView.snp.makeConstraints { (make) in
                make.height.equalTo(35/WIDTH_6_SCALE)
            }
            let referrerNameTitle = UILabel.init()
            referrerNameTitle.text = "推荐人"
            referrerNameTitle.font = UIFont.systemFont(ofSize: 13)
            referrerNameTitle.textColor = UIColor.colorWithHex(hex: "676767")
            referrerNameView.addSubview(referrerNameTitle)
            referrerNameTitle.snp.makeConstraints { (make) in
                make.left.equalTo(referrerNameView).offset(10.5/WIDTH_6_SCALE)
                make.centerY.equalTo(referrerNameView)
            }
            
            let referrerNameTextField = UITextField.init()
            referrerNameView.addSubview(referrerNameTextField)
            referrerNameTextField.snp.makeConstraints { (make) in
                make.right.equalTo(referrerNameView.snp.right).offset(-13/WIDTH_6_SCALE)
                make.width.equalTo(200/WIDTH_6_SCALE)
                make.top.equalTo(referrerNameView.snp.top).offset(5/WIDTH_6_SCALE)
                make.bottom.equalTo(referrerNameView.snp.bottom).offset(-5/WIDTH_6_SCALE)
            }
            referrerNameTextField.layer.cornerRadius = 2
            referrerNameTextField.layer.borderWidth = 0.8
            referrerNameTextField.layer.borderColor = UIColor.gray.cgColor
            referrerNameTextField.layer.masksToBounds = true
            referrerNameTextField.font = UIFont.systemFont(ofSize: 13)
            referrerNameTextField.placeholder = "推荐人"
            self.referrerNameTextField = referrerNameTextField
        }
        stackView.addArrangedSubview(.spacer(height: 10, backgroundColor: UIColor.backgroundColor, alpha: 1))
        stackView.addArrangedSubview(priceInfoView)
        priceInfoView.snp.makeConstraints { (make) in
            make.height.greaterThanOrEqualTo(150/WIDTH_6_SCALE)
        }
        //vip优惠金额
        self.vipDiscountsView.snp.makeConstraints { (make) in
            make.height.equalTo(30/WIDTH_6_SCALE)
        }
        self.vipMinusMoneyTitleLab.snp.makeConstraints { (make) in
            make.left.equalTo(vipDiscountsView.left).offset(10)
            make.top.bottom.equalTo(vipDiscountsView)
        }
        self.vipMinusMoneyLab.snp.makeConstraints { (make) in
            make.right.equalTo(vipDiscountsView.right).offset(-15/WIDTH_6_SCALE)
            make.top.bottom.equalTo(vipDiscountsView)
        }
        
        //非会员：开通VIP会员，尽享优惠
        let vipBarView = UIView.init()
        vipBarView.backgroundColor = .white
        let startVIPLab = UILabel.init()
        startVIPLab.text = "开通VIP会员，尽享优惠"
        startVIPLab.font = DEF_FontSize_15
        startVIPLab.textAlignment = .left
        startVIPLab.textColor = UIColor.colorWithHex(hex: "FEAA5C")
        //立即开通
        let startVIPBtn = LayoutableButton(type: .custom)
        startVIPBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .light)
        startVIPBtn.setTitleColor(UIColor.colorWithHex(hex: "FEAA5C"), for: .normal)
        startVIPBtn.setTitle("立即开通", for: .normal)
        startVIPBtn.setImage(R.image.more_arrow(), for: .normal)
        startVIPBtn._layoutType = "right"
        startVIPBtn.addTarget(self, action: #selector(startVIPBtnClick), for: .touchUpInside)
        vipBarView.addSubview(startVIPLab)
        vipBarView.addSubview(startVIPBtn)
        //会员展示页
        let tap = UITapGestureRecognizer(target: self, action: #selector(memberShow))
        vipBarView.addGestureRecognizer(tap)
        if self.isMember == 0 {
            vipBarView.snp.makeConstraints { (make) in
                make.height.equalTo(30/WIDTH_6_SCALE)
            }
            startVIPLab.snp.makeConstraints { (make) in
                make.left.equalTo(vipBarView.left).offset(10)
                make.top.bottom.equalTo(vipBarView)
            }
            startVIPBtn.snp.makeConstraints { (make) in
                make.right.equalTo(vipBarView.right).offset(-20/WIDTH_6_SCALE)
                make.top.bottom.equalTo(vipBarView)
            }
            stackView.addArrangedSubview(vipBarView)
        }
        //商品数量大于1的时候，不允许使用折扣券
        if self.selectedArray.count > 1 {
            self.discountTypeChooseClick(btn: self.couponChooseBtn)
            stackView.removeArrangedSubview(self.discountChooseView)
            self.discountChooseTitleLab.isHidden = true
        }else{
            self.discountTypeChooseClick(btn: self.vipDiscountChooseBtn)
        }
    }
    
    lazy var tableView : ConfirmOrderTableView = {
        let tableView = ConfirmOrderTableView(frame: .zero, style: .plain)
        tableView.isScrollEnabled = false
        tableView.data = self.selectedArray
        if self.pageFromControllerName == "cartViewController" {
            tableView.controllerFromName = self.pageFromControllerName
        }
        tableView.goodsViewChangeGoodsNum = {(changeGoodsNum: Int, cellIndex: Int) in
            print("\(changeGoodsNum)")
            if self.selectedArray.count == 1 {
                self.goodsNum = changeGoodsNum
                self.updateTotalPrice()
            }else{
                
            }
        }
        tableView.showCouponListViewBlock = {(cell, productID, indexpathRow) in//显示打折券列表
            HUD.loading(text: "")
            self.singleProductID = productID
            self.productIndexPathRow = indexpathRow
            UserHelper.shared.getDiscountCoupon(productID: "\(productID)", userCouponIDs: self.userCouponIDString).subscribe(onNext: { (model) in
                HUD.hideLoading()
                if model.code == 200{
                    self.window = UIApplication.shared.keyWindow
                    let rect1 = cell.couponChooseBtn.convert(cell.couponChooseBtn.frame, from: cell.contentView)
                    let rect2 = cell.couponChooseBtn.convert(rect1, to: self.window)
                    var discountCouponArray: [DiscountCouponModel] = model.data
                    var tempDiscountCouponModel = DiscountCouponModel.init(JSON: ["discountRate":0, "userCouponID": 0])
                    discountCouponArray.append(tempDiscountCouponModel!)
                    self.discountView.showView(frame: rect2, array: discountCouponArray)
                }else{
                    HUD.showText(text: model.message!)
                }
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription ?? "未知错误")
            }).disposed(by: self.disposeBag)
        }
        return tableView
    }()
    
    lazy var discountView : DiscountView = {
        var discountView = DiscountView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        discountView.dismissDiscountViewBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.discountView.alpha = 0
            }) { (Bool) in
                self.discountView.removeFromSuperview()
            }
        }
        discountView.chooseDiscountCoupon = {(arrayIndex, array) in
            self.discountView.dismissView()
            var discountCouponString = ""
            var userCouponIDArray: [String] = [String]()
            var tempArray: [CartGoodsModel] = [CartGoodsModel]()
            tempArray.append(contentsOf: self.selectedArray)
            self.selectedArray[self.productIndexPathRow].userCouponID = array[arrayIndex].userCouponID
            if array[arrayIndex].discountRate != 0{
                self.selectedArray[self.productIndexPathRow].selectCoupon = 1//选择了打折券
            }else{
                self.selectedArray[self.productIndexPathRow].selectCoupon = 0//选择了不打折
            }
            for item in 0...self.selectedArray.count - 1{
                if self.selectedArray[item].selectCoupon != 0 {
                    userCouponIDArray.append("\(self.selectedArray[item].userCouponID)")
                }
            }
            //数组转string
            let result = userCouponIDArray.joined(separator: ",")
            self.userCouponIDString = result
            self.selectedArray[self.productIndexPathRow].discountCouponRate = array[arrayIndex].discountRate
            self.updateTotalPrice()
            self.tableView.reloadData()
        }
        return discountView
    }()
    
    lazy var discountChooseView : UIView = {
        var discountChooseView = UIView.init(frame: .zero)
        discountChooseView.backgroundColor = .white
        return discountChooseView
    }()
    
    lazy var discountChooseTitleLab : UILabel = {
        var titleLab = UILabel.init()
        titleLab.font = DEF_FontSize_14
        titleLab.backgroundColor = .clear
        titleLab.textColor = UIColor.colorWithHex(hex: "666768")
        titleLab.textAlignment = .left
        titleLab.text = "优惠方式"
        return titleLab
    }()
    
    lazy var vipDiscountChooseBtn : LayoutableButton = {
        var vipDiscountChooseBtn = LayoutableButton(type: .custom)
        vipDiscountChooseBtn.setTitle("VIP折扣", for: .normal)
        vipDiscountChooseBtn.setTitleColor(UIColor.colorWithHex(hex: "666768"), for: .normal)
        vipDiscountChooseBtn.titleLabel?.font = DEF_FontSize_13
        vipDiscountChooseBtn.setImage(UIImage.init(named: "cart_choose_n"), for: .normal)
        vipDiscountChooseBtn.setImage(UIImage.init(named: "cart_choose_s"), for: .selected)
        vipDiscountChooseBtn._layoutType = "right"
        vipDiscountChooseBtn.addTarget(self, action: #selector(discountTypeChooseClick(btn:)), for: .touchUpInside)
        vipDiscountChooseBtn.isSelected = false
        return vipDiscountChooseBtn
    }()
    
    lazy var couponChooseBtn : LayoutableButton = {
        var couponChooseBtn = LayoutableButton(type: .custom)
        couponChooseBtn.setTitle("使用优惠券", for: .normal)
        couponChooseBtn.setTitleColor(UIColor.colorWithHex(hex: "666768"), for: .normal)
        couponChooseBtn.titleLabel?.font = DEF_FontSize_13
        couponChooseBtn.setImage(UIImage.init(named: "cart_choose_n"), for: .normal)
        couponChooseBtn.setImage(UIImage.init(named: "cart_choose_s"), for: .selected)
        couponChooseBtn._layoutType = "right"
        couponChooseBtn.addTarget(self, action: #selector(discountTypeChooseClick(btn:)), for: .touchUpInside)
        couponChooseBtn.isSelected = true
        return couponChooseBtn
    }()

    
    func getProductIDS() -> [String] {
        guard selectedArray.count > 0 else { return [] }
        let ids = selectedArray.map { (model) -> String in
//            学习卡金额
            let learnCardMoneyNum = NSDecimalNumber.init(string: self.learnCardView.detailLabel.text)
            let appPriceNum = NSDecimalNumber.init(floatLiteral: Double(self.selectedArray[0].price))
            if self.isStudyCardPay != 1{
                learnCardView.isHidden = true
            }
            else if self.productType == 1{//在线课程
                if Int(truncating: learnCardMoneyNum.subtracting(appPriceNum)) < 0 {
                    learnCardView.isHidden = true
                }
            }
            return model.productID.string
        }
        return ids
    }
    
    func updateTotalPrice() {
        var minusTotalMoneyDecimal = NSDecimalNumber.init(value: 0)
        let value = self.selectedArray.reduce(0) { (result, model) -> NSDecimalNumber in
            if self.isMember == 0{//非会员
                if self.productType == 1{
                    let goodsNumDecimal = NSDecimalNumber.init(value: goodsNum)
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(model.price))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discountNum = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discountNum.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        return result.adding(perGoodsTotalMoney)
                    }
                }else if self.productType == 2 || self.productType == 4{
                    let goodsNumDecimal = NSDecimalNumber.init(value: model.count)
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(model.price))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discount = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discount.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        return result.adding(perGoodsTotalMoney)
                    }
                }else{
                    let goodsNumDecimal = NSDecimalNumber.init(value: goodsNum)
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(model.price))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discount = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discount.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        return result.adding(perGoodsTotalMoney)
                    }
                }
            }else{//会员
                if self.productType == 1{
                    var countPrice: CGFloat
                    var perGoodsMinusMoney: NSDecimalNumber
                    if model.vipPrice < 0 {//这时候没有VIP价格
                        countPrice = model.price
                    }else{
                        countPrice = model.vipPrice
                        if self.couponSign == true {
                            if self.selectedArray.count == 1 {
                                countPrice = model.price
                            }
                        }
                        perGoodsMinusMoney = NSDecimalNumber.init(value: Double(model.vipPrice - model.price))
                        minusTotalMoneyDecimal = minusTotalMoneyDecimal.adding(perGoodsMinusMoney)
                    }
                    let goodsNumDecimal = NSDecimalNumber.init(value: goodsNum)
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(countPrice))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discountNum = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discountNum.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        if self.isMember == 1 {
                            self.vipMinusMoneyLab.text = "\(minusTotalMoneyDecimal)"
                        }
                        return result.adding(perGoodsTotalMoney)
                    }
                }else if self.productType == 2 || self.productType == 4{
                    var countPrice: CGFloat
                    var perGoodsMinusMoney: NSDecimalNumber
                    let goodsNumDecimal = NSDecimalNumber.init(value: model.count)
                    if model.vipPrice < 0 {//这时候没有VIP价格
                        countPrice = model.price
                    }else{
                        countPrice = model.vipPrice
                        if self.couponSign == true {
                            if self.selectedArray.count == 1 {
                                countPrice = model.price
                            }
                        }
                        perGoodsMinusMoney = NSDecimalNumber.init(value: Double(model.vipPrice - model.price))
                        minusTotalMoneyDecimal = minusTotalMoneyDecimal.adding(perGoodsMinusMoney)
                    }
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(countPrice))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discount = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discount.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        if self.isMember == 1 {
                            self.vipMinusMoneyLab.text = "\(minusTotalMoneyDecimal)"
                        }
                        return result.adding(perGoodsTotalMoney)
                    }
                }else{
                    var countPrice: CGFloat
                    var perGoodsMinusMoney: NSDecimalNumber
                    let goodsNumDecimal = NSDecimalNumber.init(value: goodsNum)
                    if model.vipPrice < 0 {//这时候没有VIP价格
                        countPrice = model.price
                    }else{
                        countPrice = model.vipPrice
                        if self.couponSign == true {
                            if self.selectedArray.count == 1 {
                                countPrice = model.price
                            }
                        }
                        perGoodsMinusMoney = NSDecimalNumber.init(value: Double(model.vipPrice - model.price))
                        minusTotalMoneyDecimal = minusTotalMoneyDecimal.adding(perGoodsMinusMoney)
                    }
                    let goodsPrice = NSDecimalNumber.init(floatLiteral: Double(countPrice))
                    let perGoodsTotalMoney = goodsNumDecimal.multiplying(by: goodsPrice)
                    if self.couponSign == true {
                        if model.discountCouponRate != 0 {
                            let discount = NSDecimalNumber.init(floatLiteral: Double(model.discountCouponRate/10))
                            let roundUp = NSDecimalNumberHandler.init(roundingMode: .plain, scale: 2, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: true)
                            let perDiscountTotal = discount.multiplying(by: perGoodsTotalMoney, withBehavior: roundUp)
                            return result.adding(perDiscountTotal)
                        }else{
                            return result.adding(perGoodsTotalMoney)
                        }
                    }else{
                        if self.isMember == 1 {
                            self.vipMinusMoneyLab.text = "\(minusTotalMoneyDecimal)"
                        }
                        return result.adding(perGoodsTotalMoney)
                    }
                }
            }
        }
        let valueString = "\(value)"
        totalPrice = CGFloat(Double(valueString) ?? 0)
        discountPrice = CGFloat(Double(valueString) ?? 0)
//        #warning("!!!!!!更改运费，测试过后改回来")
//        postMoneyPrice = 0.00
        var discountNum = NSDecimalNumber.init(string: "\(discountPrice)")
        var postFreeSign: Bool = false//默认不包邮
        if let coupon = self.couponModel {
            let totalPriceString = "\(totalPrice)"
            //couponType（1.满减券 2.代金券 3.折扣券 4.包邮券）
            if coupon.couponType == 1 || coupon.couponType == 2{
                let minString = "\(coupon.reductionPrice)"
                let totalPriceNum = NSDecimalNumber.init(string: totalPriceString)
                let minNum = NSDecimalNumber.init(string: minString)
                discountNum = totalPriceNum.subtracting(minNum)
            }
            if coupon.couponType == 3{
                let totalPriceNum = NSDecimalNumber.init(string: totalPriceString)
                let discountRate = NSDecimalNumber.init(floatLiteral: Double(coupon.discountRate))
                let hander = NSDecimalNumberHandler.init(roundingMode: .up, scale: 1, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
                discountNum = totalPriceNum.dividing(by: discountRate, withBehavior: hander)
            }
            if coupon.couponType == 4{
                postFreeSign = true
            }
        }
        if CGFloat(truncating: discountNum) > self.freePostMoney || CGFloat(truncating: discountNum) == self.freePostMoney{//满80免邮费
            postMoneyPrice = 0.00
            self.freePostType = true
        }else{
            postMoneyPrice = self.storePostPriceTemp
            if self.freePostType == true {
                postMoneyPrice = 0.00
            }
        }
        if postFreeSign == true {
            postMoneyPrice = 0.00
        }
        let postNum = NSDecimalNumber.init(string: "\(postMoneyPrice)")
        var totalNum = discountNum.adding(postNum)
        if self.productType == 1 {
            totalPriceLabel.text = "学点\(totalNum)"
        }else{
            totalPriceLabel.text = "￥\(totalNum)"
        }
        //使用优惠券之后小于0，合计即0
        if totalNum.compare(NSDecimalNumber.init(value: 0)) == .orderedAscending {
            totalNum = NSDecimalNumber.init(value: 0)
        }
        self.submitPrice = "\(totalNum)"
        
        let finalSubmitPrice = NSDecimalNumber.init(string: self.submitPrice)
        let learnNum = NSDecimalNumber.init(string: self.learnCardView.detailLabel.text)
        if self.learnCardView.checkButton.isSelected {
            if Int(truncating: learnNum.subtracting(NSDecimalNumber.init(string: self.submitPrice))) > 0 {
                //学习卡金额大于商品价格
                if self.productType == 1 {
                    totalPriceLabel.text = "学点0"
                }else{
                    totalPriceLabel.text = "￥0"
                }
            }else{
                //学习卡金额小于商品价格
                let finalNum = finalSubmitPrice.subtracting(learnNum)
                if self.productType == 1 {
                    totalPriceLabel.text = "学点\(finalNum)"
                }else{
                    totalPriceLabel.text = "￥\(finalNum)"
                }
            }
        }else{
            if self.productType == 1 {
                totalPriceLabel.text = "学点\(totalNum)"
            }else{
                totalPriceLabel.text = "￥\(totalNum)"
            }
        }
        updatePriceInfo()
    }
    
    func updatePriceInfo() {
        var totalInfo: OrderPriceInfo
        if self.productType == 1 {
            totalInfo = OrderPriceInfo(name: "商品金额", value: "学点\(totalPrice.string)")
        }else{
            totalInfo = OrderPriceInfo(name: "商品金额", value: "￥\(totalPrice.string)")
        }
        var fee = OrderPriceInfo(name: "邮费", value: "+\(postMoneyPrice.numberFormat(length: 2))")
        if self.productType == 2 || self.productType == 4 {
            if self.freePostMoney != 0 {
                fee = OrderPriceInfo(name: "邮费(满\(self.freePostMoney)元包邮)", value: "+\(postMoneyPrice.numberFormat(length: 2))")
            }
        }
        
        let activityInfo = OrderPriceInfo(name: "促销优惠", value: "+0.00")
        var delta: String = ""
        if let coupon = self.couponModel {
            //couponType（1.满减券 2.代金券 3.折扣券 4.包邮券）
            if coupon.couponType == 1 && coupon.couponType == 2{
                delta = "\(coupon.reductionPrice.numberFormat(length: 2))"
            }
            if coupon.couponType == 3{
                delta = "\(coupon.discountRate)折"
            }
            if coupon.couponType == 4{
                delta = ""
            }
        }
        let couponInfo = OrderPriceInfo(name: "优惠券", value: delta)
        //如果是会员的话，添加VIP优惠金额
        let learnCard = OrderPriceInfo(name: "学习卡", value: "+0.00")
        if WXApi.isWXAppInstalled(){
            if self.isStudyCardPay == 1 {
                priceInfoView.configure(array: [totalInfo, fee, activityInfo, couponInfo, learnCard])
            }else{
                priceInfoView.configure(array: [totalInfo, fee, activityInfo, couponInfo])
            }
        }else{
            if self.isStudyCardPay == 1 {
                priceInfoView.configure(array: [totalInfo, fee, activityInfo, learnCard])
            }else{
                priceInfoView.configure(array: [totalInfo, fee, activityInfo])
            }
        }
    }
    //VIP优惠金额View
    lazy var vipDiscountsView : UIView = {
        var vipDiscountsView = UIView.init()
        vipDiscountsView.backgroundColor = .white
        vipDiscountsView.addSubview(self.vipMinusMoneyTitleLab)
        vipDiscountsView.addSubview(self.vipMinusMoneyLab)
        return vipDiscountsView
    }()
    //优惠券的减免钱数
    lazy var vipMinusMoneyLab : UILabel = {
        var vipMinusMoneyLab = UILabel.init()
        vipMinusMoneyLab.font = DEF_FontSize_15
        vipMinusMoneyLab.textColor = UIColor.colorWithHex(hex: "FEAA5C")
        vipMinusMoneyLab.textAlignment = .right
        vipMinusMoneyLab.text = ""
        return vipMinusMoneyLab
    }()
    //优惠券的减免钱数
    lazy var vipMinusMoneyTitleLab : UILabel = {
        var vipMinusMoneyTitleLab = UILabel.init()
        vipMinusMoneyTitleLab.font = DEF_FontSize_14
        vipMinusMoneyTitleLab.textColor = UIColor.colorWithHex(hex: "FEAA5C")
        vipMinusMoneyTitleLab.textAlignment = .right
        vipMinusMoneyTitleLab.text = "VIP优惠金额"
        return vipMinusMoneyTitleLab
    }()
    //提交订单
    @objc func submitOrdinaryOrder(){
        var addressID = -1
        var array : [SubmitOrderGoodsNewWithoutVIPModel] = []
        for object in self.selectedArray {
            if let model = SubmitOrderGoodsNewWithoutVIPModel(JSONString: object.toJSONString() ?? "") {
                if self.isMember == 1 {//会员
                    if self.selectedArray.count > 1 {//判断是否为组合订单
                        if object.vipPrice < 0 {
                            model.price = object.price
                        }else{
                            model.price = object.vipPrice
                        }
                    }else{
                        if self.couponSign == false {
                            if object.vipPrice < 0 {
                                model.price = object.price
                            }else{
                                model.price = object.vipPrice
                            }
                        }else{
                            model.price = object.price
                        }
                    }
                }
                array.append(model)
            }
        }
        var payMode: String = "1"
        if self.learnCardView.useLearnCard.value == true {
            payMode = "2"
        }
        let tempModel = array[0]
        self.productNum = array.count
        if self.couponModel != nil {
            if self.userCouponIDString.isEmpty == true {
                self.userCouponIDString = "\(self.couponModel!.userCouponID)"
            }else{
                self.userCouponIDString = "\(self.userCouponIDString),\(self.couponModel!.userCouponID)"
            }
        }
        if self.productType == 1{
            UserHelper.shared.saveNewOrderWithoutVip(isGroup: 0, addressID: "", discountPrice: self.submitPrice, distributionMode: 1, rulesIDs: "", productType: tempModel.type, totalPrice: "\(totalPrice)", invitationCode: "", payChannel: 3, productList: array, invoiceID: Int(self.invoiceID) ?? 0, trafficPay: "\(postMoneyPrice.numberFormat(length: 2))", couponIDs: self.userCouponIDString, payMode: payMode, recommenderName: self.referrerNameTextField?.text ?? "")
            .asObservable()
                .subscribe(onNext: { (result) in
                    HUD.loading(text: "")
                    result.errorDeal(successBlock: {
                        HUD.loading(text: "")
                        let orderID: Int = result.data!.orderID
                        if let id = result.data?.orderID.string {
                            if let status = result.data?.status, status == 1 {
                                let vc = BuyOnlineClassViewController.init()
                                vc.orderID = orderID
                                vc.productPrice = self.submitPrice
                                vc.cellArray = self.selectedArray
                                self.navigationController?.pushViewController(vc, animated: true)
                            } else {
                                HUD.hideLoading()
                                //下单成功
                                let vc = PaySuccessViewController.init()
                                vc.orderID = "\(orderID)"
                                vc.wechatNumber = self.wechatNumber
                                vc.qrCodeImageUrl = self.qrCodeImageUrl
                                if self.productNum == 1 {
                                    //不是组合订单的时候
                                    vc.productType = self.productType
                                    vc.productName = array[0].productName
                                }else{
                                    //是组合订单的时候
                                    vc.productType = 0
                                }
                                CurrentControllerHelper.pushViewController(viewController: vc)
                            }
                        } else {
                            HUD.hideLoading()
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    })
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
                    HUD.hideLoading()
                })
            .disposed(by: disposeBag)
        }else{
            if self.showAddress {
                guard let address = self.selectedAddress else {
                    HUD.showText(text: "请选择地址")
                    return
                }
                addressID = address.addressID
            }
            var addressString = ""
            if addressID != -1{
                addressString = "\(addressID)"
            }
            HUD.loading(text: "")
            UserHelper.shared.saveNewOrderWithoutVip(isGroup: 0, addressID: addressString, discountPrice: self.submitPrice, distributionMode: 1, rulesIDs: "", productType: tempModel.type, totalPrice: "\(totalPrice)", invitationCode: "", payChannel: 3, productList: array, invoiceID: Int(self.invoiceID) ?? 0, trafficPay: "\(postMoneyPrice.numberFormat(length: 2))", couponIDs: self.userCouponIDString, payMode: payMode, recommenderName: self.referrerNameTextField?.text ?? "")
            .asObservable()
                .subscribe(onNext: { (result) in
                    HUD.hideLoading()
                    if result.code == 401{
                        let loginVC = R.storyboard.login.instantiateInitialViewController()!
                        CurrentControllerHelper.presentViewController(viewController: loginVC)
                    }else{
                        result.errorDeal(successBlock: {
                            HUD.hideLoading()
                            HUD.showText(text: "提交成功")
                            if let id = result.data?.orderID.string {
                                if let status = result.data?.status, status == 1 {
                                    self.addressDetailString = self.selectedAddress?.address as? String ?? ""
                                    if array.count == 1 {
                                        self.productName = array[0].productName
                                    }
                                    self.showPayVC(orderID: id)
                                } else {
                                    //下单成功
                                    let vc = PaySuccessViewController.init()
                                    vc.orderID = "\(id)"
                                    vc.wechatNumber = self.wechatNumber
                                    vc.qrCodeImageUrl = self.qrCodeImageUrl
                                    if self.productNum == 1 {
                                        //不是组合订单的时候
                                        vc.productType = self.productType
                                        vc.productName = array[0].productName
                                        vc.objectType = self.objectType
                                    }else{
                                        //是组合订单的时候
                                        vc.productType = 0
                                    }
                                    CurrentControllerHelper.pushViewController(viewController: vc)
                                }
                            } else {
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        })
                    }
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
                })
            .disposed(by: disposeBag)
        }
    }
    
//    @objc func submitVipOrder() {
//        var addressID = -1
//        var array : [SubmitOrderGoodsNewWithVIPModel] = []
//        for object in self.selectedArray {
//            if let model = SubmitOrderGoodsNewWithVIPModel(JSONString: object.toJSONString() ?? "") {
//                array.append(model)
//            }
//        }
//        var payMode: String = "1"
//        if self.learnCardView.useLearnCard.value == true {
//            payMode = "2"
//        }
//        let tempModel = array[0]
//        self.productNum = array.count
//        if self.productType == 1{
//            UserHelper.shared.saveNewOrderWithVip(isGroup: 0, addressID: "", discountPrice: self.submitPrice, distributionMode: 1, rulesIDs: "", productType: tempModel.type, totalPrice: "\(totalPrice)", invitationCode: "", payChannel: 3, productList: array, invoiceID: Int(self.invoiceID) ?? 0, trafficPay: "\(postMoneyPrice.numberFormat(length: 2))", couponIDs: self.selectCouponID, payMode: payMode, recommenderName: self.referrerNameTextField?.text ?? "")
//            .asObservable()
//                .subscribe(onNext: { (result) in
//                    HUD.loading(text: "")
//                    result.errorDeal(successBlock: {
//                        HUD.loading(text: "")
//                        let orderID: Int = result.data!.orderID
//                        if let id = result.data?.orderID.string {
//                            if let status = result.data?.status, status == 1 {
//                                let vc = BuyOnlineClassViewController.init()
//                                vc.orderID = orderID
//                                vc.productPrice = self.submitPrice
//                                vc.cellArray = self.selectedArray
//                                self.navigationController?.pushViewController(vc, animated: true)
//                            } else {
//                                HUD.hideLoading()
//                                //下单成功
//                                let vc = PaySuccessViewController.init()
//                                vc.orderID = "\(orderID)"
//                                vc.wechatNumber = self.wechatNumber
//                                vc.qrCodeImageUrl = self.qrCodeImageUrl
//                                if self.productNum == 1 {
//                                    //不是组合订单的时候
//                                    vc.productType = self.productType
//                                    vc.productName = array[0].productName
//                                }else{
//                                    //是组合订单的时候
//                                    vc.productType = 0
//                                }
//                                CurrentControllerHelper.pushViewController(viewController: vc)
//                            }
//                        } else {
//                            HUD.hideLoading()
//                            self.navigationController?.popToRootViewController(animated: true)
//                        }
//                    })
//                }, onError: { (error) in
//                    HUD.showError(error: error.localizedDescription)
//                    HUD.hideLoading()
//                })
//            .disposed(by: disposeBag)
//        }else{
//            if self.showAddress {
//                guard let address = self.selectedAddress else {
//                    HUD.showText(text: "请选择地址")
//                    return
//                }
//                addressID = address.addressID
//            }
//            var addressString = ""
//            if addressID != -1{
//                addressString = "\(addressID)"
//            }
//            HUD.loading(text: "")
//            UserHelper.shared.saveNewOrderWithVip(isGroup: 0, addressID: addressString, discountPrice: self.submitPrice, distributionMode: 1, rulesIDs: "", productType: tempModel.type, totalPrice: "\(totalPrice)", invitationCode: "", payChannel: 3, productList: array, invoiceID: Int(self.invoiceID) ?? 0, trafficPay: "\(postMoneyPrice.numberFormat(length: 2))", couponIDs: self.selectCouponID, payMode: payMode, recommenderName: self.referrerNameTextField?.text ?? "")
//            .asObservable()
//                .subscribe(onNext: { (result) in
//                    HUD.hideLoading()
//                    if result.code == 401{
////                        HUD.showText(text: "请重新登录")
//                        let loginVC = R.storyboard.login.instantiateInitialViewController()!
//                        CurrentControllerHelper.presentViewController(viewController: loginVC)
//                    }else{
//                        result.errorDeal(successBlock: {
//                            HUD.hideLoading()
//                            HUD.showText(text: "提交成功")
//                            if let id = result.data?.orderID.string {
//                                if let status = result.data?.status, status == 1 {
//                                    self.addressDetailString = self.selectedAddress?.address as? String ?? ""
//                                    if array.count == 1 {
//                                        self.productName = array[0].productName
//                                    }
//                                    self.showPayVC(orderID: id)
//                                } else {
//                                    //下单成功
//                                    let vc = PaySuccessViewController.init()
//                                    vc.orderID = "\(id)"
//                                    vc.wechatNumber = self.wechatNumber
//                                    vc.qrCodeImageUrl = self.qrCodeImageUrl
//                                    if self.productNum == 1 {
//                                        //不是组合订单的时候
//                                        vc.productType = self.productType
//                                        vc.productName = array[0].productName
//                                        vc.objectType = self.objectType
//                                    }else{
//                                        //是组合订单的时候
//                                        vc.productType = 0
//                                    }
//                                    CurrentControllerHelper.pushViewController(viewController: vc)
//                                }
//                            } else {
//                                self.navigationController?.popToRootViewController(animated: true)
//                            }
//                        })
//                    }
//                }, onError: { (error) in
//                    HUD.showError(error: error.localizedDescription)
//                })
//            .disposed(by: disposeBag)
//        }
//    }
    
    func showPayVC(orderID: String) {
        let vc = R.storyboard.cart.payOrderViewController()!
        vc.haveCourse = self.selectedArray.filter({ (object) -> Bool in
            return object.type == 1 && object.type == 3
        }).count > 0
        let vm = OrderPayViewModel(orderID: orderID)
        vc.bindViewModel(viewModel: vm)
        vc.virtualType = self.virtualType
        if self.productNum == 1 {
            vc.productType = self.productType
            vc.objectType = self.objectType
            vc.productName = self.productName
        }else{
            vc.productType = 0
            vc.objectType = 0
            vc.productName = ""
        }
        vc.submitPrice = CGFloat(Double(self.submitPrice) ?? 0)
        vc.wechatNumber = self.wechatNumber
        vc.qrCodeImageUrl = self.qrCodeImageUrl
        vc.addressString = self.addressDetailString
        vc.productName = self.productName
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    //data转dic
    func dataToDictionary(data:Data) ->Dictionary<String, Any>?{
        do{
            let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            let dic = json as! Dictionary<String, Any>
            return dic
        }catch _ {
            print("失败")
            return nil
        }
    }
    
    private func computationsMoney(money: Double) -> String{
        let decimalString = NSDecimalNumber.init(value: money)
        let sumString = NSDecimalNumber.init(value: 0.01)
        let hander = NSDecimalNumberHandler.init(roundingMode: .up, scale: 1, raiseOnExactness: false, raiseOnOverflow: false, raiseOnUnderflow: false, raiseOnDivideByZero: false)
        let count = decimalString.dividing(by: sumString, withBehavior: hander)
        return String(describing: count)
    }
    
    public func loadJSON() -> JSON {
        let defaults = UserDefaults.standard
        return JSON(defaults.value(forKey: "json") as! String)
    }
    
    // MARK: 字典转字符串
    func dicValueString(_ dic:[String : Any]) -> String?{
        let data = try? JSONSerialization.data(withJSONObject: dic, options: [])
        let str = String(data: data!, encoding: String.Encoding.utf8)
        return str
    }
    
    // MARK: 字符串转字典
    func stringValueDic(_ str: String) -> [String : Any]?{
         let data = str.data(using: String.Encoding.utf8)
         if let dict = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String : Any] {
             return dict
         }
         return nil
     }
    //开通VIP
    @objc func startVIPBtnClick(){
        let vc = MemberPublicityViewController.init()
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func memberShow(){
        let vc = MemberPublicityViewController.init()
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    //选择优惠方式
    @objc func discountTypeChooseClick(btn: UIButton){
        if btn == self.vipDiscountChooseBtn {
            //VIP折扣，左
            self.vipDiscountChooseBtn.isSelected = true
            self.couponChooseBtn.isSelected = false
            self.couponSign = false
            self.tableView.showCouponSign = false
            stackView.removeArrangedSubview(self.couponView)
            self.couponView.isHidden = true
            self.couponView.titleLabel.isHidden = true
            self.couponView.detailLabel.isHidden = true
            self.couponView.arrowImageView.isHidden = true
            self.vipDiscountsView.isHidden = false
            self.couponModel = NewCouponList.init(JSON: ["totalPrice": 0])
            if self.isMember == 1 {
                stackView.addArrangedSubview(self.vipDiscountsView)
            }
        }else{
            //使用优惠券，右
            self.vipDiscountChooseBtn.isSelected = false
            self.couponChooseBtn.isSelected = true
            self.couponSign = true
            if self.selectedArray.count == 1 {
                self.tableView.showCouponSign = true
            }
            self.couponView.isHidden = false
            stackView.insertArrangedSubview(self.couponView, at: 8)
            self.couponView.titleLabel.isHidden = false
            self.couponView.detailLabel.isHidden = false
            self.couponView.arrowImageView.isHidden = false
            self.vipDiscountsView.isHidden = true
            stackView.removeArrangedSubview(self.vipDiscountsView)
        }
        self.tableView.reloadData()
        self.updateTotalPrice()
    }
}
