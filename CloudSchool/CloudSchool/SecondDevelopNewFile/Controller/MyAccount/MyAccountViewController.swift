//
//  MyAccountViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/6/23.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyAccountViewController: UIViewController {
    var lowPriceView: UIImageView?
    var highPriceView: UIImageView?
    var lowPriceMoneyLab: UILabel?
    var highPriceMoneyLab: UILabel?
    var lowStudyScoreLab: UILabel?
    var highStudyScoreLab: UILabel?
    var lowPriceCoverBtn: UIButton?
    var highPriceCoverBtn: UIButton?
    var lineText = "4、使用苹果系统充值可参看充值流程说明；"
    var selectIndex: Int = 0//充值选项，0为88，1为148
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "我的账户"
        self.setUpUI()
    }
    
    func setUpUI(){
        self.view.addSubview(self.tableView)
    }
    
    lazy var tableView : UITableView = {
        weak var weakSelf = self
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableHeaderView = weakSelf?.headerView
        return tableView
    }()
    
    lazy var headerView : UIView = {
        weak var weakSelf = self
        var headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 1000))
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(weakSelf!.accountView)
        headerView.addSubview(weakSelf!.studyAccountTitleLab)
        headerView.addSubview(weakSelf!.studyAccountSubtitleLab)
        headerView.addSubview(weakSelf!.rechargeBtn)
        for num in 0...1 {
            let bgView = UIImageView.init(frame: CGRect(x: 40/375 * SCREEN_WIDTH + (125/375 * SCREEN_WIDTH + 45/375 * SCREEN_WIDTH) * CGFloat(num), y: 25/375 * SCREEN_WIDTH + (weakSelf?.studyAccountSubtitleLab.bottom)!, width: 125/375 * SCREEN_WIDTH, height: 102/375 * SCREEN_WIDTH))
            bgView.layer.cornerRadius = 4
            bgView.layer.masksToBounds = true
            bgView.layer.borderColor = UIColor.colorWithHex(hex: "ADADAD").cgColor
            bgView.layer.borderWidth = 0.8
            bgView.image = UIImage.init(named: "my_account_button_bg")
            bgView.isUserInteractionEnabled = true
            headerView.addSubview(bgView)
            //金额
            let moneyTitleLabel = UILabel.init(frame: CGRect(x: 0, y: 25/375 * SCREEN_WIDTH, width: bgView.width, height: 18/375 * SCREEN_WIDTH))
            moneyTitleLabel.text = "88元"
            moneyTitleLabel.textColor = .black
            moneyTitleLabel.font = DEF_FontSize_18
            moneyTitleLabel.textAlignment = .center
            bgView.addSubview(moneyTitleLabel)
            //学点
            let studyScoreTitleLabel = UILabel.init(frame: CGRect(x: 0, y: 10/375 * SCREEN_WIDTH + moneyTitleLabel.bottom, width: bgView.width, height: 24/375 * SCREEN_WIDTH))
            studyScoreTitleLabel.text = "88学点"
            studyScoreTitleLabel.textColor = UIColor.colorWithHex(hex: "4AA1F0")
            studyScoreTitleLabel.font = UIFont.systemFont(ofSize: 24)
            studyScoreTitleLabel.textAlignment = .center
            bgView.addSubview(studyScoreTitleLabel)
            //点击事件
            let coverBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: bgView.width, height: bgView.height))
            coverBtn.setBackgroundColor(.clear, forState: .normal)
            coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
            bgView.addSubview(coverBtn)

            bgView.tag = 1000 + num
            moneyTitleLabel.tag = 2000 + num
            studyScoreTitleLabel.tag = 3000 + num
            coverBtn.tag = 4000 + num
        }
        weakSelf!.lowPriceView = headerView.viewWithTag(1000)! as! UIImageView
        weakSelf!.highPriceView = headerView.viewWithTag(1001)! as! UIImageView
        weakSelf!.lowPriceMoneyLab = self.lowPriceView?.viewWithTag(2000) as? UILabel
        weakSelf!.highPriceMoneyLab = self.highPriceView?.viewWithTag(2001) as? UILabel
        weakSelf!.lowStudyScoreLab = self.lowPriceView?.viewWithTag(3000) as? UILabel
        weakSelf!.highStudyScoreLab = self.highPriceView?.viewWithTag(3001) as? UILabel
        weakSelf!.lowPriceCoverBtn = self.lowPriceView?.viewWithTag(4000) as? UIButton
        weakSelf!.highPriceCoverBtn = self.highPriceView?.viewWithTag(4001) as? UIButton
        weakSelf!.highPriceView?.image = UIImage.init(named: "my_account_button_unselect_bg")

        weakSelf!.lowPriceMoneyLab!.text = "88元"
        weakSelf!.lowStudyScoreLab!.text = "88学点"
        weakSelf!.highPriceMoneyLab!.text = "148元"
        weakSelf!.highStudyScoreLab!.text = "148学点"
        weakSelf!.lowPriceMoneyLab?.textColor = .white
        weakSelf!.lowStudyScoreLab?.textColor = .white

        weakSelf?.rechargeBtn.frame = CGRect(x: 0, y: 50/375 * SCREEN_WIDTH + (weakSelf?.lowPriceView?.bottom)!, width: 280/375 * SCREEN_WIDTH, height: 40/375 * SCREEN_WIDTH)
        weakSelf?.rechargeBtn.centerX = SCREEN_WIDTH/2
        headerView.addSubview(weakSelf!.chargeIntroduceTitleLab)
        headerView.addSubview(weakSelf!.topPartIntroductContentLab)
        headerView.addSubview(weakSelf!.middlePartIntroduceContentLab)
        weakSelf?.middlePartIntroduceContentLab.attributedText = self.getNSAttributedString(str: lineText)
        headerView.addSubview(weakSelf!.bottomPartIntroductContentLab)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: weakSelf!.bottomPartIntroductContentLab.bottom + 150)
        return headerView
    }()
    
    lazy var accountView : UIImageView = {
        weak var weakSelf = self
        let borderW = 15/WIDTH_6_SCALE
        var accountView = UIImageView.init(frame: CGRect(x: borderW, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2 * borderW, height: 140/WIDTH_6_SCALE))
        accountView.image = UIImage.init(named: "my_account_bg")
        accountView.addSubview(weakSelf!.accountTitleLab)
        accountView.addSubview(weakSelf!.accountSubtitleLab)
        accountView.addSubview(weakSelf!.accountMoneyLab)
        return accountView
    }()
    
    lazy var accountTitleLab : UILabel = {
        var accountTitleLab = UILabel.init(frame: CGRect(x: 25/WIDTH_6_SCALE, y: 25/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        accountTitleLab.font = DEF_FontSize_18
        accountTitleLab.backgroundColor = .clear
        accountTitleLab.textColor = .white
        accountTitleLab.textAlignment = .left
        accountTitleLab.text = "账户余额"
        return accountTitleLab
    }()
    
    lazy var accountSubtitleLab : UILabel = {
        weak var weakSelf = self
        var accountSubtitleLab = UILabel.init(frame: CGRect(x: (weakSelf?.accountTitleLab.left)!, y: (weakSelf?.accountTitleLab.bottom)! + 5/WIDTH_6_SCALE, width: 180/WIDTH_6_SCALE, height: 12/WIDTH_6_SCALE))
        accountSubtitleLab.font = DEF_FontSize_12
        accountSubtitleLab.backgroundColor = .clear
        accountSubtitleLab.textColor = .white
        accountSubtitleLab.textAlignment = .left
        accountSubtitleLab.text = "学习币仅用于线上付费内容"
        return accountSubtitleLab
    }()
    
    lazy var accountMoneyLab : UILabel = {
        weak var weakSelf = self
        var accountMoneyLab = UILabel.init(frame: CGRect(x: (weakSelf?.accountTitleLab.left)!, y: (weakSelf?.accountSubtitleLab.bottom)! + 10/WIDTH_6_SCALE, width: 200/WIDTH_6_SCALE, height: 36/WIDTH_6_SCALE))
        accountMoneyLab.font = UIFont.systemFont(ofSize: 36)
        accountMoneyLab.backgroundColor = .clear
        accountMoneyLab.textColor = .white
        accountMoneyLab.textAlignment = .left
        accountMoneyLab.text = ""
        let string = accountMoneyLab.text
        let ranStr = "学点"
        let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
        let str = NSString(string: string!)
        let theRange = str.range(of: ranStr)
        attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: theRange)
        accountMoneyLab.attributedText = attrstring
        return accountMoneyLab
    }()
    
    lazy var studyAccountTitleLab : UILabel = {
        weak var weakSelf = self
        var studyAccountTitleLab = UILabel.init(frame: CGRect(x: (weakSelf?.accountView.left)!, y: (weakSelf?.accountView.bottom)! + 25/WIDTH_6_SCALE, width: 200/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
        studyAccountTitleLab.font = DEF_FontSize_18
        studyAccountTitleLab.backgroundColor = .clear
        studyAccountTitleLab.textColor = .black
        studyAccountTitleLab.textAlignment = .left
        studyAccountTitleLab.text = "请选择充值金额"
        return studyAccountTitleLab
    }()
    
    lazy var studyAccountSubtitleLab : UILabel = {
        weak var weakSelf = self
        var studyAccountSubtitleLab = UILabel.init(frame: CGRect(x: (weakSelf?.studyAccountTitleLab.left)!, y: (weakSelf?.studyAccountTitleLab.bottom)! + 7.5/WIDTH_6_SCALE, width: (weakSelf?.studyAccountTitleLab.width)!, height: 15/WIDTH_6_SCALE))
        studyAccountSubtitleLab.font = DEF_FontSize_15
        studyAccountSubtitleLab.backgroundColor = .clear
        studyAccountSubtitleLab.textColor = UIColor.colorWithHex(hex: "828282")
        studyAccountSubtitleLab.textAlignment = .left
        studyAccountSubtitleLab.text = "1元等于1学点"
        return studyAccountSubtitleLab
    }()
    
    lazy var rechargeBtn : UIButton = {
        var rechargeBtn = UIButton.init(frame: CGRect(x: 0, y: 50/375 * SCREEN_WIDTH, width: 280/375 * SCREEN_WIDTH, height: 40/375 * SCREEN_WIDTH))
        rechargeBtn.centerX = SCREEN_WIDTH/2
        rechargeBtn.setTitle("立即充值", for: .normal)
        rechargeBtn.setTitleColor(UIColor.white, for: .normal)
        rechargeBtn.titleLabel?.font = DEF_FontSize_18
        rechargeBtn.setBackgroundColor(UIColor.colorWithHex(hex: "fcefed"), forState: .normal)
        rechargeBtn.layer.cornerRadius = 40/375 * SCREEN_WIDTH/2
        rechargeBtn.layer.masksToBounds = true
        rechargeBtn.addTarget(self, action: #selector(rechargeBtnClick), for: .touchUpInside)
        //设置渐变的主颜色
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rechargeBtn.bounds
        gradientLayer.colors = [UIColor.colorWithHex(hex: "65D6FD").cgColor, UIColor.colorWithHex(hex: "35ACFA").cgColor]
        //将gradientLayer作为子layer添加到主layer上
        rechargeBtn.layer.addSublayer(gradientLayer)
        rechargeBtn.addSubview(rechargeBtn.titleLabel!)
        return rechargeBtn
    }()
    
    lazy var chargeIntroduceTitleLab : UILabel = {
        weak var weakSelf = self
        var chargeIntroduceTitleLab = UILabel.init(frame: CGRect(x: (weakSelf?.accountView.left)!, y: (weakSelf?.rechargeBtn.bottom)! + 40/375 * SCREEN_WIDTH, width: 100/WIDTH_6_SCALE, height: 16/375 * SCREEN_WIDTH))
        chargeIntroduceTitleLab.font = DEF_FontSize_16
        chargeIntroduceTitleLab.backgroundColor = .clear
        chargeIntroduceTitleLab.textColor = .black
        chargeIntroduceTitleLab.textAlignment = .left
        chargeIntroduceTitleLab.text = "充值说明"
        return chargeIntroduceTitleLab
    }()
    
    lazy var topPartIntroductContentLab : UILabel = {
        weak var weakSelf = self
        var topPartIntroductContentLab = UILabel.init(frame: CGRect(x: 14/375 * SCREEN_WIDTH, y: (weakSelf?.chargeIntroduceTitleLab.bottom)! + 10/375 * SCREEN_WIDTH, width: SCREEN_WIDTH - 28/375 * SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        topPartIntroductContentLab.font = DEF_FontSize_13
        topPartIntroductContentLab.backgroundColor = .clear
        topPartIntroductContentLab.textColor = .black
        topPartIntroductContentLab.textAlignment = .left
        topPartIntroductContentLab.text = "1、苹果公司规定，虚拟商品必须使用苹果系统充值购买，充值金额不可自定义，且不能用于安卓、网页等其他平台；\n2、学习币可用于直接购买APP内虚拟内容（不含实物产品和线下课）\n3、学习币为虚拟币，充值成功后不会过期，但无法提现或转赠他人；"
        topPartIntroductContentLab.lineBreakMode = .byWordWrapping
        topPartIntroductContentLab.numberOfLines = 0
        topPartIntroductContentLab.sizeToFit()
        topPartIntroductContentLab.backgroundColor = .clear
        topPartIntroductContentLab.textColor = UIColor.colorWithHex(hex: "828282")
        return topPartIntroductContentLab
    }()
    
    lazy var middlePartIntroduceContentLab : UILabel = {
        weak var weakSelf = self
        var middlePartIntroduceContentLab = UILabel.init(frame: CGRect(x: (weakSelf?.topPartIntroductContentLab.left)!, y: (weakSelf?.topPartIntroductContentLab.bottom)!, width: (weakSelf?.topPartIntroductContentLab.width)!, height: 14/375 * SCREEN_WIDTH))
        middlePartIntroduceContentLab.font = DEF_FontSize_13
        middlePartIntroduceContentLab.backgroundColor = .clear
        middlePartIntroduceContentLab.textColor = .black
        middlePartIntroduceContentLab.textAlignment = .left
        middlePartIntroduceContentLab.text = "4、使用苹果系统充值可参看充值流程说明；"
        middlePartIntroduceContentLab.lineBreakMode = .byWordWrapping
        middlePartIntroduceContentLab.sizeToFit()
        middlePartIntroduceContentLab.numberOfLines = 0
        middlePartIntroduceContentLab.backgroundColor = .clear
        middlePartIntroduceContentLab.textColor = UIColor.colorWithHex(hex: "828282")
        return middlePartIntroduceContentLab
    }()
    
    lazy var bottomPartIntroductContentLab : UILabel = {
        weak var weakSelf = self
        var bottomPartIntroductContentLab = UILabel.init(frame: CGRect(x: (weakSelf?.middlePartIntroduceContentLab.left)!, y: (weakSelf?.middlePartIntroduceContentLab.bottom)!, width: (weakSelf?.topPartIntroductContentLab.width)!, height: 10/WIDTH_6_SCALE))
        bottomPartIntroductContentLab.font = DEF_FontSize_13
        bottomPartIntroductContentLab.backgroundColor = .clear
        bottomPartIntroductContentLab.textColor = .black
        bottomPartIntroductContentLab.textAlignment = .left
        bottomPartIntroductContentLab.text = "5、如存在无法充值、充值失败等问题，可关注“西尔环境”微信公众号，一站式解决您的问题。"
        bottomPartIntroductContentLab.lineBreakMode = .byWordWrapping
        bottomPartIntroductContentLab.numberOfLines = 0
        bottomPartIntroductContentLab.sizeToFit()
        bottomPartIntroductContentLab.backgroundColor = .clear
        bottomPartIntroductContentLab.textColor = UIColor.colorWithHex(hex: "828282")
        return bottomPartIntroductContentLab
    }()
    
    @objc func coverBtnClick(btn: UIButton){
        if btn.tag == 4000 {
            self.lowPriceMoneyLab?.textColor = .white
            self.lowStudyScoreLab?.textColor = .white
            self.highPriceMoneyLab?.textColor = UIColor.black
            self.highStudyScoreLab?.textColor = UIColor.colorWithHex(hex: "4AA1F0")
            self.lowPriceView?.image = UIImage.init(named: "my_account_button_bg")
            self.highPriceView?.image = UIImage.init(named: "my_account_button_unselect_bg")
            self.lowPriceView?.layer.borderColor = UIColor.clear.cgColor
            self.highPriceView?.layer.borderColor = UIColor.colorWithHex(hex: "ADADAD").cgColor
            self.selectIndex = 0
        }
        if btn.tag == 4001 {
            self.highPriceMoneyLab?.textColor = .white
            self.highStudyScoreLab?.textColor = .white
            self.lowPriceMoneyLab?.textColor = UIColor.black
            self.lowStudyScoreLab?.textColor = UIColor.colorWithHex(hex: "4AA1F0")
            self.lowPriceView?.image = UIImage.init(named: "my_account_button_unselect_bg")
            self.highPriceView?.image = UIImage.init(named: "my_account_button_bg")
            self.lowPriceView?.layer.borderColor = UIColor.colorWithHex(hex: "ADADAD").cgColor
            self.highPriceView?.layer.borderColor = UIColor.clear.cgColor
            self.selectIndex = 1
        }
    }
    
    //指定字符 指定颜色并加上下划线
    func getNSAttributedString(str:String) -> NSAttributedString {
        let myMutableString = NSMutableAttributedString(string: str)
        let range2 = NSMakeRange(13, 6)
        myMutableString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.colorWithHex(hex: "65D6FD"), range: range2)
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.patternDashDotDot.rawValue, range: NSMakeRange(0, 13))
        myMutableString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range2)
        return myMutableString
    }
    
    @objc func rechargeBtnClick(){
        var recharegeMoney: String = ""
        var submitMoney: String = ""
        if self.selectIndex == 0 {
            recharegeMoney = "cei.studyCardValue.88"
            submitMoney = "88"
        }else{
            recharegeMoney = "cei.studyCardValue.148"
            submitMoney = "148"
        }
        HUD.loading(text: "")
        IAPHandler.shared.purchase(RegisteredPurchase(rawValue: recharegeMoney)!, atomically: true)
        IAPHandler.shared.purchaseStatusBlock = { status in
        if status == .purchased{
            let defaultStand = UserDefaults.standard
            let defaultKey = "receipt"
            let receiptString = defaultStand.value(forKey: defaultKey) as! String
            let receiptDic = self.stringValueDic(receiptString)
            RequestHelper.shared.iosRechargeOrder(money: submitMoney).asObservable()
                .subscribe(onNext: {[weak self] (result) in
                    guard let `self` = self else { return }
                    result.errorDeal {
                        UserHelper.shared.getIOSOrderStatusString(poNumber: result.data!.poNumber, receipt_data: receiptString).asObservable() .subscribe(onNext: {[weak self] (list) in
                            HUD.hideLoading()
                            guard let `self` = self else { return }
                            let baseModel: BaseModel = list
                            if baseModel.code == 200{
                                HUD.showText(text: "充值成功")
                                self.getUserInfo()
                            }else{
                                HUD.showError(error: baseModel.message!)
                            }
                        }).disposed(by: self.disposeBag)
                    }
                }).disposed(by: self.disposeBag)
            }
        }
        
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
                    self.accountMoneyLab.text = "\(user.money)学点"
                    let string = self.accountMoneyLab.text
                    let ranStr = "学点"
                    let attrstring:NSMutableAttributedString = NSMutableAttributedString(string:string!)
                    let str = NSString(string: string!)
                    let theRange = str.range(of: ranStr)
                    attrstring.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 14), range: theRange)
                    self.accountMoneyLab.attributedText = attrstring
                })
                
                }, onError: { (error) in
            
            })
        .disposed(by: disposeBag)
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
