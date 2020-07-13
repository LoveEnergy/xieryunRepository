//
//  ExperienceViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/18.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class WorkExperienceViewController: UIViewController {
    var cellArr: [String] = ["公司名称", "工作时间", "所在行业", "公司规模", "公司性质", "所在部门", "职位", "薪酬", "描述"]
    var selectTime: Int = 0
    var schoolStartTextField: UITextField?//在校开始时间
    var singleSelectIndex: Int = 0
    var companyScaleTextField: UITextField?//公司规模
    var companyCharacterTextField: UITextField?//公司性质
    var salaryTextField: UITextField?//薪资
    lazy var schoolEndTextField: UITextField = {
        var schoolEndTextField = UITextField.init()
        schoolEndTextField.font = DEF_FontSize_15
        schoolEndTextField.backgroundColor = .clear
        schoolEndTextField.textColor = .black
        schoolEndTextField.textAlignment = .left
        schoolEndTextField.textColor = UIColor.colorWithHex(hex: "0378FD")
        schoolEndTextField.layer.cornerRadius = 4
        schoolEndTextField.layer.masksToBounds = true
        schoolEndTextField.layer.borderWidth = 0.8
        schoolEndTextField.layer.borderColor = UIColor.lightGray.cgColor
        return schoolEndTextField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        let saveBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(.black, for: .normal)
        saveBtn.titleLabel!.font = DEF_FontSize_14
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: saveBtn)
        self.navigationItem.rightBarButtonItem = rightItem
        
    }
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        for num in 0...self.cellArr.count - 1{
            var label = UILabel.init(frame: CGRect(x: 37/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE + CGFloat(num) * 75/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
            label.textColor = .black
            label.font = DEF_FontSize_15
            label.backgroundColor = .clear
            label.textAlignment = .left
            label.text = self.cellArr[num]
            label.tag = 2000 + num
            headerView.addSubview(label)
            var startLab = UILabel.init(frame: CGRect(x: 0, y: label.top, width: label.left, height: label.height))
            startLab.textColor = .red
            startLab.font = DEF_FontSize_15
            startLab.backgroundColor = .clear
            startLab.textAlignment = .center
            startLab.text = "*"
            headerView.addSubview(startLab)
            var textField = UITextField.init()
            if num == 1{
                textField.frame = CGRect(x: label.left, y: label.bottom + 5/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
                textField.layer.cornerRadius = 4
                textField.layer.masksToBounds = true
                textField.layer.borderWidth = 0.8
                textField.layer.borderColor = UIColor.lightGray.cgColor
            }else{
                textField.frame = CGRect(x: label.left, y: label.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
            }
            if num == 3 || num == 4 || num == 5 || num == 7{
                startLab.isHidden = true
            }
            textField.font = DEF_FontSize_15
            textField.backgroundColor = .clear
            textField.textColor = .black
            textField.textAlignment = .left
            textField.placeholder = self.cellArr[num]
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
            if num == 3 || num == 4 || num == 7 {
                var coverBtn = UIButton.init(frame: CGRect(x: textField.left, y: label.bottom, width: textField.width, height: lineView.top - label.top))
                coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
                coverBtn.tag = 3000 + num
                headerView.addSubview(coverBtn)
            }
        }
        self.schoolStartTextField = headerView.viewWithTag(4001) as! UITextField
        self.schoolEndTextField.frame = CGRect(x: self.schoolStartTextField!.right + 30/WIDTH_6_SCALE, y: self.schoolStartTextField!.top, width: self.schoolStartTextField!.width, height: self.schoolStartTextField!.height)
        let shortLineView = UIView.init(frame: CGRect(x: self.schoolStartTextField!.right + 5/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 1))
        shortLineView.backgroundColor = .lightGray
        shortLineView.centerY = self.schoolStartTextField!.centerY
        headerView.addSubview(self.schoolEndTextField)
        headerView.addSubview(shortLineView)
        self.startBtn.frame = self.schoolStartTextField!.bounds
        self.endBtn.frame = self.schoolEndTextField.bounds
        self.schoolStartTextField?.addSubview(self.startBtn)
        self.schoolEndTextField.addSubview(self.endBtn)
        self.schoolStartTextField?.placeholder = ""
        self.schoolEndTextField.placeholder = ""
        self.schoolStartTextField?.textAlignment = .center
        self.schoolEndTextField.textAlignment = .center
        
        self.companyScaleTextField = headerView.viewWithTag(4003) as! UITextField
        self.companyCharacterTextField = headerView.viewWithTag(4004) as! UITextField
        self.salaryTextField = headerView.viewWithTag(4007) as! UITextField
        
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 20/WIDTH_6_SCALE + CGFloat(self.cellArr.count + 1) * 75/WIDTH_6_SCALE + 50/WIDTH_6_SCALE)
        headerView.isUserInteractionEnabled = true
        return headerView
    }()
    lazy var startBtn : UIButton = {
        var startBtn = UIButton.init()
        startBtn.setBackgroundColor(.clear, forState: .normal)
        startBtn.addTarget(self, action: #selector(startBtnClick(btn:)), for: .touchUpInside)
        return startBtn
    }()
    lazy var endBtn : UIButton = {
        var endBtn = UIButton.init()
        endBtn.setBackgroundColor(.clear, forState: .normal)
        endBtn.addTarget(self, action: #selector(endBtnClick(btn:)), for: .touchUpInside)
        return endBtn
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
        singleSelectView.selectStringBlock = {(selectString) in
            if self.singleSelectIndex == 3003{
                self.companyScaleTextField!.text = selectString
            }
            if self.singleSelectIndex == 3004{
                self.companyCharacterTextField!.text = selectString
            }
            if self.singleSelectIndex == 3007{
                self.salaryTextField!.text = selectString
            }
            self.singleSelectView.dismissView()
        }
        return singleSelectView
    }()
    
    lazy var datePickerView : QFDatePickerView = {
        var datePickerView = QFDatePickerView.init(datePackerWithResponse: {(selectData) in
            if self.selectTime == 1{
                self.schoolStartTextField!.text = "\(selectData!)"
            }
            if self.selectTime == 2{
                self.schoolEndTextField.text = "\(selectData!)"
            }
        })
        return datePickerView!
    }()
    
    @objc func coverBtnClick(btn: UIButton){
        self.singleSelectIndex = btn.tag
        if btn.tag == 3003 {
            self.singleSelectView.showView(array: ["少于50人", "约50人至100人", "约150人至500人", "约500人以上", "约1000人以上"])
        }
        if btn.tag == 3004 {
            self.singleSelectView.showView(array: ["行政机关", "社会团队", "事业单位", "国有企业", "外商独资", "三资企业", "集体企业"])
        }
        if btn.tag == 3007{
            self.singleSelectView.showView(array: ["1k元以下", "1k - 2k", "2k - 4k", "4k - 6k", "6k - 8k", "8k - 10k", "10k - 15k", "15k - 25k", "25k - 35k", "35k - 50k", "50k上"])
        }
    }
    
    @objc func saveBtnClick(){
        print("\(self.compareTime(startTime: self.schoolStartTextField!.text!, endTime: self.schoolEndTextField.text!))")//小于0，顺序正确；大于零，顺序调转
    }
    
    @objc func startBtnClick(btn: UIButton){
        self.selectTime = 1
        self.datePickerView.show()
    }
    
    @objc func endBtnClick(btn: UIButton){
        self.selectTime = 2
        self.datePickerView.show()
    }

    func compareTime(startTime: String, endTime: String) -> Bool{
        var compareStart: String = startTime.replacingOccurrences(of: "-", with: "0")
        var compareEnd: String = endTime.replacingOccurrences(of: "-", with: "0")
        var result: Int = Int(compareStart)! - Int(compareEnd)!
        if result > 0 {
            return true
        }else{
            return false
        }
    }
}
