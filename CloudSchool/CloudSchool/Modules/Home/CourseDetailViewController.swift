//
//  CourseDetailViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/10/30.
//  Copyright © 2018 CEI. All rights reserved.
//
//
//UserHelper.shared.getNewCouponList()
import UIKit
import RxSwift
import RxCocoa
import Segmentio
import WebKit
import ZFPlayer
/* 显示页面ID（6：现场培训主页顶部、7：在线课程主页顶部、8：在线课程主页侧栏、9：在线课程详情、10：现场培训详情、11：在线课程详情） */
enum RecommendType {
    
}

class CourseDetailViewController: UIViewController, UINavigationControllerDelegate {
    var isPushIn: Bool = false
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var segment: Segmentio!
    @IBOutlet weak var webViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var bottomView: GoodsDetailBottomView!
    @IBOutlet weak var goodsImageView: UIImageView!
    var isStudyCardPay: Int = 0//0 不可用  1 可以用
    let imgW = 70/375 * SCREEN_WIDTH
    @IBOutlet weak var storyboardBottomViewH: NSLayoutConstraint!
    var videoURL: String = ""
    var qrCodeImageUrl: String = ""
    var wechatNumber: String = ""
    var goForCardActiveBtnStatus: Int = 0 // 0.前去开课  1.开始学习  2.0元开课直接提交订单
    var webH: Int = 0
    var couponListArray: [NewCouponList] = [NewCouponList]()//优惠券列表
//    public var myClassBlock:(()->())?//productType = 3的时候跳到我的班级
    var characteristicArray: [String] = [String]()
    var liveClassLeftBtnMode: Int = 0//1.立即购买  2.免费学习
    var liveClassRightBtnMode: Int = 0//1.邀请码   2.手机号
    var isMember: Int = 0//0.非会员   1.会员
    var controlView: ZFPlayerControlView = {
        let view = ZFPlayerControlView()
        view.fastViewAnimated = true
        return view
    }()
    
    @IBOutlet weak var goodsImageHeight: NSLayoutConstraint!//名写错了，应该是goodsImageBGHeight
    @IBOutlet weak var goodsImageBottom: NSLayoutConstraint!//图片的底
    lazy var coverWebView: WKWebView = {
        weak var weakSelf = self
        let jsString = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}"
        var wkUScript = WKUserScript.init(source: jsString, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        var wkUController = WKUserContentController.init()
                wkUController.addUserScript(wkUScript)
        var wkWebConfig = WKWebViewConfiguration.init()
        wkWebConfig.userContentController = wkUController
        var coverWebView = WKWebView.init(frame: CGRect(x: 0, y: (weakSelf?.webView.top)!, width: SCREEN_WIDTH, height: 200), configuration: wkWebConfig)
        coverWebView.scrollView.bounces = true
        coverWebView.scrollView.showsHorizontalScrollIndicator = false
        coverWebView.scrollView.isScrollEnabled = false
        coverWebView.uiDelegate = self
        coverWebView.navigationDelegate = self
        coverWebView.backgroundColor = UIColor.clear
        return coverWebView
    }()
    
    var inviteModel: InviteCodeModel?
    
    var model: ProductDetailModel? {
        didSet {
            self.getInviteCode()
        }
    }
    var recommendArr: [RecommonModel] = [RecommonModel]()//推荐数据
    var inviteCode: String?
    
    var currentIndex: Int = 0 {
        didSet {
            self.scrollView.setContentOffset(CGPoint(x: currentIndex.cgFloat * self.scrollView.width, y: 0), animated: true)
        }
    }
    
    var productID: String = "" {
        didSet {
//            loadData()
        }
    }
    var orderID : Int = 0//推荐人填写时用到订单ID
    var groupBuyID : Int = 0//团购ID
    var productGroupType : Int = 0//商品是否为团购
    let disposeBag: DisposeBag = DisposeBag()
    var productType: Int = 0//商品类型
    var objectType: Int = 0//班级(objectType: 1、开课卡远程班  2、面授  3、付费远程班)
    var data: [[GoodsDetailCellType]] = []

    var showMessageString: String = "" {
        didSet {
            HUD.showText(text: showMessageString)
        }
    }
    enum GoodsDetailCellType {
        case coupons(_ couponse: [NewCouponList])//优惠券
        case activity(_ model: ActivityModel)//
        case service(_ string: String)//西尔服务
        case buyCount
        case baseInfo(model: ProductDetailModel)//购买信息
        case recommend
        case newRecommend//新推荐
        case specialService(model: ProductDetailModel)//特殊服务
        case courseIntroduce(model: ProductDetailModel)//课程信息
        case freePost(model: ProductDetailModel) //运费免费
    }
    
    @IBOutlet weak var goodsTableView: UITableView!
    
    @IBOutlet weak var goodImageBGView: UIView!
    @IBOutlet weak var tableViewHeaderView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        loadData()
        let itemBtn = UIBarButtonItem.init(customView: self.backBtn)
        self.navigationItem.leftBarButtonItem = itemBtn
        self.bottomView.showMessageBlock = {(message) in
            self.showAlert(title: message, message: "")
        }
        self.bottomView.goForActiveClassBlock = {
            LoginHelper.getLoginStatus(completion: {
                self.learnCardActiveView.showView()
            }) {
                let loginVC = R.storyboard.login.instantiateInitialViewController()!
                CurrentControllerHelper.presentViewController(viewController: loginVC)
            }
        }
        self.bottomView.goForStudyBlock = {
            //免费学习
            self.submitFreeOrder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getInviteCode()
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        if !self.videoURL.isEmpty {
            self.player.assetURL = URL.init(string: self.videoURL)!
            self.player.shouldAutoPlay = true
        }
        loadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !self.videoURL.isEmpty {
            self.player.stop()
        }
        UIView.animate(withDuration: 0.15, animations: {
            self.fillInReferrerView.alpha = 0
            self.groupBuyDetailView.alpha = 0
            self.groupBuyDetailView.alpha = 0
            self.learnCardActiveView.alpha = 0
            self.liveClassPhoneView.alpha = 0
            self.liveClassInviteCodeView.alpha = 0
        }) { (Bool) in
            self.fillInReferrerView.removeFromSuperview()
            self.groupBuyDetailView.removeFromSuperview()
            self.groupBuyDetailView.removeFromSuperview()
            self.learnCardActiveView.removeFromSuperview()
            self.liveClassPhoneView.removeFromSuperview()
            self.liveClassInviteCodeView.removeFromSuperview()
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    lazy var fillInReferrerView : FillInReferrerView = {
        var fillInReferrerView = FillInReferrerView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        fillInReferrerView.fillInReferrerViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.fillInReferrerView.alpha = 0
            }) { (Bool) in
                self.fillInReferrerView.removeFromSuperview()
            }
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
            let vc = R.storyboard.cart.confirmOrderViewController()!
            vc.isStudyCardPay = self.isStudyCardPay
            vc.isMember = self.isMember
            vc.selectedArray = [goodsModel]
            vc.productType = goodsModel.type
            vc.applePayID = goodsModel.applePayID
            vc.objectType = self.objectType
            vc.qrCodeImageUrl = self.qrCodeImageUrl
            vc.wechatNumber = self.wechatNumber
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        fillInReferrerView.fillInReferrerViewInfoBlock = {(nameString : String) in
            if nameString.isEmpty == true{
                HUD.showText(text: "姓名不能为空")
                return
            }
            let tempString = nameString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            if tempString.count > 0{
                self.referrerData(nameString: nameString, orderID: self.orderID)
            }else{
                HUD.showText(text: "姓名不能为空")
                return
            }
        }
        return fillInReferrerView
    }()
    
    lazy var backBtn : UIButton = {
        var btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        btn.setBackgroundImage(UIImage.init(named: "clear_back"), for: .normal)
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return btn
    }()
    
