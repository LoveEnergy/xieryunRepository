//
//  SelectInvoiceTypeViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/6.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SelectInvoiceTypeViewController: UIViewController {
    public var sureBtnBlock : (()->())? //确定
    var invoiceType : Int = 1
    var contentType : Int = 1
    let disposeBag: DisposeBag = DisposeBag()
    let viewX = 20/WIDTH_6_SCALE
    let viewY = 40/WIDTH_6_SCALE
    let labelBorderW = 15/WIDTH_6_SCALE
    let labelBorderH = 10/WIDTH_6_SCALE
    let titleLabelBorder = 20/WIDTH_6_SCALE
    let btnH = 35/WIDTH_6_SCALE
    var personBtn : UIButton = UIButton.init()//个人
    var companyBtn : UIButton = UIButton.init()//公司
    var detailBtn : UIButton = UIButton.init()//商品明细
    var typeBtn : UIButton = UIButton.init()//商品类别
    var companyTextField : UITextField = UITextField.init()//单位名称
    var codeTextField : UITextField = UITextField.init()//纳税人识别码
    var companyTextFieldBGView : UIView = UIView.init()//单位名称背景
    var codeTextFieldBGView : UIView = UIView.init()//纳税人识别码背景
//    var emailTextField : UITextField = UITextField.init()//电子邮件内容
//    var emialTextFieldBGView : UIView = UIView.init()//电子邮件背景
    let instructionString = "西尔已全面推广电子发票,订单完成后24小时内开具,点击”我的订单“查看和下载"
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT + NAVI_HEIGHT) - 60/WIDTH_6_SCALE))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        return tableView
    }()
    //确定按钮
    lazy var sureBtn : UIButton = {[weak self] in
        var sureBtn = UIButton.init(frame: CGRect(x: self!.viewX, y: self!.tableView.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2*self!.viewX, height: 40/WIDTH_6_SCALE))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_16
        sureBtn.setTitleColor(.white, for: .normal)
        sureBtn.adjustsImageWhenHighlighted = false
        sureBtn.setBackgroundColor(UIColor.colorWithHex(hex: "ff5d4c"), forState: .normal)
        sureBtn.addTarget(self, action: #selector(sureBtnClick), for: .touchUpInside)
        sureBtn.layer.cornerRadius = 12
        sureBtn.layer.masksToBounds = true
        return sureBtn
    }()
    //黄色背景
    lazy var yellowBGView : UIView = {
        var yellowBGView = UIView.init()
        yellowBGView.backgroundColor = UIColor.colorWithHex(hex: "fff2b8")
        yellowBGView.layer.cornerRadius = 8
        yellowBGView.layer.masksToBounds = true
        return yellowBGView
    }()
    //发票说明
    lazy var instructionLab : UILabel = {
        var instructionLab = UILabel.init()
        instructionLab.font = DEF_FontSize_16
        instructionLab.textAlignment = .left
        instructionLab.text = instructionString
        instructionLab.backgroundColor = .clear
        instructionLab.textColor = UIColor.colorWithHex(hex: "ff5d4c")
        instructionLab.lineBreakMode = .byWordWrapping
        instructionLab.numberOfLines = 0
        return instructionLab
    }()
    //发票类型
    lazy var invoiceTypeLabel : UILabel = {
        var invoiceTypeLabel = UILabel.init(frame:CGRect(x: viewX, y: titleLabelBorder + self.yellowBGView.bottom, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        invoiceTypeLabel.font = DEF_FontSize_16
        invoiceTypeLabel.backgroundColor = .clear
        invoiceTypeLabel.textColor = .black
        invoiceTypeLabel.textAlignment = .left
        invoiceTypeLabel.text = "发票类型"
        return invoiceTypeLabel
    }()
    //发票类型按钮
    lazy var electronicInvoiceBtn : UIButton = {[weak self] in
        var electronicInvoiceBtn = UIButton.init()
        electronicInvoiceBtn.setTitle("电子发票", for: .normal)
        electronicInvoiceBtn.setTitleColor(UIColor.colorWithHex(hex: "ff5d4c"), for: .normal)
        electronicInvoiceBtn.titleLabel?.font = DEF_FontSize_16
        electronicInvoiceBtn.setBackgroundColor(UIColor.colorWithHex(hex: "fcefed"), forState: .normal)
        electronicInvoiceBtn.layer.cornerRadius = 12
        electronicInvoiceBtn.layer.masksToBounds = true
        electronicInvoiceBtn.layer.borderWidth = 1.0
        electronicInvoiceBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
        electronicInvoiceBtn.frame = CGRect(x: self!.yellowBGView.left, y: self!.invoiceTypeLabel.bottom + titleLabelBorder, width: 120/WIDTH_6_SCALE, height: self!.btnH)
        electronicInvoiceBtn.adjustsImageWhenHighlighted = false
        return electronicInvoiceBtn
    }()
    //发票抬头
    lazy var invoiceTitleLabel : UILabel = {
        var invoiceTitleLabel = UILabel.init(frame:CGRect(x: viewX, y: titleLabelBorder + self.electronicInvoiceBtn.bottom, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        invoiceTitleLabel.font = DEF_FontSize_16
        invoiceTitleLabel.backgroundColor = .clear
        invoiceTitleLabel.textColor = .black
        invoiceTitleLabel.textAlignment = .left
        invoiceTitleLabel.text = "发票抬头"
        return invoiceTitleLabel
    }()
    //发票内容
    lazy var invoiceContentLabel : UILabel = {
        var invoiceContentLabel = UILabel.init(frame:CGRect(x: viewX, y: titleLabelBorder + self.codeTextFieldBGView.bottom, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        invoiceContentLabel.font = DEF_FontSize_16
        invoiceContentLabel.backgroundColor = .clear
        invoiceContentLabel.textColor = .black
        invoiceContentLabel.textAlignment = .left
        invoiceContentLabel.text = "发票内容"
        return invoiceContentLabel
    }()
    //电子邮箱
    lazy var emailTitleLab : UILabel = {[weak self] in
        var emailTitleLab = UILabel.init()
        emailTitleLab.frame = CGRect(x: (self?.invoiceTypeLabel.left)!, y: (self?.typeBtn.bottom)! + self!.titleLabelBorder, width: 100/WIDTH_6_SCALE, height: (self?.invoiceTypeLabel.height)!)
        emailTitleLab.font = DEF_FontSize_16
        emailTitleLab.backgroundColor = .clear
        emailTitleLab.textColor = .black
        emailTitleLab.textAlignment = .left
        emailTitleLab.text = "电子邮箱"
        emailTitleLab.lineBreakMode = .byWordWrapping
        emailTitleLab.numberOfLines = 0
        return emailTitleLab
    }()
    //电子邮箱内容
    lazy var emailTextField : UITextField = {[weak self] in
        let emailTextField = UITextField.init()
        emailTextField.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self!.emialTextFieldBGView.width - 20/WIDTH_6_SCALE, height: self!.emialTextFieldBGView.height)
        emailTextField.font = DEF_FontSize_16
        emailTextField.textColor = .black
        emailTextField.textAlignment = .left
        emailTextField.backgroundColor = .clear
        emailTextField.placeholder = "电子邮箱内容"
        return emailTextField
    }()
    //电子邮箱内容背景
    lazy var emialTextFieldBGView : UIView = {[weak self] in
        var emialTextFieldBGView = UIView.init()
        emialTextFieldBGView.frame = CGRect(x: self!.invoiceTitleLabel.left, y: self!.emailTitleLab.bottom + self!.titleLabelBorder, width: SCREEN_WIDTH - 2*self!.invoiceTitleLabel.left, height: 40/WIDTH_6_SCALE)
        emialTextFieldBGView.layer.cornerRadius = 8
        emialTextFieldBGView.layer.masksToBounds = true
        emialTextFieldBGView.backgroundColor = UIColor.colorWithHex(hex: "f5f5f5")
        return emialTextFieldBGView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }
    //页面配置
    func configUI() {
        let labelW = SCREEN_WIDTH - 2*viewX - 2*labelBorderW
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.sureBtn)
        self.tableView.addSubview(self.yellowBGView)
        self.yellowBGView.addSubview(self.instructionLab)
        let labelH = self.getLabelHeight(label: self.instructionLab, string: self.instructionString, font: 14.0, textAlignment: .left, width: labelW)
        self.yellowBGView.frame = CGRect(x: viewX, y: viewY, width: SCREEN_WIDTH - 2*viewX, height: labelH + 2*labelBorderH)
        self.instructionLab.frame = CGRect(x: labelBorderW, y: labelBorderH, width: labelW, height: labelH)
        self.tableView.addSubview(self.invoiceTypeLabel)
        self.tableView.addSubview(self.electronicInvoiceBtn)
        self.tableView.addSubview(self.invoiceTitleLabel)
        //发票抬头选择按钮
        let btnW = 60/WIDTH_6_SCALE
        self.createButton(tag: 1000)
        self.personBtn = self.tableView.viewWithTag(1000) as! UIButton
        self.personBtn.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.invoiceTitleLabel.bottom + titleLabelBorder, width: btnW, height: btnH)
        self.personBtn.setTitle("个人", for: .normal)
        self.personBtn.isSelected = true
        self.companyBtn = self.tableView.viewWithTag(1001) as! UIButton
        self.companyBtn.frame = CGRect(x: self.personBtn.right + 15/WIDTH_6_SCALE, y: self.personBtn.top, width: self.personBtn.width, height: self.personBtn.height)
        self.companyBtn.setTitle("公司", for: .normal)
        self.companyBtn.isSelected = false
        self.companyBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
        self.companyBtn.addTarget(self, action: #selector(invoiceTitleClick(btn:)), for: .touchUpInside)
        self.personBtn.addTarget(self, action: #selector(invoiceTitleClick(btn:)), for: .touchUpInside)
        //公司名头时，单位名称和纳税人识别码
        self.setUpTextField()
        self.changeH(btn: self.personBtn)
        //发票内容
        self.tableView.addSubview(self.invoiceContentLabel)
        //发票内容选择按钮
        self.createButton(tag: 2000)
        self.detailBtn = self.tableView.viewWithTag(2000) as! UIButton
        self.detailBtn.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.invoiceContentLabel.bottom + titleLabelBorder, width: btnW + 30/WIDTH_6_SCALE, height: btnH)
        self.detailBtn.setTitle("商品明细", for: .normal)
        self.detailBtn.isSelected = true
        self.typeBtn = self.tableView.viewWithTag(2001) as! UIButton
        self.typeBtn.frame = CGRect(x: self.detailBtn.right + 15/WIDTH_6_SCALE, y: self.detailBtn.top, width: self.detailBtn.width, height: self.detailBtn.height)
        self.typeBtn.setTitle("商品类别", for: .normal)
        self.typeBtn.isSelected = false
        self.typeBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
        self.detailBtn.addTarget(self, action: #selector(invoiceContentClick(btn:)), for: .touchUpInside)
        self.typeBtn.addTarget(self, action: #selector(invoiceContentClick(btn:)), for: .touchUpInside)
        //电子邮件
        self.tableView.addSubview(self.emailTitleLab)
        self.tableView.addSubview(self.emialTextFieldBGView)
        self.emialTextFieldBGView.addSubview(self.emailTextField)
    }
}


extension SelectInvoiceTypeViewController {
    //label高度
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
    //发票抬头点击事件
    @objc func invoiceTitleClick(btn:UIButton){
        if btn.tag == 1000 {
            self.personBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
            self.companyBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
            self.personBtn.isSelected = true
            self.companyBtn.isSelected = false
            self.invoiceType = 1
        }else{
            self.personBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
            self.companyBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
            self.personBtn.isSelected = false
            self.companyBtn.isSelected = true
            self.invoiceType = 2
        }
        self.changeH(btn: btn)
    }
    //发票抬头点击事件
    @objc func invoiceContentClick(btn:UIButton){
        if btn.tag == 2000 {
            self.detailBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
            self.typeBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
            self.detailBtn.isSelected = true
            self.typeBtn.isSelected = false
            self.contentType = 1
        }else{
            self.detailBtn.layer.borderColor = UIColor.colorWithHex(hex: "b2b2b2").cgColor
            self.typeBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
            self.detailBtn.isSelected = false
            self.typeBtn.isSelected = true
            self.contentType = 2
        }
    }
    //确定按钮点击
    @objc func sureBtnClick(){
        var companyNameString = self.companyTextField.text!
        var taxpaperNoString = self.codeTextField.text!
        var emailString = self.emailTextField.text!
        if emailString.isEmpty == true{
            HUD.showText(text: "电子邮箱不能为空")
            return
        }
        let emailTempString = emailString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        if emailTempString.count <= 0{
            HUD.showText(text: "电子邮箱不能为空")
            return
        }
        if self.invoiceType == 2 {
            if companyNameString.isEmpty == true{
                HUD.showText(text: "公司名称不能为空")
                return
            }
            let companyNameTempString = companyNameString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            if companyNameTempString.count <= 0{
                HUD.showText(text: "公司名称不能为空")
                return
            }
            if taxpaperNoString.isEmpty == true{
                HUD.showText(text: "纳税人识别号不能为空")
                return
            }
            let taxpaperNoTempString = taxpaperNoString.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
            if taxpaperNoTempString.count <= 0{
                HUD.showText(text: "纳税人识别号不能为空")
                return
            }
            UserHelper.shared.saveInvoice(invoiceType: 1, invoiceRise: self.invoiceType, companyName: self.companyTextField.text!, taxpayerNo: self.codeTextField.text!, contentType: "\(self.contentType)", email: self.emailTextField.text!).asObservable()
            .subscribe(onNext: {[weak self] (object) in
                guard let `self` = self else { return }
                object.errorDeal(successBlock: {
                    self.navigationController?.popViewController(animated: true)
                })
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        }else{
            UserHelper.shared.saveInvoice(invoiceType: 1, invoiceRise: self.invoiceType, companyName: self.companyTextField.text!, taxpayerNo: self.codeTextField.text!, contentType: "\(self.contentType)", email: self.emailTextField.text!).asObservable()
            .subscribe(onNext: {[weak self] (object) in
                guard let `self` = self else { return }
                object.errorDeal(successBlock: {
                    self.navigationController?.popViewController(animated: true)
                })
                }, onError: { (error) in
                    HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
        }
        
    }
    //改变布局
    func changeH( btn : UIButton ){
        if btn.tag == 1000{
            UIView.animate(withDuration: 0.3) {
                self.companyTextFieldBGView.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.personBtn.bottom, width: SCREEN_WIDTH - 2*self.invoiceTitleLabel.left, height: 0)
                self.codeTextFieldBGView.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.companyTextFieldBGView.bottom, width: self.companyTextFieldBGView.width, height: 0)
                self.companyTextField.frame = CGRect(x: 0, y: 0, width: self.companyTextFieldBGView.width - 20/WIDTH_6_SCALE, height: 0)
                self.codeTextField.frame = CGRect(x: 0, y: 0, width: self.companyTextField.width, height: 0)
            }
        }else{
            UIView.animate(withDuration: 0.3) {
                self.companyTextFieldBGView.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.personBtn.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2*self.invoiceTitleLabel.left, height: 40/WIDTH_6_SCALE)
                self.codeTextFieldBGView.frame = CGRect(x: self.invoiceTitleLabel.left, y: self.companyTextFieldBGView.bottom + 15/WIDTH_6_SCALE, width: self.companyTextFieldBGView.width, height: self.companyTextFieldBGView.height)
                self.companyTextField.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self.companyTextFieldBGView.width - 20/WIDTH_6_SCALE, height: self.companyTextFieldBGView.height)
                self.codeTextField.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self.companyTextField.width, height: self.companyTextFieldBGView.height)
            }
        }
        UIView.animate(withDuration: 0.3) {[weak self] in
            self!.invoiceContentLabel.frame = CGRect(x: self!.viewX, y: self!.titleLabelBorder + self!.codeTextFieldBGView.bottom, width: 100/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
            self!.detailBtn.frame = CGRect(x: self!.invoiceTitleLabel.left, y: self!.invoiceContentLabel.bottom + self!.titleLabelBorder, width: 60/WIDTH_6_SCALE + 30/WIDTH_6_SCALE, height: self!.btnH)
            self!.typeBtn.frame = CGRect(x: self!.detailBtn.right + 15/WIDTH_6_SCALE, y: self!.detailBtn.top, width: self!.detailBtn.width, height: self!.detailBtn.height)
            self!.emailTitleLab.frame = CGRect(x: self!.invoiceTypeLabel.left, y: self!.typeBtn.bottom + self!.titleLabelBorder, width: 100/WIDTH_6_SCALE, height: self!.invoiceTypeLabel.height)
            self!.emailTextField.frame = CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: self!.emialTextFieldBGView.width - 20/WIDTH_6_SCALE, height: self!.emialTextFieldBGView.height)
            self!.emialTextFieldBGView.frame = CGRect(x: self!.invoiceTitleLabel.left, y: self!.emailTitleLab.bottom + self!.titleLabelBorder, width: SCREEN_WIDTH - 2*self!.invoiceTitleLabel.left, height: 40/WIDTH_6_SCALE)
        }
    }
    
    func createButton(tag:Int){
        for num in 0...1 {
            let titleBtn = UIButton.init()
            titleBtn.setTitleColor(UIColor.colorWithHex(hex: "ff5d4c"), for: .selected)
            titleBtn.setTitleColor(UIColor.black, for: .normal)
            titleBtn.titleLabel?.font = DEF_FontSize_16
            titleBtn.setBackgroundColor(UIColor.colorWithHex(hex: "fcefed"), forState: .selected)
            titleBtn.setBackgroundColor(UIColor.white, forState: .normal)
            titleBtn.layer.cornerRadius = 12
            titleBtn.layer.masksToBounds = true
            titleBtn.layer.borderWidth = 1.0
            titleBtn.layer.borderColor = UIColor.colorWithHex(hex: "ff5d4c").cgColor
            titleBtn.tag = tag + num
            titleBtn.adjustsImageWhenHighlighted = false
            self.tableView.addSubview(titleBtn)
        }
    }
    
    func setUpTextField(){
        for num in 0...1 {
            let bgView = UIView.init(frame : CGRect(x: self.invoiceTitleLabel.left, y: self.personBtn.bottom + (10/WIDTH_6_SCALE + 40/WIDTH_6_SCALE)*CGFloat(num) + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 2*self.invoiceTitleLabel.left, height: 40/WIDTH_6_SCALE))
            bgView.layer.cornerRadius = 8
            bgView.layer.masksToBounds = true
            bgView.tag = 3000 + num
            bgView.backgroundColor = UIColor.colorWithHex(hex: "f5f5f5")
            self.tableView.addSubview(bgView)
            let textField = UITextField.init(frame : CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: bgView.width - 20/WIDTH_6_SCALE, height: bgView.height))
            textField.font = DEF_FontSize_16
            textField.textColor = .black
            textField.textAlignment = .left
            textField.backgroundColor = .clear
            textField.tag = 4000 + num
            bgView.addSubview(textField)
        }
        self.companyTextFieldBGView = self.tableView.viewWithTag(3000) as! UIView
        self.codeTextFieldBGView = self.tableView.viewWithTag(3001) as! UIView
        self.companyTextField = self.tableView.viewWithTag(4000) as! UITextField
        self.codeTextField = self.tableView.viewWithTag(4001) as! UITextField
        self.companyTextField.placeholder = "请填写单位名称"
        self.codeTextField.placeholder = "请填写纳税人识别码"
    }
}
