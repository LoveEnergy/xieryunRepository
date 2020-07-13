//
//  PersonalInfoViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/11.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class PersonalInfoViewController: UIViewController {
    var nameTextField: UITextField?
    var IDCardTextField: UITextField?
    var sexTextField: UITextField?
    var workYearTextField: UITextField?
    var birthDayTextField: UITextField?
    var liveLocationTextField: UITextField?
    var IDLocationTextField: UITextField?
    var nativePlaceTextField: UITextField?
    var phoneTextField: UITextField?
    var emailTextField: UITextField?
    var marriageTextField: UITextField?
    var nationalityTextField: UITextField?
    var politicsTextField: UITextField?
    var selectViewTag = 0
    lazy var addTitleAddressView : ZHFAddTitleAddressView = ZHFAddTitleAddressView()//地址选择器
    var model: AddressModel = AddressModel(JSON: ["provinceID":110000, "cityID":110000, "countyID": 110101])!
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        headerView.backgroundColor = UIColor.white
        headerView.addSubview(self.iconBtn)
        for num in 0...12 {
            var label = UILabel.init(frame: CGRect(x: 37/WIDTH_6_SCALE, y: self.iconBtn.bottom + 20/WIDTH_6_SCALE + CGFloat(num) * 75/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
            label.textColor = .black
            label.font = DEF_FontSize_15
            label.backgroundColor = .clear
            label.textAlignment = .left
            label.tag = 2000 + num
            headerView.addSubview(label)
            var startLab = UILabel.init(frame: CGRect(x: 0, y: label.top, width: label.left, height: label.height))
            startLab.textColor = .red
            startLab.font = DEF_FontSize_15
            startLab.backgroundColor = .clear
            startLab.textAlignment = .center
            startLab.text = "*"
            headerView.addSubview(startLab)
            var textField = UITextField.init(frame: CGRect(x: label.left, y: label.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
            textField.font = DEF_FontSize_15
            textField.backgroundColor = .clear
            textField.textColor = .black
            textField.textAlignment = .left
            textField.placeholder = "测试"
            textField.tag = 4000 + num
            textField.textColor = UIColor.colorWithHex(hex: "0378FD")
            headerView.addSubview(textField)
            var lineView = UIView.init(frame: CGRect(x: label.left, y: label.top + 58/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 1))
            lineView.backgroundColor = UIColor.colorWithHex(hex: "D7D7D7")
            headerView.addSubview(lineView)
            var arrow = UIImageView.init(frame: CGRect(x: SCREEN_WIDTH - 37/WIDTH_6_SCALE - 8/WIDTH_6_SCALE, y: 0, width: 8/WIDTH_6_SCALE, height: 11.5/WIDTH_6_SCALE))
            arrow.image = UIImage.init(named: "right_arrow")
            arrow.centerY = textField.centerY
            headerView.addSubview(arrow)
            var coverBtn = UIButton.init(frame: CGRect(x: textField.left, y: label.bottom, width: textField.width, height: lineView.top - label.top))
            coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
            coverBtn.tag = 3000 + num
            headerView.addSubview(coverBtn)
            if num == 0 || num == 1 || num == 3 || num == 6 || num == 8 || num == 9 {
                arrow.isHidden = true
                coverBtn.isHidden = true
            }
        }
        var nameTitleLab = headerView.viewWithTag(2000) as! UILabel
        nameTitleLab.text = "姓名"
        var IDCardTitleLab = headerView.viewWithTag(2001) as! UILabel
        IDCardTitleLab.text = "身份证号"
        var sexTitleLab = headerView.viewWithTag(2002) as! UILabel
        sexTitleLab.text = "性别"
        var workYearTitleLab = headerView.viewWithTag(2003) as! UILabel
        workYearTitleLab.text = "工作年限"
        var birthDayTitleLab = headerView.viewWithTag(2004) as! UILabel
        birthDayTitleLab.text = "出生日期"
        var liveLocationTitleLab = headerView.viewWithTag(2005) as! UILabel
        liveLocationTitleLab.text = "现居住地址"
        var IDLocationTitleLab = headerView.viewWithTag(2006) as! UILabel
        IDLocationTitleLab.text = "户口所在地"
        var nativePlaceTitleLab = headerView.viewWithTag(2007) as! UILabel
        nativePlaceTitleLab.text = "籍贯"
        var phoneTitleLab = headerView.viewWithTag(2008) as! UILabel
        phoneTitleLab.text = "手机号"
        var emailTitleLab = headerView.viewWithTag(2009) as! UILabel
        emailTitleLab.text = "邮箱"
        var marriageTitleLab = headerView.viewWithTag(2010) as! UILabel
        marriageTitleLab.text = "婚姻状态"
        var nationalityTitleLab = headerView.viewWithTag(2011) as! UILabel
        nationalityTitleLab.text = "民族"
        var politicsTitleLab = headerView.viewWithTag(2012) as! UILabel
        politicsTitleLab.text = "政治面貌"
        self.nameTextField = headerView.viewWithTag(4000) as! UITextField
        self.nameTextField?.placeholder = "请填写姓名"
        self.IDCardTextField = headerView.viewWithTag(4001) as! UITextField
        self.IDCardTextField?.placeholder = "请填写身份证号"
        self.sexTextField = headerView.viewWithTag(4002) as! UITextField
        self.sexTextField?.text = "男"
        self.workYearTextField = headerView.viewWithTag(4003) as! UITextField
        self.workYearTextField?.placeholder = "请填写工作年限"
        self.birthDayTextField = headerView.viewWithTag(4004) as! UITextField
        self.birthDayTextField?.placeholder = "请选择出生日期"
        self.liveLocationTextField = headerView.viewWithTag(4005) as! UITextField
        self.liveLocationTextField?.placeholder = "请选择现居住地址"
        self.IDLocationTextField = headerView.viewWithTag(4006) as! UITextField
        self.IDLocationTextField?.placeholder = "请填写户口所在地"
        self.nativePlaceTextField = headerView.viewWithTag(4007) as! UITextField
        self.nativePlaceTextField?.placeholder = "请选择籍贯"
        self.phoneTextField = headerView.viewWithTag(4008) as! UITextField
        self.phoneTextField?.placeholder = "请填写手机号"
        self.emailTextField = headerView.viewWithTag(4009) as! UITextField
        self.emailTextField?.placeholder = "请填邮箱"
        self.marriageTextField = headerView.viewWithTag(4010) as! UITextField
        self.marriageTextField?.text = "未婚"
        self.nationalityTextField = headerView.viewWithTag(4011) as! UITextField
        self.nationalityTextField?.text = "汉族"
        self.politicsTextField = headerView.viewWithTag(4012) as! UITextField
        self.politicsTextField?.text = "群众"
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: politicsTitleLab.bottom + 80/WIDTH_6_SCALE)
        return headerView
    }()
    lazy var singleSelectView : SingleSelectView = {
        var singleSelectView = SingleSelectView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        singleSelectView.singleSelectViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.singleSelectView.alpha = 0
            }) { (Bool) in
                self.singleSelectView.removeFromSuperview()
            }
        }
        singleSelectView.selectStringBlock = {(selectString: String) in
            print(selectString)
            self.singleSelectView.dismissView()
            if self.selectViewTag == 3002{
                self.sexTextField?.text = selectString
            }
            if self.selectViewTag == 3010{
                self.marriageTextField?.text = selectString
            }
            if self.selectViewTag == 3011{
                self.nationalityTextField?.text = selectString
            }
            if self.selectViewTag == 3012{
                self.politicsTextField?.text = selectString
            }
        }
        return singleSelectView
    }()
    
    lazy var birthDayView : BirthDayView = {
        var birthDayView = BirthDayView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        birthDayView.getDateBlock = {(dateString) in
            print(dateString)
        }
        return birthDayView
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
        return tableView
    }()
    lazy var iconBtn : UIButton = {
        var iconBtn = UIButton.init(frame: CGRect(x: 0, y: 20/WIDTH_6_SCALE, width: 120/WIDTH_6_SCALE, height: 120/WIDTH_6_SCALE))
        iconBtn.centerX = SCREEN_WIDTH/2
        iconBtn.setBackgroundColor(.orange, forState: .normal)
        iconBtn.layer.cornerRadius = 4
        iconBtn.layer.masksToBounds = true
        return iconBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        
        self.addTitleAddressView.title = "选择地址"
        self.addTitleAddressView.delegate = self
        self.addTitleAddressView.personalPage = true
        self.addTitleAddressView.defaultHeight = kScreenHeight * 0.7
        self.addTitleAddressView.personalPage = true
        self.view.addSubview(self.addTitleAddressView.initAddressView())
        
        let saveBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(.black, for: .normal)
        saveBtn.titleLabel!.font = DEF_FontSize_14
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: saveBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.birthDayView.dismiss()
        self.singleSelectView.dismissView()
    }
    @objc func coverBtnClick(btn: UIButton){
        self.selectViewTag = btn.tag
        if btn.tag == 3002 {
            self.singleSelectView.showView(array: ["男", "女"])
        }
        if btn.tag == 3004 {
            self.birthDayView.show()
        }
        if btn.tag == 3005 {
            addTitleAddressView.addAnimate()
        }
        if btn.tag == 3007 {
            addTitleAddressView.addAnimate()
        }
        if btn.tag == 3010 {
            self.singleSelectView.showView(array: ["未婚", "已婚"])
        }
        if btn.tag == 3011 {
            self.singleSelectView.showView(array: ["汉族", "壮族", "满族", "回族", "苗族", "维吾尔族", "土家族", "彝族", "蒙古族", "藏族", "布依族", "侗族", "瑶族", "朝鲜族", "白族", "哈尼族", "哈萨克族", "黎族", "傣族", "畲族", "傈僳族", "仡佬族", "东乡族", "高山族", "拉祜族", "水族", "佤族", "纳西族", "羌族", "土族", "仫佬族", "锡伯族", "柯尔克孜族", "达斡尔族", "景颇族", "毛南族", "撒拉族", "布朗族", "塔吉克族", "阿昌族", "普米族", "鄂温克族", "怒族", "京族", "基诺族", "德昂族", "保安族", "俄罗斯族", "裕固族", "乌孜别克族", "门巴族", "鄂伦春族", "独龙族", "塔塔尔族", "赫哲族", "珞巴族"
            ])
        }
        if btn.tag == 3012 {
            self.singleSelectView.showView(array: ["群众", "团员", "党员", "其他"])
        }
    }
    
    @objc func saveBtnClick(){
        let nameTempString = self.nameTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let IDCardTempString = self.IDCardTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let sexTempString = self.sexTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let workYearTempString = self.workYearTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let birthdayTempString = self.birthDayTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let liveLocationTempString = self.liveLocationTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let IDLocationTempString = self.IDLocationTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let nativePlaceTempString = self.nativePlaceTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let phoneTempString = self.phoneTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let emailTempString = self.emailTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let marriageTempString = self.marriageTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let nationalityTempString = self.nationalityTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let politicsTempString = self.politicsTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        if nameTempString!.isEmpty || IDCardTempString!.isEmpty || sexTempString!.isEmpty || workYearTempString!.isEmpty || birthdayTempString!.isEmpty || liveLocationTempString!.isEmpty || IDLocationTempString!.isEmpty || nativePlaceTempString!.isEmpty || phoneTempString!.isEmpty || emailTempString!.isEmpty || marriageTempString!.isEmpty || nationalityTempString!.isEmpty || politicsTempString!.isEmpty{
            HUD.showText(text: "请完整填写个人信息")
        }else{
            //接口
        }
    }
}

extension PersonalInfoViewController: ZHFAddTitleAddressViewDelegate {
    func cancelBtnClick(titleAddress: String, titleID: String) {
        if self.selectViewTag == 3005 {
            self.liveLocationTextField!.text = titleAddress
        }else{
            self.nativePlaceTextField!.text = titleAddress
        }
        let arr = addTitleAddressView.titleIDMarr.map { (value) -> Int in
            return value as! Int
        }
        if arr.count > 0 {
            model.provinceID = arr[0]
        }
        if arr.count > 1 {
            model.cityID = arr[1]
        }
//        return
        if arr.count > 2 {
            model.countyID = arr[2]
        }
        if arr.count > 3 {
            model.streetID = arr[3]
        }
    }
}