    let offlineClassBuyBtn : UIButton = {
        let offlineClassBuyBtn = UIButton.init()
        offlineClassBuyBtn.setTitle("立即购买", for: .normal)
        offlineClassBuyBtn.setBackgroundColor(UIColor.ColorHex("4aa1f1"), forState: .normal)
        offlineClassBuyBtn.setTitleColor(.white, for: .normal)
        offlineClassBuyBtn.addTarget(self, action: #selector(offlineClassBuyBtnClick(btn:)), for: .touchUpInside)
        offlineClassBuyBtn.titleLabel!.font = DEF_FontSize_14
        return offlineClassBuyBtn
    }()
    let liveClassLeftBtn : UIButton = {//直播课程购买
        let liveClassLeftBtn = UIButton.init()
        liveClassLeftBtn.setBackgroundColor(UIColor.ColorHex("4aa1f1"), forState: .normal)
        liveClassLeftBtn.setTitleColor(.white, for: .normal)
        liveClassLeftBtn.addTarget(self, action: #selector(liveClassLeftBtnClick(btn:)), for: .touchUpInside)
        liveClassLeftBtn.titleLabel!.font = DEF_FontSize_14
        return liveClassLeftBtn
    }()
    let liveClassRightBtn : UIButton = {
        let liveClassRightBtn = UIButton.init()
        liveClassRightBtn.setBackgroundColor(.white, forState: .normal)
        liveClassRightBtn.setTitleColor(UIColor.ColorHex("4aa1f1"), for: .normal)
        liveClassRightBtn.addTarget(self, action: #selector(liveClassRightBtnClick(btn:)), for: .touchUpInside)
        liveClassRightBtn.layer.borderColor = UIColor.ColorHex("4aa1f1").cgColor
        liveClassRightBtn.layer.borderWidth = 0.8
        liveClassRightBtn.titleLabel!.font = DEF_FontSize_14
        return liveClassRightBtn
    }()
    
    let liveClassGoForStudyBtn : UIButton = {
        let liveClassGoForStudyBtn = UIButton.init()
        liveClassGoForStudyBtn.setTitle("前去学习", for: .normal)
        liveClassGoForStudyBtn.setBackgroundColor(UIColor.ColorHex("E01212"), forState: .normal)
        liveClassGoForStudyBtn.setTitleColor(.white, for: .normal)
        liveClassGoForStudyBtn.addTarget(self, action: #selector(liveClassGoForStudyBtnClick(btn:)), for: .touchUpInside)
        liveClassGoForStudyBtn.titleLabel!.font = DEF_FontSize_14
        return liveClassGoForStudyBtn
    }()
    
    lazy var goForCardActiveBtn: UIButton = {
        let goForCardActiveBtn = UIButton.init()
        goForCardActiveBtn.setTitle("前去开课", for: .normal)
        goForCardActiveBtn.setBackgroundColor(UIColor.systemRed, forState: .normal)
        goForCardActiveBtn.setTitleColor(.white, for: .normal)
        goForCardActiveBtn.addTarget(self, action: #selector(goForCardActiveBtnClick(btn:)), for: .touchUpInside)
        goForCardActiveBtn.titleLabel!.font = DEF_FontSize_14
        return goForCardActiveBtn
    }()
    //团购价格按钮
    lazy var groupBuyBtn : UIButton = {
        var groupBuyBtn = UIButton.init()
        groupBuyBtn.setTitle("团购购买", for: .normal)
        groupBuyBtn.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        groupBuyBtn.setTitleColor(.white, for: .normal)
        groupBuyBtn.addTarget(self, action: #selector(groupBuyBtnClick(btn:)), for: .touchUpInside)
        groupBuyBtn.titleLabel!.font = DEF_FontSize_14
        return groupBuyBtn
    }()
    //活动说明
    lazy var activityDetailBtn : UIButton = {
        var activityDetailBtn = UIButton.init()
        activityDetailBtn.setTitle("!活动详情", for: .normal)
        activityDetailBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        activityDetailBtn.setTitleColor(.mainRedColor, for: .normal)
        activityDetailBtn.addTarget(self, action: #selector(activityDetailBtnClick(btn:)), for: .touchUpInside)
        activityDetailBtn.titleLabel?.font = DEF_FontSize_14
        return activityDetailBtn
    }()
    //团购时底部栏
    let groupBuyView : UIView = {
        let groupBuyView = UIView.init()
        groupBuyView.backgroundColor = .white
        return groupBuyView
    }()
    //团购详情按钮
    lazy var groupBuyDetailView : GroupBuyDetailView = {
        var groupBuyDetailView = GroupBuyDetailView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        groupBuyDetailView.dismissGroupBuyDetailView = {
            UIView.animate(withDuration: 0.15, animations: {
                self.groupBuyDetailView.alpha = 0
            }) { (Bool) in
                self.groupBuyDetailView.removeFromSuperview()
            }
        }
        groupBuyDetailView.groupBuyIDBlock = {(groupBuyID : Int) in
            self.productGroupType = 1
            self.groupBuyID = groupBuyID
            self.groupBuyDetailView.dismissView()
        }
        return groupBuyDetailView
    }()
    
    //活动详情按钮
    lazy var activityDetailView : ActivityDetailView = {
        var activityDetailView = ActivityDetailView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        activityDetailView.dismissActivityDetailView = {
            UIView.animate(withDuration: 0.15, animations: {
                self.activityDetailView.alpha = 0
            }) { (Bool) in
                self.activityDetailView.removeFromSuperview()
            }
        }
        return activityDetailView
    }()
    
    //直播课邀请码
    lazy var liveClassInviteCodeView : LiveClassInviteCodeView = {
        var liveClassInviteCodeView = LiveClassInviteCodeView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        liveClassInviteCodeView.liveClassInviteCodeViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.liveClassInviteCodeView.alpha = 0
            }) { (Bool) in
                self.liveClassInviteCodeView.removeFromSuperview()
            }
        }
        liveClassInviteCodeView.sureBtnClickBlock = {(codeString) in
            self.liveClassRight(code: codeString, phone: "")
        }
        return liveClassInviteCodeView
    }()
    
    //直播课手机号填写
    lazy var liveClassPhoneView : LiveClassPhoneView = {
        var liveClassPhoneView = LiveClassPhoneView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        liveClassPhoneView.liveClassPhoneViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.liveClassPhoneView.alpha = 0
            }) { (Bool) in
                self.liveClassPhoneView.removeFromSuperview()
            }
        }
        liveClassPhoneView.sureBtnClickBlock = {(phoneString) in
            self.liveClassRight(code: "", phone: phoneString)
        }
        return liveClassPhoneView
    }()
    
    //活动详情按钮
    lazy var learnCardActiveView : LearnCardActiveView = {
        var learnCardActiveView = LearnCardActiveView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        learnCardActiveView.learnCardActiveViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.learnCardActiveView.alpha = 0
            }) { (Bool) in
                self.learnCardActiveView.removeFromSuperview()
            }
        }
        learnCardActiveView.learnCardActiveViewSubmitBlock = {(cardID, activeCode, message) in
            if !message.isEmpty{
                HUD.showText(text: message)
            }else{
                HUD.loading(text: "")
                UserHelper.shared.remoteClassUseCourseCard(cardNo: cardID, code: activeCode, productID: self.productID)
                .subscribe(onNext: { (model) in
                    HUD.hideLoading()
                    model.errorDeal(successBlock: {
                        HUD.loading(text: "开课成功")
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
                            HUD.hideLoading()
                            let vc = PaySuccessViewController.init()
                            vc.productType = self.productType
                            vc.objectType = 1
                            vc.wechatNumber = self.model?.wechatNumber as! String
                            vc.qrCodeImageUrl = self.model?.qrCodeImageUrl as! String
                            CurrentControllerHelper.pushViewController(viewController: vc)
                        })
                    })
                }, onError: { (error) in
                    HUD.hideLoading()
                    HUD.showError(error: error.localizedDescription)
                }).disposed(by: self.disposeBag)
            }
        }
        return learnCardActiveView
    }()
    lazy var vipADView : UIImageView = {
        weak var weakSelf = self
        var vipADView = UIImageView.init()
        vipADView.frame = CGRect(x: 0, y: weakSelf!.tableViewHeaderView.height - 60, width: SCREEN_WIDTH, height: 60)
        vipADView.backgroundColor = .clear
        vipADView.image = UIImage.init(named: "goodsdetail_vip_bg")
        vipADView.isUserInteractionEnabled = true
        return vipADView
    }()
    lazy var vipNextBtn : UIButton = {
        let btnW = 30/WIDTH_6_SCALE
        var vipNextBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 10/WIDTH_6_SCALE - btnW, y: 0, width: btnW, height: btnW))
        vipNextBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        vipNextBtn.setBackgroundColor(.clear, forState: .normal)
        vipNextBtn.setImage(UIImage.init(named: "goodsdetail_vip_next"), for: .normal)
        vipNextBtn.addTarget(self, action: #selector(vipNextBtnClick), for: .touchUpInside)
        vipNextBtn.isUserInteractionEnabled = true
        return vipNextBtn
    }()
    lazy var vipGuideTitleLab : UILabel = {
        var vipGuideTitleLab = UILabel.init(frame: CGRect(x: 100/WIDTH_6_SCALE, y: 10, width: 200/WIDTH_6_SCALE, height: self.vipADView.height - 10))
        vipGuideTitleLab.font = DEF_FontSize_18
        vipGuideTitleLab.backgroundColor = .clear
        vipGuideTitleLab.textColor = .white
        vipGuideTitleLab.textAlignment = .left
        vipGuideTitleLab.text = "升级VIP会员尽享优惠"
        return vipGuideTitleLab
    }()
    func updateData(model: ProductDetailModel) {
        self.model = model
        self.bottomView.model = model
        //courseType 0.精品课  1.VIP课
        //isMember   0.非会员  1.会员
        self.goodsImageHeight.constant = 50
        self.goodsImageBottom.constant = 50
        productTypeImgView.frame = CGRect(x: SCREEN_WIDTH - imgW, y: self.goodImageBGView.height - imgW - 50, width: imgW, height: imgW)
        self.tableViewHeaderView.addSubview(self.vipADView)
        self.vipADView.addSubview(self.vipNextBtn)
        self.vipADView.addSubview(self.vipGuideTitleLab)
        self.vipNextBtn.centerY = self.vipADView.height/2 + 5
        self.bottomView.vipBuyBtn.setTitle("升级VIP会员", for: .normal)
        self.bottomView.vipBuyBtn.tag = 1000//标签点击事件判断用
        self.bottomView.configRectCorner(view: self.bottomView.vipBuyBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: self.bottomView.height - 14/WIDTH_6_SCALE, height: self.bottomView.height - 14/WIDTH_6_SCALE))
        self.vipADView.isHidden = false
        self.bottomView.addTocartBtn.isHidden = false
        self.bottomView.buyRightNowBtn.isHidden = false
        self.isMember = 0
        if let userModel = LoginHelper.getLocalUser() {//已登录状态
            if userModel.isMember == 1 {
                self.isMember = 1
                self.goodsImageHeight.constant = 0
                self.goodsImageBottom.constant = 0
                self.vipADView.isHidden = true
                self.bottomView.addTocartBtn.isHidden = true
                self.bottomView.buyRightNowBtn.isHidden = true
                self.bottomView.vipBuyBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.bottomView.height)
                productTypeImgView.frame = CGRect(x: SCREEN_WIDTH - imgW, y: self.goodImageBGView.height - imgW, width: imgW, height: imgW)
                self.bottomView.configRectCorner(view: self.bottomView.vipBuyBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: 0, height: 0))
                if model.vipPrice == 0.0 {
                    self.bottomView.vipBuyBtn.setTitle("前去学习", for: .normal)
                    self.bottomView.vipBuyBtn.tag = 1001//标签点击事件判断用
                }else{
                    self.bottomView.vipBuyBtn.setTitle("VIP购买", for: .normal)
                    self.bottomView.vipBuyBtn.tag = 1002//标签点击事件判断用
                    if model.productType == 2 {
                        self.bottomView.addTocartBtn.isHidden = false
                        self.bottomView.buyRightNowBtn.isHidden = true
                        self.bottomView.addTocartBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2, height: self.bottomView.height)
                        self.bottomView.vipBuyBtn.frame = CGRect(x: self.bottomView.addTocartBtn.right, y: 0, width: self.bottomView.addTocartBtn.width, height: self.bottomView.addTocartBtn.height)
                        self.bottomView.addTocartBtn.layer.cornerRadius = 0
                        self.bottomView.addTocartBtn.layer.masksToBounds = false
                    }
                }
            }
        }
        if model.courseType == 0 {
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_jingpin_sign")
        }else{
            self.productTypeImgView.image = UIImage.init(named: "goodsdetail_vip_sign")
        }
        //精品或VIP小标的显示
        self.goodsImageView.addSubview(self.productTypeImgView)
        if model.productType == 2 || model.productType == 4{
            self.productTypeImgView.isHidden = true
        }
        
        self.isStudyCardPay = model.isStudyCardPay
        goodsImageView.loadImage(string: model.previewImgUrl)
        var array: [[GoodsDetailCellType]] = []
        var infoArray: [GoodsDetailCellType] = []
        
        self.qrCodeImageUrl = model.qrCodeImageUrl
        self.wechatNumber = model.wechatNumber
        
        infoArray.append(.baseInfo(model: model))
        array.append(infoArray)
        if model.productType == 3 && model.objectType != 2{
            array.append([.specialService(model: model)])
            array.append([.courseIntroduce(model: model)])
            //特色服务
            let splitedArray = model.characteristicList.characters.split{$0 == ","}.map(String.init)
            self.characteristicArray = splitedArray
        }
        
        if model.freeShippingPrice != 0 {
            if model.productType == 2 || model.productType == 4 {
                array.append([.freePost(model: model)])
            }
        }
        var couponArray: [GoodsDetailCellType] = []
