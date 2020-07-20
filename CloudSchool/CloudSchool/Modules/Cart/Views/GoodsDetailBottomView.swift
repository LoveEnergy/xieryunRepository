//
//  GoodsDetailBottomView.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GoodsDetailBottomView: UIView {
    public var stopPlayVideoBlock:(()->())?//停止播放
    public var alertViewBlock:(()->())?//弹出游客登录提示
    public var showMessageBlock:((String)->())?
    public var goForActiveClassBlock:(()->())?//前去开课
    public var goForStudyBlock:(()->())?//前去学习
//    public var vipBuyBlock:(()->())?//VIP购买
//    public var buyOnlineClassBlock:(()->())?//购买线上课程
    let disposeBag: DisposeBag = DisposeBag()
    var productID: String = ""
    var goodsType: String = ""
    var count: String = ""
    var isStudy: Int = 0//1 开始学习  0 立即购买
    var isMember: Int = 0//0.非会员  1.会员
    public var goToStudyBlock:(()->())?
    
    @IBOutlet weak var stackView: UIStackView!
    var model: ProductDetailModel? {
        didSet {
            guard let model = self.model else {
                return
            }
            self.stackView.isHidden = false
            self.consultButton.isHidden = true
            if model.basicPrice <= 0 {
                addTocartBtn.isHidden = true
                vipBuyBtn.isHidden = true
                buyRightNowBtn.isHidden = true
                studyBtn.isHidden = false
                studyBtn.setTitle("免费学习", for: .normal)
                studyBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.height)
            } else {
                addTocartBtn.isHidden = false
                vipBuyBtn.isHidden = false
                buyRightNowBtn.isHidden = false
                studyBtn.isHidden = true
            }
            if model.productType != 2 && model.productType != 4{
                if model.productType == 5 {
                    return
                }
                if model.isStudy == 1{//开始学习
                    addTocartBtn.isHidden = true
                    vipBuyBtn.isHidden = true
                    buyRightNowBtn.isHidden = true
                    studyBtn.setTitle("开始学习", for: .normal)
                    studyBtn.isHidden = false
                    studyBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.height)
                }else{
                    addTocartBtn.isHidden = false
                    vipBuyBtn.isHidden = false
                    buyRightNowBtn.isHidden = false
                    studyBtn.isHidden = true
                }
            }
            self.addTocartBtn.setTitle("加入购物车", for: .normal)
            self.addTocartBtn.titleLabel?.font = DEF_FontSize_14
            self.addTocartBtn.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
            self.addTocartBtn.setTitleColor(UIColor.white, for: .normal)
            self.addTocartBtn.layer.borderColor = UIColor.clear.cgColor
            self.addTocartBtn.layer.borderWidth = 0
            self.addTocartBtn.tag = 2000
            if model.productType == 3 {
                if model.objectType == 3 {
                    addTocartBtn.isHidden = false
                    vipBuyBtn.isHidden = false
                    buyRightNowBtn.isHidden = false
                    studyBtn.isHidden = true
                    self.addTocartBtn.setTitle("前去开课", for: .normal)
                    self.addTocartBtn.titleLabel?.font = DEF_FontSize_14
                    self.addTocartBtn.setBackgroundColor(UIColor.clear, forState: .normal)
                    self.addTocartBtn.setTitleColor(UIColor.colorWithHex(hex: "4AA1F0"), for: .normal)
                    self.addTocartBtn.layer.borderColor = UIColor.colorWithHex(hex: "4AA1F0").cgColor
                    self.addTocartBtn.layer.borderWidth = 0.8
                    self.addTocartBtn.tag = 2001
                }
            }
        }
    }
    
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var addCartButton: UIButton!
    @IBOutlet weak var consultButton: UIButton!
    @IBOutlet var view: UIView!
    
    lazy var buyRightNowBtn : UIButton = {
        weak var weakSelf = self
        var buyRightNowBtn = UIButton.init(frame: CGRect(x: (weakSelf?.addTocartBtn.right)! + 35/WIDTH_6_SCALE, y: 7/WIDTH_6_SCALE, width: 105/WIDTH_6_SCALE, height: (weakSelf?.addTocartBtn.height)!))
        buyRightNowBtn.setTitle("立即购买", for: .normal)
        buyRightNowBtn.setBackgroundColor(UIColor.ColorHex("4AA1F0"), forState: .normal)
        buyRightNowBtn.setTitleColor(.white, for: .normal)
        buyRightNowBtn.titleLabel?.font = DEF_FontSize_14
        buyRightNowBtn.addTarget(self, action: #selector(buyButtonClick), for: .touchUpInside)
        return buyRightNowBtn
    }()
    
    lazy var addTocartBtn : UIButton = {
        var addTocartBtn = UIButton.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: 7/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: self.height - 14/WIDTH_6_SCALE))
        addTocartBtn.setTitle("加入购物车", for: .normal)
        addTocartBtn.titleLabel?.font = DEF_FontSize_14
        addTocartBtn.addTarget(self, action: #selector(addToCart(btn:)), for: .touchUpInside)
        addTocartBtn.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        addTocartBtn.setTitleColor(UIColor.white, for: .normal)
        addTocartBtn.layer.cornerRadius = (self.height - 14/WIDTH_6_SCALE)/2
        addTocartBtn.layer.masksToBounds = true
        return addTocartBtn
    }()
    
    lazy var vipBuyBtn : UIButton = {
        weak var weakSelf = self
        var vipBuyBtn = UIButton.init(frame: CGRect(x: weakSelf!.buyRightNowBtn.right, y: 7/WIDTH_6_SCALE, width: 105/WIDTH_6_SCALE, height: weakSelf!.height - 14/WIDTH_6_SCALE))
        vipBuyBtn.setTitle("升级VIP会员", for: .normal)
        vipBuyBtn.setTitleColor(.white, for: .normal)
        vipBuyBtn.titleLabel?.font = DEF_FontSize_14
        vipBuyBtn.setBackgroundImage(UIImage.init(named: "goodsdetail_vip_button_bg"), for: .normal)
        vipBuyBtn.addTarget(self, action: #selector(vipBuyBtnClick(btn:)), for: .touchUpInside)
        return vipBuyBtn
    }()
    
    lazy var studyBtn : UIButton = {
        weak var weakSelf = self
        var studyBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: weakSelf!.height - 14/WIDTH_6_SCALE))
        studyBtn.setTitleColor(UIColor.white, for: .normal)
        studyBtn.titleLabel?.font = DEF_FontSize_14
        studyBtn.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        studyBtn.addTarget(self, action: #selector(buyButtonClick), for: .touchUpInside)
        return studyBtn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initViewFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initViewFromNib()
    }
    
    private func initViewFromNib(){
        // 需要这句代码，不能直接写UINib(nibName: "MyView", bundle: nil)，不然不能在storyboard中显示
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "GoodsDetailBottomView", bundle: bundle)
        self.view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        self.view.frame = bounds
        self.addSubview(view)
        baseConfigure()
        // Do any additional setup after loading the view.
    }
    
    func baseConfigure() {
        buyButton.isHidden = true
        addCartButton.isHidden = true
        
        self.view.addSubview(self.buyRightNowBtn)
        self.view.addSubview(self.addTocartBtn)
        self.view.addSubview(self.vipBuyBtn)
        self.view.addSubview(self.studyBtn)
        self.studyBtn.isHidden = true
        self.configRectCorner(view: vipBuyBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: self.height - 14/WIDTH_6_SCALE, height: self.height - 14/WIDTH_6_SCALE))
        self.configRectCorner(view: buyRightNowBtn, corner: [.topLeft, .bottomLeft], radii: CGSize(width: self.height - 14/WIDTH_6_SCALE, height: self.height - 14/WIDTH_6_SCALE))
        CartHelper.shared.updateLearnCard()
        consultButton.setTitle("APP 暂不支持购买，请去官网咨询客服", for: .normal)
        consultButton.backgroundColor = UIColor.mainRedColor
        
        self.isMember = 0
        if let userModel = LoginHelper.getLocalUser() {//已登录状态
            if userModel.isMember == 1 {
                self.isMember = 1
            }
        }
    }
    
    @objc func addToCart(btn: UIButton) {
        if btn.tag == 2000 {
            LoginHelper.checkLoginStatus {
                self.requestAddToCart()
            }
        }else{
            self.goForActiveClassBlock?()
            print("前去开课")
        }
    }
    
    func requestAddToCart() {
        HUD.loading(text: "")
        UserHelper.shared.addGoodsToCart(productID: self.productID, type: self.goodsType, count: self.count)
            .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                model.errorDeal(successBlock: {
                    HUD.hideLoading()
                    HUD.showText(text: model.message ?? "添加成功")
                    CartHelper.shared.loadData()
                })
                }, onError: { (error) in
                    HUD.hideLoading()
            }).disposed(by: disposeBag)
    }
    
    @objc func buyButtonClick() {
        self.stopPlayVideoBlock!()
        HUD.loading(text: "")
        LoginHelper.getLoginStatus(completion: {
            HUD.hideLoading()
            if self.model?.productType != 2 && self.model?.productType != 4{
                if self.model!.isStudy == 1{
                    //课程
                    CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: false)
                    CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
                }else{
//                    //线上课程购买
//                    self.buyOnlineClassBlock?()
                    self.buyGoods()
                }
            }else{
                self.buyGoods()
            }
        }) {
            HUD.hideLoading()
            if self.model!.productType != 2 && self.model!.productType != 4{
                self.alertViewBlock?()
            }else{
                let loginVC = R.storyboard.login.instantiateInitialViewController()!
                CurrentControllerHelper.presentViewController(viewController: loginVC)
            }
        }
    }
    //    productType: 1、在线课程  2、书籍  3、班级(objectType: 1、开课卡远程班  2、面授  3、付费远程班)  4、实物  5、直播课程
    @objc func buyGoods() {
        guard let model = self.model else {
            return
        }
        model.price = model.basicPrice
        let string = model.toJSON()
        guard let goodsModel = CartGoodsModel(JSON: string)  else {
            return
        }
        goodsModel.count = 1
        goodsModel.type = model.productType
        if model.basicPrice <= 0 {
            
            guard let value = SubmitOrderGoodsModel(JSONString: goodsModel.toJSONString() ?? "") else {
                return
            }
            HUD.loading(text: "")
            UserHelper.shared.saveOrder(totalPrice: 0.0, discountPrice: "0", payMode: "1", addressID: 0, distributionMode: 1, couponIDs: "", ruleIDs: "", invoiceID: "", productList: [value])
                .asObservable()
                .subscribe(onNext: { (result) in
                    HUD.hideLoading()
                    if result.code != 200 {
                        self.showMessageBlock?(result.message!)
                    }
                    result.errorDeal(successBlock: {
                        HUD.hideLoading()
                        HUD.showText(text: "请去个人中心-我的学习，进行学习")
                        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: false)
                        CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
                        
                    })
                }, onError: { (error) in
                    HUD.hideLoading()
                    HUD.showError(error: error.localizedDescription)
                })
                .disposed(by: disposeBag)
        } else {
            let vc = R.storyboard.cart.confirmOrderViewController()!
            vc.isMember = self.isMember
            vc.selectedArray = [goodsModel]
            vc.applePayID = model.applePayID
            vc.isStudyCardPay = model.isStudyCardPay
            vc.productType = Int(self.goodsType)!
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
    
    func isExpired(time:String) -> Bool {
        let dformatters = DateFormatter.init()
        dformatters.dateFormat = "yyyy-MM-dd"
        let now = NSDate()
        //let dateString1 = "2017-07-06 13:40"
        let date1 = dformatters.date(from: time)
        //let dateString2 = "2017-07-06 13:41"
        //let date2 = dformatters.date(from: dateString2)
        if date1?.compare(now as Date) == ComparisonResult.orderedAscending {
            //print("date1 is earlier")
            return false
        } else if date1?.compare(now as Date) == ComparisonResult.orderedDescending {
            //print("date2 is earlier")
            return true
        } else if date1?.compare(now as Date) == ComparisonResult.orderedSame {
            //print("Same date!!!")
        }
        return true
    }
    
    /// 圆角设置/部分圆角
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
    
    @objc func vipBuyBtnClick(btn: UIButton){
        print("\(btn.tag)")
        if btn.tag == 1002 {
//            self.vipBuyBlock?()
            self.buyGoods()
        }
        if btn.tag == 1000{
            let vc = MemberPublicityViewController.init()
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 1001 {
            self.goForStudyBlock?()
        }
    }
}
