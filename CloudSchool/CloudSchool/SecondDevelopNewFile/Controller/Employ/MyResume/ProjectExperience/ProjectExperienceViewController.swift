//
//  ProjectExperienceViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/19.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ProjectExperienceViewController: UIViewController {
    var cellArr: [String] = ["项目名称", "开始时间 - 结束时间", "描述"]
    var selectTime: Int = 0
    var schoolStartTextField: UITextField?//在校开始时间
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        headerView.backgroundColor = UIColor.white
        for num in 0...self.cellArr.count - 1 {
            var label = UILabel.init(frame: CGRect(x: 37/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE + CGFloat(num) * 75/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE))
            label.textColor = .black
            label.font = DEF_FontSize_15
            label.backgroundColor = .clear
            label.textAlignment = .left
            label.tag = 2000 + num
            label.text = self.cellArr[num]
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
            if num != 1 {
                textField.placeholder = self.cellArr[num]
            }
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
            if num == 1{
                textField.frame = CGRect(x: label.left, y: label.bottom + 5/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
                textField.layer.cornerRadius = 4
                textField.layer.masksToBounds = true
                textField.layer.borderWidth = 0.8
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.textAlignment = .center
            }
        }
        headerView.addSubview(self.schoolEndTextField)
        self.schoolStartTextField = headerView.viewWithTag(4001) as! UITextField
        self.schoolEndTextField.frame = CGRect(x: self.schoolStartTextField!.right + 30/WIDTH_6_SCALE, y: self.schoolStartTextField!.top, width: self.schoolStartTextField!.width, height: self.schoolStartTextField!.height)
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        
        self.startBtn.frame = self.schoolStartTextField!.frame
        self.endBtn.frame = self.schoolEndTextField.frame
        headerView.addSubview(self.startBtn)
        headerView.addSubview(self.endBtn)
        
        let shortLineView = UIView.init(frame: CGRect(x: self.schoolStartTextField!.right + 5/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 1))
        shortLineView.backgroundColor = .lightGray
        shortLineView.centerY = self.schoolStartTextField!.centerY
        headerView.addSubview(shortLineView)
        
        return headerView
    }()
    lazy var schoolEndTextField: UITextField = {
        var schoolEndTextField = UITextField.init()
        schoolEndTextField.font = DEF_FontSize_15
        schoolEndTextField.backgroundColor = .clear
        schoolEndTextField.textColor = .black
        schoolEndTextField.textAlignment = .center
        schoolEndTextField.textColor = UIColor.colorWithHex(hex: "0378FD")
        schoolEndTextField.layer.cornerRadius = 4
        schoolEndTextField.layer.masksToBounds = true
        schoolEndTextField.layer.borderWidth = 0.8
        schoolEndTextField.layer.borderColor = UIColor.lightGray.cgColor
        return schoolEndTextField
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
        return tableView
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