//        if let coupon = model.couponList.first {
//            var tempModel: [String] = [String]()
//            for num in 0...model.couponList.count - 1 {
//                tempModel = tempModel + model.couponList[num].getActivityArray()
//            }
//            couponArray.append(.coupons(tempModel))
//        }
        if self.couponListArray.count > 0 {
            couponArray.append(.coupons(self.couponListArray))
        }
        if let activity = model.activityList.first {
            couponArray.append(.activity(activity))
        }
        if WXApi.isWXAppInstalled(){
            if couponArray.count > 0 {
                array.append(couponArray)
            }
        }
//        array.append([.recommend])
        array.append([.newRecommend])
        array.append([.service("西尔提供服务")])
        
        self.data = array
        self.goodsTableView.reloadData()
        bottomView.productID = model.productID.toString()
        bottomView.goodsType = model.productType.toString()
        bottomView.count = "1"
        
        webView.loadHTMLString(model.webIntroduce, baseURL: nil)
        self.coverWebView.loadHTMLString(model.webIntroduce, baseURL: nil)
        segment.setup(content: [SegmentioItem(title: model.productName, image: nil)], style: SegmentioStyle.onlyLabel, options: segment.courseDetailOption)

        segment.valueDidChange = { (seg, index) in
            self.currentIndex = index
        }
        segment.selectedSegmentioIndex = 0
        
        if model.productType == 3{
            self.objectType = model.objectType
            self.offlineClassBuyBtn.frame = bottomView.frame
            self.view.addSubview(self.offlineClassBuyBtn)
            bottomView.isHidden = true
            if model.isGroup == 1{
                self.groupBuyDetailView.cellArray = model.groupBuyList
                self.activityDetailView.cellArray = model.groupBuyList
                self.groupBuyView.frame = bottomView.frame
                self.view.addSubview(self.groupBuyView)
                self.offlineClassBuyBtn.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH/2 - 50/WIDTH_6_SCALE, height: self.groupBuyView.height)
                self.groupBuyView.addSubview(self.offlineClassBuyBtn)
                self.groupBuyBtn.frame = CGRect(x: self.offlineClassBuyBtn.right, y: self.offlineClassBuyBtn.top, width: self.offlineClassBuyBtn.width, height: self.offlineClassBuyBtn.height)
                self.groupBuyView.addSubview(self.groupBuyBtn)
                self.activityDetailBtn.frame = CGRect(x: self.groupBuyBtn.right, y: self.groupBuyBtn.top, width: SCREEN_WIDTH - self.groupBuyBtn.right, height: self.groupBuyBtn.height)
                self.groupBuyView.addSubview(self.activityDetailBtn)
            }
            let date = self.isExpired(time: self.model!.closeTime)//false:过期   true:未过期
            if date == false {
                self.offlineClassBuyBtn.setTitle("课程已过期", for: .normal)
                self.offlineClassBuyBtn.setBackgroundColor(UIColor.colorWithHex(hex: "888888"), forState: .normal)
                self.offlineClassBuyBtn.setTitleColor(UIColor.white, for: .normal)
                self.offlineClassBuyBtn.isUserInteractionEnabled = false
            }
        }
        //以下能用到本类的upgradeBtn按钮
        self.upgradeBtn.setTitle("升级VIP会员", for: .normal)
        self.upgradeBtn.isHidden = true
        if productType == 1 || productType == 3 || productType == 5 {
            if productType == 3 {
                if model.isPay == 0 {//未支付
                    self.goForCardActiveBtnStatus = 0
                }else{
                    self.goForCardActiveBtnStatus = 2
                }
                if model.isStudy == 1 {
                    self.view.addSubview(self.goForCardActiveBtn)
                    self.goForCardActiveBtn.setTitle("开始学习", for: .normal)
                    self.goForCardActiveBtnStatus = 1
                    self.goForCardActiveBtn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - self.bottomView.height - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT), width: SCREEN_WIDTH, height: self.bottomView.height)
                    self.offlineClassBuyBtn.isHidden = true
                    self.goForCardActiveBtn.isHidden = false
                }else if model.objectType == 3 {
                    self.bottomView.isHidden = false
                    self.offlineClassBuyBtn.isHidden = true
                    self.goForCardActiveBtn.isHidden = true
                }else if model.objectType == 1 {
                    self.view.addSubview(self.goForCardActiveBtn)
                    self.offlineClassBuyBtn.isHidden = true
                    self.goForCardActiveBtn.isHidden = false
                    self.goForCardActiveBtn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - self.bottomView.height - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT), width: SCREEN_WIDTH, height: self.bottomView.height)
                }else if model.objectType == 2{
                    self.upgradeBtn.isHidden = false
                    self.view.addSubview(self.upgradeBtn)
                    if self.isMember == 1 {//会员
                        self.offlineClassBuyBtn.isHidden = true
                        self.upgradeBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH, height: self.bottomView.height)
                        self.upgradeBtn.setTitle("VIP购买", for: .normal)
                    }else{//非会员
                        self.offlineClassBuyBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH/2, height: self.bottomView.height)
                        self.upgradeBtn.frame = CGRect(x: self.offlineClassBuyBtn.right, y: self.offlineClassBuyBtn.top, width: self.offlineClassBuyBtn.width, height: self.offlineClassBuyBtn.height)
                    }
                }
                let date = self.isExpired(time: self.model!.closeTime)//false:过期   true:未过期
                if date == false {
                    self.view.addSubview(self.goForCardActiveBtn)
                    self.goForCardActiveBtn.frame = CGRect(x: 0, y: SCREEN_HEIGHT - self.bottomView.height - CGFloat(NAVI_HEIGHT) - CGFloat(BOTTOM_HEIGHT), width: SCREEN_WIDTH, height: self.bottomView.height)
                    self.goForCardActiveBtn.setTitle("课程已过期", for: .normal)
                    self.goForCardActiveBtn.setBackgroundColor(UIColor.colorWithHex(hex: "888888"), forState: .normal)
                    self.goForCardActiveBtn.setTitleColor(UIColor.white, for: .normal)
                    self.goForCardActiveBtn.isUserInteractionEnabled = false
                    self.offlineClassBuyBtn.isHidden = true
                }
            }
            if model.productType == 5 {
                self.bottomView.isHidden = true
                self.offlineClassBuyBtn.isHidden = true
                self.goForCardActiveBtn.isHidden = true
                if model.isStudy == 1 {//去学习
                    self.view.addSubview(self.liveClassGoForStudyBtn)
                    self.liveClassGoForStudyBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH, height: self.bottomView.height)
                }else{
                    self.view.addSubview(self.liveClassLeftBtn)
                    self.view.addSubview(self.liveClassRightBtn)
                    self.view.addSubview(self.upgradeBtn)
                    self.liveClassLeftBtn.frame = CGRect(x: 33/WIDTH_6_SCALE, y: self.bottomView.top + 9, width: SCREEN_WIDTH/2 - 19/WIDTH_6_SCALE - 33/WIDTH_6_SCALE, height: self.bottomView.height - 18)
                    self.liveClassRightBtn.frame = CGRect(x: 19/WIDTH_6_SCALE + SCREEN_WIDTH/2, y: self.liveClassLeftBtn.top, width: self.liveClassLeftBtn.width, height: self.liveClassLeftBtn.height)
                    self.configRectCorner(view: self.liveClassLeftBtn, corner: [.topLeft, .bottomLeft], radii: CGSize(width: 0, height: 0))
                    self.liveClassLeftBtn.layer.cornerRadius = self.liveClassLeftBtn.height/2
                    self.liveClassLeftBtn.layer.masksToBounds = true
                    self.liveClassRightBtn.layer.cornerRadius = self.liveClassLeftBtn.layer.cornerRadius
                    self.liveClassRightBtn.layer.masksToBounds = true
                    if (model.isPay == 1 && model.basicPrice <= 0 && model.mode == 1) {
                        //免费学习
                        //邀请码
                        self.liveClassLeftBtn.setTitle("免费学习", for: .normal)
                        self.liveClassRightBtn.setTitle("邀请码", for: .normal)
                        self.liveClassLeftBtnMode = 2
                        self.liveClassRightBtnMode = 1
                    } else if (model.isPay == 1 && model.basicPrice > 0 && model.mode == 1) {
                        //立即支付
                        //邀请码
                        self.liveClassLeftBtn.layer.cornerRadius = 0
                        self.liveClassLeftBtn.layer.masksToBounds = false
                        self.liveClassRightBtn.layer.cornerRadius = self.liveClassLeftBtn.height/2
                        self.liveClassRightBtn.layer.masksToBounds = true
                        self.liveClassLeftBtn.setTitle("立即购买", for: .normal)
                        self.liveClassRightBtn.setTitle("邀请码", for: .normal)
                        if self.isMember == 0 {//非会员
                            self.upgradeBtn.isHidden = false
                            self.liveClassRightBtn.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 7/WIDTH_6_SCALE + self.bottomView.top, width: 100/WIDTH_6_SCALE, height: self.bottomView.height - 14/WIDTH_6_SCALE)
                            self.liveClassLeftBtn.frame = CGRect(x: self.liveClassRightBtn.right + 35/WIDTH_6_SCALE, y: self.liveClassRightBtn.top, width: 105/WIDTH_6_SCALE, height: self.liveClassRightBtn.height)
                            self.upgradeBtn.frame = CGRect(x: self.liveClassLeftBtn.right, y: self.liveClassLeftBtn.top, width: self.liveClassLeftBtn.width, height: self.liveClassLeftBtn.height)
                            self.configRectCorner(view: self.upgradeBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: self.upgradeBtn.height - 14/WIDTH_6_SCALE, height: self.upgradeBtn.height - 14/WIDTH_6_SCALE))
                            self.configRectCorner(view: self.liveClassLeftBtn, corner: [.topLeft, .bottomLeft], radii: CGSize(width: self.liveClassRightBtn.height - 14/WIDTH_6_SCALE, height: self.liveClassRightBtn.height - 14/WIDTH_6_SCALE))
                        }else{//会员
                            self.liveClassLeftBtn.setTitle("VIP购买", for: .normal)
                            self.liveClassRightBtn.frame = CGRect(x: 33/WIDTH_6_SCALE, y: self.bottomView.top + 9, width: SCREEN_WIDTH/2 - 19/WIDTH_6_SCALE - 33/WIDTH_6_SCALE, height: self.bottomView.height - 18)
                            self.liveClassLeftBtn.frame = CGRect(x: 19/WIDTH_6_SCALE + SCREEN_WIDTH/2, y: self.liveClassRightBtn.top, width: self.liveClassRightBtn.width, height: self.liveClassRightBtn.height)
                        }
                        self.liveClassLeftBtnMode = 1
                        self.liveClassRightBtnMode = 1
                    } else if (model.isPay == 1 && model.basicPrice <= 0 && model.mode == 2) {
                        // 免费学习
                        // 手机号
                        self.liveClassLeftBtn.setTitle("免费学习", for: .normal)
                        self.liveClassRightBtn.setTitle("手机号激活", for: .normal)
                        self.liveClassLeftBtnMode = 2
                        self.liveClassRightBtnMode = 2
                    } else if (model.isPay == 1 && model.basicPrice > 0 && model.mode == 2) {
                        //立即支付
                        // 手机号
                        self.liveClassLeftBtn.layer.cornerRadius = 0
                        self.liveClassLeftBtn.layer.masksToBounds = false
                        self.liveClassRightBtn.layer.cornerRadius = self.liveClassLeftBtn.height/2
                        self.liveClassRightBtn.layer.masksToBounds = true
                        self.liveClassLeftBtn.setTitle("立即购买", for: .normal)
                        self.liveClassRightBtn.setTitle("手机号激活", for: .normal)
                        if self.isMember == 0 {//非会员
                            self.upgradeBtn.isHidden = false
                            self.liveClassRightBtn.frame = CGRect(x: 15/WIDTH_6_SCALE, y: 7/WIDTH_6_SCALE + self.bottomView.top, width: 100/WIDTH_6_SCALE, height: self.bottomView.height - 14/WIDTH_6_SCALE)
                            self.liveClassLeftBtn.frame = CGRect(x: self.liveClassRightBtn.right + 35/WIDTH_6_SCALE, y: self.liveClassRightBtn.top, width: 105/WIDTH_6_SCALE, height: self.liveClassRightBtn.height)
                            self.upgradeBtn.frame = CGRect(x: self.liveClassLeftBtn.right, y: self.liveClassLeftBtn.top, width: self.liveClassLeftBtn.width, height: self.liveClassLeftBtn.height)
                            self.configRectCorner(view: self.upgradeBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: self.upgradeBtn.height - 14/WIDTH_6_SCALE, height: self.upgradeBtn.height - 14/WIDTH_6_SCALE))
                            self.configRectCorner(view: self.liveClassLeftBtn, corner: [.topLeft, .bottomLeft], radii: CGSize(width: self.liveClassRightBtn.height - 14/WIDTH_6_SCALE, height: self.liveClassRightBtn.height - 14/WIDTH_6_SCALE))
                        }else{//会员
                            self.upgradeBtn.isHidden = false
                            self.upgradeBtn.setTitle("VIP购买", for: .normal)
                            self.liveClassRightBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH/2, height: self.bottomView.height)
                            self.upgradeBtn.frame = CGRect(x: self.liveClassRightBtn.right, y: self.liveClassRightBtn.top, width: self.liveClassRightBtn.width, height: self.liveClassRightBtn.height)
                            self.liveClassRightBtn.layer.masksToBounds = false
                            self.liveClassRightBtn.layer.cornerRadius = 0
                        }
                        self.liveClassLeftBtnMode = 1
                        self.liveClassRightBtnMode = 2
                    } else if (model.isPay == 1 && model.basicPrice <= 0 && model.mode == 0) {
                        // 免费学习
                        self.liveClassLeftBtn.setTitle("免费学习", for: .normal)
                        self.liveClassRightBtn.isHidden = true
                        self.liveClassLeftBtnMode = 2
                        self.liveClassLeftBtn.centerX = SCREEN_WIDTH/2
                    } else if (model.isPay == 1 && model.basicPrice > 0 && model.mode == 0) {
                        //立即支付
                        self.liveClassRightBtn.isHidden = true
                        self.liveClassLeftBtnMode = 1
                        self.upgradeBtn.isHidden = false
                        if self.isMember == 1 {
                            self.upgradeBtn.setTitle("VIP购买", for: .normal)
                            self.upgradeBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH, height: self.bottomView.height)
                        }else{
                            self.liveClassLeftBtn.setTitle("立即购买", for: .normal)
                            self.liveClassLeftBtn.frame = CGRect(x: 0, y: self.bottomView.top, width: SCREEN_WIDTH/2, height: self.bottomView.height)
                            self.upgradeBtn.frame = CGRect(x: self.liveClassLeftBtn.right, y: self.liveClassLeftBtn.top, width: self.liveClassLeftBtn.width, height: self.liveClassLeftBtn.height)
                            self.configRectCorner(view: self.liveClassLeftBtn, corner: [.topRight, .bottomRight], radii: CGSize(width: 0, height: 0))
                            self.liveClassLeftBtn.layer.cornerRadius = 0
                            self.liveClassLeftBtn.layer.masksToBounds = false
                        }
                    } else if (model.isPay == 0 && model.mode == 1) {
                        //邀请码
                        self.liveClassLeftBtn.isHidden = true
                        self.liveClassRightBtn.setTitle("邀请码", for: .normal)
                        self.liveClassRightBtnMode = 1
                        self.liveClassRightBtn.centerX = SCREEN_WIDTH/2
                    } else if (model.isPay == 0 && model.mode == 2) {
                        // 手机号
                        self.liveClassLeftBtn.isHidden = true
                        self.liveClassRightBtn.setTitle("手机号激活", for: .normal)
                        self.liveClassRightBtnMode = 2
                        self.liveClassRightBtn.centerX = SCREEN_WIDTH/2
                    }else {
                        //全隐藏
                        self.liveClassLeftBtn.isHidden = true
                        self.liveClassRightBtn.isHidden = true
                        self.storyboardBottomViewH.constant = 0
                        self.view.layoutIfNeeded()
                    }
                }
            }
            
            if model.trySeeVideoUrl.isEmpty {
                return
            }
            self.controlView.addSubview(self.productTypeImgView)
            self.videoURL = model.trySeeVideoUrl
            self.player.assetURL = URL.init(string: model.trySeeVideoUrl)!
        }
    }
    
    lazy var upgradeBtn : UIButton = {
        var upgradeBtn = UIButton.init()
        upgradeBtn.setTitle("升级VIP会员", for: .normal)
        upgradeBtn.setTitleColor(UIColor.white, for: .normal)
        upgradeBtn.titleLabel?.font = DEF_FontSize_14
        upgradeBtn.setBackgroundImage(UIImage.init(named: "goodsdetail_vip_button_bg"), for: .normal)
        upgradeBtn.addTarget(self, action: #selector(upgradeBtnClick(btn:)), for: .touchUpInside)
        return upgradeBtn
    }()
    
    lazy var manager: ZFAVPlayerManager = {
        var manager = ZFAVPlayerManager.init()
        return manager
    }()
    
    lazy var player: ZFPlayerController = {
        var player = ZFPlayerController(playerManager: self.manager, containerView: self.goodsImageView)
        player.isPauseByEvent = true
        player.controlView = self.controlView
        player.shouldAutoPlay = true
        return player
    }()
    
    lazy var productTypeImgView : UIImageView = {
        weak var weakSelf = self
//        let imgW = 70/375 * SCREEN_WIDTH
        var productTypeImgView = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH - imgW, y: (weakSelf?.goodsImageView.height)! - imgW, width: imgW, height: imgW))
        productTypeImgView.backgroundColor = UIColor.clear
        return productTypeImgView
    }()
    
    func configureUI() {
        goodsTableView.backgroundColor = UIColor.backgroundColor
        goodsTableView.register(R.nib.goodsCouponTableViewCell)
        goodsTableView.register(R.nib.goodsServiceTableViewCell)
        goodsTableView.register(R.nib.goodsBuyCountTableViewCell)
        goodsTableView.register(GoodsDetailInforNewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GoodsDetailInforNewTableViewCell.self))
        goodsTableView.register(R.nib.goodsActivityTableViewCell)
        goodsTableView.register(RecommendNewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RecommendNewTableViewCell.self))
        goodsTableView.register(SpecialServiceTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SpecialServiceTableViewCell.self))
        goodsTableView.register(CourseIntroduceTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CourseIntroduceTableViewCell.self))
        goodsTableView.register(CourseDetailFreePostTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(CourseDetailFreePostTableViewCell.self))
        goodsTableView.register(R.nib.shareActivityTableViewCell)
        goodsTableView.dataSource = self
        goodsTableView.delegate = self
        
        webView.delegate = self
        webView.scrollView.isScrollEnabled = false
        
        shareButton.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        self.shareButton.isHidden = true
        if WXApi.isWXAppInstalled(){
            self.shareButton.isHidden = false
        }
        
        self.scrollView.addSubview(self.coverWebView)
        self.bottomView.stopPlayVideoBlock = {
            if !self.videoURL.isEmpty {
//                self.manager.stop()
//                self.manager.pause()
                self.player.stop()
            }
        }
        self.bottomView.alertViewBlock = {
            let alert = UIAlertController(title: "请选择购买方式", message: nil, preferredStyle: .alert)
            let accountLogin = UIAlertAction(title: "账号登录购买", style: .default) { (UIAlertAction) in
                //确定的操作
                let loginVC = R.storyboard.login.instantiateInitialViewController()!
                CurrentControllerHelper.presentViewController(viewController: loginVC)
            }
            let visitorLogin = UIAlertAction(title: "游客模式购买", style: .default) { (UIAlertAction) in
                //确定的操作
                UserHelper.shared.touristRegister().asObservable()
                    .subscribe(onNext: {[weak self] (result) in
                        guard let `self` = self else { return }
                        if let user = result.data {
                            UserDefaults.User.set(user.token, forKey: .token)
                            LoginHelper.saveLocalUser(user: user)
                        }
                    })
                    .disposed(by: self.disposeBag)
            }
            let cancel = UIAlertAction(title: "取消", style: .cancel) { (UIAlertAction) in
                print("you selected cancel")
            }
            //将Actiont加入到AlertController
            alert.addAction(accountLogin)
            alert.addAction(visitorLogin)
            alert.addAction(cancel)
            CurrentControllerHelper.presentViewController(viewController: alert)
        }
    }
    
    func loadData() {
        guard let productID = productID.emptyToNil() else {
//            HUD.showText(text: "没有产品ID")
            return
        }
        HUD.loading(text: "")
        RequestHelper.shared.getProuct(productID: productID)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                guard let data = model.data else { return }
                UserHelper.shared.getNewCouponList(productID: model.data?.productID ?? 0, productType: model.data?.productType ?? -1).asObservable()
                .subscribe(onNext: {[weak self] (couponListModel) in
                    if couponListModel.code == 200{
                        self?.couponListArray = couponListModel.data
                    }
                    self!.updateData(model: data)
                    }, onError: { (error) in
                        HUD.hideLoading()
                        HUD.showError(error: error.localizedDescription)
                }).disposed(by: self.disposeBag)
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription)
            }).disposed(by: disposeBag)
        
        var viewPageID: Int = 0
        if self.productType == 1 {
            viewPageID = 2
        }
        if self.productType == 2 {
            viewPageID = 17
        }
        if self.productType == 3 {
            viewPageID = 4
        }
        if self.productType == 4 {
            viewPageID = 17
        }
        if self.productType == 5 {
            viewPageID = 4
        }
        HUD.loading(text: "")
        RequestHelper.shared.getRecommendList(viewPageID: viewPageID, pageNo: 1, pageSize: 10)
        .asObservable().subscribe(onNext: {[weak self] (model) in
            HUD.hideLoading()
            guard let `self` = self else { return }
            guard let data = model.data else { return }
            self.recommendArr.removeAll()
            self.recommendArr = data.rows
            self.goodsTableView.reloadData()
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription)
        }).disposed(by: disposeBag)
    }
    
    func getInviteCode() {
        guard let activityID = self.model?.activityMap?.activityID.string.emptyToNil() else {
            return
        }
        HUD.loading(text: "")
        UserHelper.shared.getInviteCode(activityID: activityID, productID: self.productID)
        .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.inviteModel = result.data
                self.inviteCode = result.data?.invitationCode
            })
        .disposed(by: disposeBag)
    }
    
    @objc func btnClick(){
        if self.isPushIn == true {
            HUD.loading(text: "")
            self.navigationController?.popToRootViewController(animated: true)
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
                HUD.hideLoading()
                CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 4
                CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 0
            })
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func shareClick() {
        if let map = self.model?.activityMap, let _ = map.activityCategoryName.emptyToNil() {
            LoginHelper.checkLoginStatus {
                self.doShare()
            }
        } else {
            doShare()
        }
    }
    
    @objc func vipNextBtnClick(){
        print("VIP页面跳转")
        let vc = MemberPublicityViewController.init()
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func upgradeBtnClick(btn: UIButton){
        if btn.titleLabel!.text == "VIP购买" {
            print("vip购买")
        }
        if btn.titleLabel!.text == "升级VIP会员" {
            print("升级vip会员")
        }
    }
    func doShare() {
        guard let model = self.model else {
            return
        }
        var urlString = "http://www.cei.net.cn/mobile/cdetail?id=\(model.productID)"
        if let inviteCode = self.inviteCode?.emptyToNil() {
            urlString.append("&invitationCode=\(inviteCode)")
        }
        var image = self.goodsImageView.image
        var contentType: SSDKContentType = .webPage
        if let base64String = self.inviteModel?.code, let inviteImage = base64String.base64StringImage() {
            image = inviteImage
            contentType = .image
        }
        ShareHelper.customShare(url: URL(string: urlString)!, image: image, title: self.model?.productName, content: self.model?.courseName, contentType: contentType)
    }
    
    @objc func offlineClassBuyBtnClick(btn:UIButton){
        HUD.loading(text: "")
        LoginHelper.getLoginStatus(completion: {
            HUD.hideLoading()
            self.productGroupType = 0
            self.fillInfoData()
        }) {
            HUD.hideLoading()
//            HUD.showText(text: "请重新登录")
            let loginVC = R.storyboard.login.instantiateInitialViewController()!
            CurrentControllerHelper.presentViewController(viewController: loginVC)
        }
    }
    
    @objc func liveClassRightBtnClick(btn: UIButton){
        if self.liveClassRightBtnMode == 1 {
            //邀请码
            self.liveClassInviteCodeView.showView()
        }else{
            //手机号
            self.liveClassPhoneView.showView()
        }
    }
    @objc func liveClassLeftBtnClick(btn: UIButton){
        if self.liveClassLeftBtnMode == 1 {
            //立即购买
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
            let vc = R.storyboard.cart.confirmOrderViewController()!
            vc.isMember = self.isMember
            vc.isStudyCardPay = self.isStudyCardPay
            vc.selectedArray = [goodsModel]
            vc.productType = goodsModel.type
            vc.applePayID = goodsModel.applePayID
            vc.objectType = self.objectType
            vc.qrCodeImageUrl = self.qrCodeImageUrl
            vc.wechatNumber = self.wechatNumber
//            CurrentControllerHelper.pushViewController(viewController: vc)
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goForMyLive"), object: self, userInfo: ["productType": 5])
            //免费学习
            self.submitFreeOrder()
        }
    }
    @objc func liveClassGoForStudyBtnClick(btn: UIButton){
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goForMyLive"), object: self, userInfo: ["productType": 5])
        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: true)
        HUD.loading(text: "")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
            HUD.hideLoading()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updataData"), object: self, userInfo: nil)
            CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
        })
    }
    @objc func goForCardActiveBtnClick(btn: UIButton){
        LoginHelper.getLoginStatus(completion: {
            if self.goForCardActiveBtnStatus == 0 {
                self.learnCardActiveView.showView()
            }
            if self.goForCardActiveBtnStatus == 1 {
                self.startStudy()
            }
            if self.goForCardActiveBtnStatus == 2 {
                self.submitFreeOrder()
            }
        }) {
            let loginVC = R.storyboard.login.instantiateInitialViewController()!
            CurrentControllerHelper.presentViewController(viewController: loginVC)
        }
    }
    @objc func groupBuyBtnClick(btn:UIButton){
        print("团购购买")
        self.groupBuyDetailView.showView()
    }
    @objc func activityDetailBtnClick(btn:UIButton){
        print("活动详情")
        self.activityDetailView.showView()
    }
    @objc func startStudy(){
        if self.productType == 3 {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goForMyClass"), object: self, userInfo: ["productType": 3])
        }
        CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: true)
        HUD.loading(text: "")
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
            HUD.hideLoading()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updataData"), object: self, userInfo: nil)
            CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
        })
    }
    
    @objc func liveClassRight(code: String?, phone: String?){
        HUD.loading(text: "")
        UserHelper.shared.liveClassJoinRight(code: code ?? "", phoneNum: phone ?? "", productID: self.model!.productID).asObservable()
            .subscribe(onNext: {[weak self] (result) in
                HUD.hideLoading()
                self?.liveClassInviteCodeView.dismissView()
                self?.liveClassPhoneView.dismissView()
                if result.code == 200{
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "goForMyLive"), object: self, userInfo: ["productType": 5])
                    CurrentControllerHelper.currentViewController().navigationController?.popToRootViewController(animated: true)
                    HUD.loading(text: "")
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute:{
                        HUD.hideLoading()
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updataData"), object: self, userInfo: nil)
                        CurrentControllerHelper.currentViewController().tabBarController?.selectedIndex = 3
                    })
                }else{
                    HUD.showText(text: result.message ?? "")
                }
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showText(text: error.localizedDescription)
                self.liveClassInviteCodeView.dismissView()
                self.liveClassPhoneView.dismissView()
            })
        .disposed(by: disposeBag)
    }
    
    @objc func submitFreeOrder(){
        var array : [SubmitOrderGoodsNewWithoutVIPModel] = []
        let arrayModel = SubmitOrderGoodsNewWithoutVIPModel(JSONString: self.model?.toJSONString() ?? "")
        if self.isMember == 1 {
            arrayModel?.price = 0
            self.model!.price = 0
        }
        array.append(arrayModel!)
        HUD.loading(text: "")
        UserHelper.shared.saveNewOrderWithoutVip(isGroup: self.productGroupType, addressID: "", discountPrice: "\(self.model!.price)", distributionMode: 1, rulesIDs: "", productType: self.model!.productType, totalPrice: "\(self.model!.price)", invitationCode: "\(self.inviteCode ?? "")", payChannel: 3, productList: array, invoiceID: 0, trafficPay:  "0", couponIDs: "", payMode: "0", recommenderName: "").asObservable().subscribe(onNext: { (result) in
            HUD.hideLoading()
            result.errorDeal(successBlock: {
                HUD.hideLoading()
                if result.code == 200{
                    if self.data != nil {
                        if result.data!.status == 2 {
                            let vc = PaySuccessViewController.init()
                            vc.productType = self.productType
                            vc.objectType = 1
                            vc.wechatNumber = self.model?.wechatNumber as! String
                            vc.qrCodeImageUrl = self.model?.qrCodeImageUrl as! String
                            CurrentControllerHelper.pushViewController(viewController: vc)
                        }
                    }
                    
                }
            })
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    //报名提交姓名
    func submitSchoolRollData(submitName:String){
        HUD.loading(text: "")
        UserHelper.shared.selectOrderStatus(productID: self.model!.productID).asObservable().subscribe(onNext: { (result) in
            HUD.hideLoading()
            if result.code == 500{
                HUD.showText(text: "\(result.message ?? "未知错误")")
            }
            if result.code == 200{
                let dic = [["value":submitName, "property":"name", "displayName":"姓名"]]
                let url = NSURL.init(string: "\(Constant.serverBaseURL)/cei/save_user_class_school_roll")
                let request = NSMutableURLRequest.init(url: url! as URL)
                request.httpMethod = "post"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.setValue(UserDefaults.User.string(forKey: .token), forHTTPHeaderField: "token")
                if let jsonString = dic.jsonString(){
                    let submitString = "{eclassID:\(self.productID), propertyJson:\(jsonString)}"
                    request.httpBody = submitString.data(using: String.Encoding.utf8)
                    request.timeoutInterval = 10.0
                    let queue = OperationQueue.main
                    HUD.loading(text: "")
                    NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: queue) { (response, data, error) in
                        HUD.hideLoading()
                        let dict = self.dataToDictionary(data: data!)
                        if let code = dict!["code"]{
                            if code is Int, let y = code as? Int{
                                if y == 200{
                                    guard let model = self.model else {
                                        return
                                    }
                                    model.price = model.basicPrice
                                    let string = model.toJSON()
                                    guard let submitModel = SubmitOrderGoodsNewModel(JSON: string) else{
                                        return
                                    }
                                    submitModel.count = 1
                                    submitModel.type = self.model!.productType
                                    let value = SubmitOrderGoodsNewModel(JSONString: submitModel.toJSONString()!)
                                    HUD.loading(text: "")
                                    if self.isMember == 0 {//非会员
                                        let ordinaryUserModel = SubmitOrderGoodsNewWithoutVIPModel(JSON: string)
                                        let submitModel = SubmitOrderGoodsNewWithoutVIPModel(JSONString: (ordinaryUserModel?.toJSONString())!)
                                        UserHelper.shared.saveNewOrderWithoutVip(isGroup: self.productGroupType, addressID: "", discountPrice: "\(self.model!.price)", distributionMode: 1, rulesIDs: "", productType: self.model!.productType, totalPrice: "\(self.model!.price)", invitationCode: "\(self.inviteCode ?? "")", payChannel: 3, productList: [submitModel!], invoiceID: 0, trafficPay:  "0", couponIDs: "", payMode: "0", recommenderName: "").asObservable().subscribe(onNext: { (result) in
                                            HUD.hideLoading()
                                            result.errorDeal(successBlock: {
                                                self.orderID = result.data?.orderID ?? 0
                                                if self.productGroupType == 1{//团购订单提交
                                                    HUD.loading(text: "")
                                                    UserHelper.shared.saveGroupBuyInfo(groupBuyID: self.groupBuyID, productID: Int(self.productID)!, orderID: self.orderID).asObservable().subscribe(onNext: { (result) in
                                                        HUD.hideLoading()
                                                        self.fillInfoData()
                                                    }, onError: { (error) in
                                                        HUD.hideLoading()
                                                        HUD.showError(error: error.localizedDescription)
                                                    }).disposed(by: self.disposeBag)
                                                    return
                                                }
                                                HUD.hideLoading()
                                                self.fillInfoData()
                                            })
                                        }, onError: { (error) in
                                            HUD.hideLoading()
                                            HUD.showError(error: error.localizedDescription)
                                        }).disposed(by: self.disposeBag)
                                    }else{//会员
                                        let vipUserModel = SubmitOrderGoodsNewWithVIPModel(JSON: string)
                                        let submitModel = SubmitOrderGoodsNewWithVIPModel(JSONString: (vipUserModel?.toJSONString())!)
                                        UserHelper.shared.saveNewOrderWithVip(isGroup: self.productGroupType, addressID: "", discountPrice: "\(self.model!.price)", distributionMode: 1, rulesIDs: "", productType: self.model!.productType, totalPrice: "\(self.model!.price)", invitationCode: "\(self.inviteCode ?? "")", payChannel: 3, productList: [submitModel!], invoiceID: 0, trafficPay:  "0", couponIDs: "", payMode: "0", recommenderName: "").asObservable().subscribe(onNext: { (result) in
                                            HUD.hideLoading()
                                            result.errorDeal(successBlock: {
                                                self.orderID = result.data?.orderID ?? 0
                                                if self.productGroupType == 1{//团购订单提交
                                                    HUD.loading(text: "")
                                                    UserHelper.shared.saveGroupBuyInfo(groupBuyID: self.groupBuyID, productID: Int(self.productID)!, orderID: self.orderID).asObservable().subscribe(onNext: { (result) in
                                                        HUD.hideLoading()
                                                        self.fillInfoData()
                                                    }, onError: { (error) in
                                                        HUD.hideLoading()
                                                        HUD.showError(error: error.localizedDescription)
                                                    }).disposed(by: self.disposeBag)
                                                    return
                                                }
                                                HUD.hideLoading()
                                                self.fillInfoData()
                                            })
                                        }, onError: { (error) in
                                            HUD.hideLoading()
                                            HUD.showError(error: error.localizedDescription)
                                        }).disposed(by: self.disposeBag)
                                    }
                                } else{
                                    HUD.hideLoading()
                                    HUD.showText(text: "提交失败")
                                }
                            }else{
                                HUD.hideLoading()
                                HUD.showError(error: error!.localizedDescription)
                            }
                        }
                    }
                }
            }
            
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
    //推荐人
    func referrerData(nameString : String, orderID : Int){
        HUD.loading(text: "")
        UserHelper.shared.addReferrerName(orderID: orderID, referrerName: nameString).asObservable().subscribe(onNext: { (result) in
            HUD.hideLoading()
            if result.code == 200{
                //填写推荐人成功，跳到确认订单页面
                UIView.animate(withDuration: 0.15, animations: {
                    self.fillInReferrerView.alpha = 0
                }) { (Bool) in
                    self.fillInReferrerView.removeFromSuperview()
                }
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
                let vc = R.storyboard.cart.confirmOrderViewController()!
                vc.isMember = self.isMember
                vc.isStudyCardPay = self.isStudyCardPay
                vc.selectedArray = [goodsModel]
                vc.productType = 3//面授班级
                vc.applePayID = model.applePayID
                vc.objectType = self.objectType
                vc.qrCodeImageUrl = self.qrCodeImageUrl
                vc.wechatNumber = self.wechatNumber
                CurrentControllerHelper.pushViewController(viewController: vc)
            }else{
                HUD.hideLoading()
                HUD.showText(text: result.message ?? "填写推荐人失败")
            }
        }, onError: { (error) in
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription)
        }).disposed(by: self.disposeBag)
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
    //判断两个日期大小
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
    
    func fillInfoData(){
        if self.model?.objectType == 3 {
            //付费远程班
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
            let vc = R.storyboard.cart.confirmOrderViewController()!
            vc.isMember = self.isMember
            vc.isStudyCardPay = self.isStudyCardPay
            vc.selectedArray = [goodsModel]
            vc.productType = goodsModel.type
            vc.applePayID = goodsModel.applePayID
            vc.objectType = self.objectType
            vc.qrCodeImageUrl = self.qrCodeImageUrl
            vc.wechatNumber = self.wechatNumber
            CurrentControllerHelper.pushViewController(viewController: vc)
            return
        }
        let vc = R.storyboard.study.addSchoolRollViewController()!
        let vm = AddSchoolRollViewModel(eclassID: "\(self.model!.eclassID)")
        vc.bindViewModel(viewModel: vm)
        vm.fillCompleteBlock = {
            self.fillInReferrerView.showView()
        }
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}

extension String {
    func base64StringImage() -> UIImage? {
        var str = self
        // 1、判断用户传过来的base64的字符串是否是以data开口的，如果是以data开头的，那么就获取字符串中的base代码，然后在转换，如果不是以data开头的，那么就直接转换
        if str.hasPrefix("data:image") {
            guard let newBase64String = str.components(separatedBy: ",").last else {
                return nil
            }
            str = newBase64String
        }
        // 2、将处理好的base64String代码转换成NSData
        guard let imgNSData = NSData(base64Encoded: str, options: NSData.Base64DecodingOptions()) else {
            return nil
        }
        // 3、将NSData的图片，转换成UIImage
        guard let codeImage = UIImage(data: imgNSData as Data) else {
            return nil
        }
        return codeImage
    }
}

extension CourseDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = data[indexPath.section][indexPath.row]
        switch model {
        case .coupons(let array):
            let cell : GoodsCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: R.nib.goodsCouponTableViewCell, for: indexPath)!
            cell.configure(coupons: array)
            cell.goodsCouponBlock = {
                let productCouponListView = ProductCouponListView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
                productCouponListView.showView()
                productCouponListView.array = self.couponListArray
                productCouponListView.productCouponListViewDismissBlock = {
                    UIView.animate(withDuration: 0.15, animations: {
                        productCouponListView.alpha = 0
                    }) { (Bool) in
                        productCouponListView.removeFromSuperview()
                    }
                }
            }
            return cell
        case .service(let string):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.goodsServiceTableViewCell, for: indexPath)!
            return cell
        case .buyCount:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.goodsBuyCountTableViewCell, for: indexPath)!
            return cell
        case .baseInfo(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GoodsDetailInforNewTableViewCell.self), for: indexPath) as! GoodsDetailInforNewTableViewCell
            cell.model = self.model
            cell.shareGetMoneyBtnClickBlock = {
                self.didClickReward()
            }
            return cell
        case .activity(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.goodsActivityTableViewCell, for: indexPath)!
            cell.configure(model: model)
            return cell
        case .recommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.recommendTableViewCell, for: indexPath)!
            return cell
        case .newRecommend:
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RecommendNewTableViewCell.self), for: indexPath) as! RecommendNewTableViewCell
            cell.model = self.recommendArr
            cell.recommendToProductDetailBlock = {[weak self](recommendProductType: Int, recommendProductID: Int) in
                self?.productID = "\(recommendProductID)"
                self?.productType = recommendProductType
                self?.loadData()
            }
            return cell
        case .specialService:
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SpecialServiceTableViewCell.self), for: indexPath) as! SpecialServiceTableViewCell
            cell.itemArray = self.characteristicArray
            return cell
        case .courseIntroduce(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CourseIntroduceTableViewCell.self), for: indexPath) as! CourseIntroduceTableViewCell
            cell.model = model
            return cell
        case .freePost(let model):
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(CourseDetailFreePostTableViewCell.self), for: indexPath) as! CourseDetailFreePostTableViewCell
            cell.model = model
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = data[indexPath.section][indexPath.row]
        switch model {
        case .baseInfo(let model):
            if let shareModel = model.activityMap, let _ = shareModel.activityCategoryName.emptyToNil() {
                if self.model?.vipPrice ?? 0.0 > 0.0 {
                    return 150/WIDTH_6_SCALE + 55/WIDTH_6_SCALE + 34/WIDTH_6_SCALE
                }
                return 150/WIDTH_6_SCALE + 55/WIDTH_6_SCALE
            }else{
                if self.model?.vipPrice ?? 0.0 > 0.0 {
                    return 150/WIDTH_6_SCALE + 34/WIDTH_6_SCALE
                }
                return 150/WIDTH_6_SCALE
            }
        case .recommend, .newRecommend:
            return 176/WIDTH_6_SCALE
        case .specialService:
            var lineNum: Int = 0
            if self.characteristicArray.count%2 == 0 {
                lineNum = self.characteristicArray.count/2
            }else{
                lineNum = self.characteristicArray.count/2 + 1
            }
            return 49.5/WIDTH_6_SCALE + (15/WIDTH_6_SCALE + 20/WIDTH_6_SCALE) * CGFloat(lineNum)
        case .courseIntroduce:
            return 196/WIDTH_6_SCALE
        case .freePost:
            return 40/WIDTH_6_SCALE
        default:
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        if self.model!.freeShippingPrice != 0 && (self.model?.productType == 2 || self.model?.productType == 4){
            if section == 1 {
                return 1
            }
        }
        return 10
    }
}

extension CourseDetailViewController: UIWebViewDelegate {
    func webViewDidFinishLoad(_ webView: UIWebView) {
        HUD.hideLoading()
        let size = webView.sizeThatFits(.zero)
        webViewHeightConstraint.constant = size.height
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        HUD.showError(error: error.localizedDescription)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        
    }
}

extension CourseDetailViewController: GoodsInfoTableViewCellDelegate {
    func didClickReward() {
        self.shareClick()
    }
}

extension CourseDetailViewController: WKUIDelegate, WKNavigationDelegate{
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        HUD.hideLoading()
        weak var weakSelf = self
        webView.evaluateJavaScript("document.documentElement.style.webkitTouchCallout='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.documentElement.style.webkitUserSelect='none';", completionHandler: nil)
        webView.evaluateJavaScript("document.body.offsetHeight;") { (any, error) in
            if any is Int, let y = any as? Int {
                weakSelf?.coverWebView.frame = CGRect(x: 0, y: (weakSelf?.webView.top)!, width: SCREEN_WIDTH, height: CGFloat(y))
                self.webViewHeightConstraint.constant = CGFloat(y)
            }
        }
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
}
