//
//  EducationViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/17.
//  Copyright © 2020 CEI. All rights reserved.
//  教育经历

import UIKit
import RxSwift
import RxCocoa
class EducationViewController: UIViewController {
    var cellArr: [String] = ["学校名称", "在校时间", "学历", "专业"]
    var schoolNameTextField: UITextField?//学校名称
    var schoolStartTextField: UITextField?//在校开始时间
    var educationBgTextField: UITextField?//学历
    var majorTextField: UITextField?//专业
    var selectTime: Int = 0
    lazy var describeTitleLab : UILabel = {
        var describeTitleLab = UILabel.init()
        describeTitleLab.font = DEF_FontSize_14
        describeTitleLab.backgroundColor = .clear
        describeTitleLab.textColor = .black
        describeTitleLab.textAlignment = .left
        describeTitleLab.text = "描述"
        return describeTitleLab
    }()
    var describeTextView: UITextView = {
        var describeTextView = UITextView.init()
        describeTextView.font = DEF_FontSize_15
        describeTextView.backgroundColor = .clear
        describeTextView.textColor = .black
        describeTextView.textAlignment = .left
        describeTextView.textColor = UIColor.colorWithHex(hex: "0378FD")
        describeTextView.layer.cornerRadius = 4
        describeTextView.layer.masksToBounds = true
        describeTextView.layer.borderWidth = 0.8
        describeTextView.layer.borderColor = UIColor.lightGray.cgColor
        return describeTextView
    }()
    var schoolEndTextField: UITextField = {
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

    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.separatorStyle = .none
        return tableView
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
            self.educationBgTextField?.text = selectString
        }
        return singleSelectView
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
            var textField = UITextField.init(frame: CGRect(x: label.left, y: label.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
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
            arrow.isHidden = true
            headerView.addSubview(arrow)
            if num == 2 {
                var coverBtn = UIButton.init(frame: CGRect(x: textField.left, y: label.bottom, width: textField.width, height: lineView.top - label.top))
                coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
                coverBtn.tag = 3000 + num
                headerView.addSubview(coverBtn)
                arrow.isHidden = false
            }
            if num == 1 {
                textField.frame = CGRect(x: label.left, y: label.bottom + 5/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
                textField.placeholder = ""
            }
        }
        self.schoolNameTextField = headerView.viewWithTag(4000) as! UITextField//学校名称
        self.schoolStartTextField = headerView.viewWithTag(4001) as! UITextField//在校开始时间
        self.educationBgTextField = headerView.viewWithTag(4002) as! UITextField//学历
        self.majorTextField = headerView.viewWithTag(4003) as! UITextField//专业
        self.schoolEndTextField.frame = CGRect(x: self.schoolStartTextField!.right + 30/WIDTH_6_SCALE, y: self.schoolStartTextField!.top, width: self.schoolStartTextField!.width, height: self.schoolStartTextField!.height)
        self.startBtn.frame = self.schoolStartTextField!.bounds
        self.endBtn.frame = self.schoolEndTextField.bounds
        self.schoolStartTextField?.addSubview(self.startBtn)
        self.schoolEndTextField.addSubview(self.endBtn)
        headerView.addSubview(self.schoolEndTextField)
        
        self.schoolStartTextField!.layer.cornerRadius = 4
        self.schoolStartTextField!.layer.masksToBounds = true
        self.schoolStartTextField!.layer.borderWidth = 0.8
        self.schoolStartTextField!.layer.borderColor = UIColor.lightGray.cgColor
        self.schoolStartTextField!.textAlignment = .center
        self.schoolEndTextField.textAlignment = .center
        self.describeTitleLab.frame = CGRect(x: self.schoolStartTextField!.left, y: self.majorTextField!.bottom + 15/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
        headerView.addSubview(self.describeTitleLab)
        
        self.describeTextView.frame = CGRect(x: self.schoolStartTextField!.left, y: self.describeTitleLab.bottom + 15/WIDTH_6_SCALE, width: self.majorTextField!.width, height: 100/WIDTH_6_SCALE)
        headerView.addSubview(self.describeTextView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.describeTextView.bottom + 30/WIDTH_6_SCALE)
        
        let shortLineView = UIView.init(frame: CGRect(x: self.schoolStartTextField!.right + 5/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 1))
        shortLineView.backgroundColor = .lightGray
        shortLineView.centerY = self.schoolStartTextField!.centerY
        headerView.addSubview(shortLineView)
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
    
    @objc func coverBtnClick(btn: UIButton){
        //学历
        self.singleSelectView.showView(array: ["大专以下", "大专", "本科", "硕士", "博士", "博士以上"])
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
    
    @objc func saveBtnClick(){
        print("\(self.compareTime(startTime: self.schoolStartTextField!.text!, endTime: self.schoolEndTextField.text!))")//小于0，顺序正确；大于零，顺序调转
    }
}
