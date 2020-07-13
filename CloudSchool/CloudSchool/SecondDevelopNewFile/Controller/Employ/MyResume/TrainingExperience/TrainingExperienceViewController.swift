//
//  TrainingExperienceViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/19.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class TrainingExperienceViewController: UIViewController {
    var trainStartTextField: UITextField?//
    var cellArr: [String] = ["培训课程名称", "培训机构", "培训时间", "培训地点", "培训证书", "描述"]
    var selectTime: Int = 0
    lazy var trainEndTextField: UITextField = {
        var trainEndTextField = UITextField.init()
        trainEndTextField.font = DEF_FontSize_15
        trainEndTextField.backgroundColor = .clear
        trainEndTextField.textColor = .black
        trainEndTextField.textAlignment = .center
        trainEndTextField.textColor = UIColor.colorWithHex(hex: "0378FD")
        trainEndTextField.layer.cornerRadius = 4
        trainEndTextField.layer.masksToBounds = true
        trainEndTextField.layer.borderWidth = 0.8
        trainEndTextField.layer.borderColor = UIColor.lightGray.cgColor
        return trainEndTextField
    }()
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
            startLab.isHidden = true
            if num == 0 || num == 1 || num == 2 {
                startLab.isHidden = false
            }
            headerView.addSubview(startLab)
            var textField = UITextField.init(frame: CGRect(x: label.left, y: label.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
            textField.font = DEF_FontSize_15
            textField.backgroundColor = .clear
            textField.textColor = .black
            textField.textAlignment = .left
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
            if num == 4 {
                textField.isHidden = true
                arrow.isHidden = true
                let iconBtn = UIButton.init(frame: CGRect(x: label.left, y: label.bottom + 10/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 100/WIDTH_6_SCALE))
                iconBtn.setBackgroundColor(.orange, forState: .normal)
                headerView.addSubview(iconBtn)
                lineView.frame = CGRect(x: label.left, y: iconBtn.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 1);
            }
            if num == 5{
                label.frame = CGRect(x: 37/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE + CGFloat(num) * 75/WIDTH_6_SCALE + 80/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
                textField.frame = CGRect(x: label.left, y: label.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 80/WIDTH_6_SCALE);
                lineView.frame = CGRect(x: label.left, y: textField.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 1);
                textField.layer.cornerRadius = 4;
                textField.layer.masksToBounds = true;
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.layer.borderWidth = 0.8
                arrow.isHidden = true
            }
            if num == 2{
                textField.frame = CGRect(x: label.left, y: label.bottom + 5/WIDTH_6_SCALE, width: 150/WIDTH_6_SCALE, height: 30/WIDTH_6_SCALE)
                textField.layer.cornerRadius = 4
                textField.layer.masksToBounds = true
                textField.layer.borderWidth = 0.8
                textField.layer.borderColor = UIColor.lightGray.cgColor
                textField.textAlignment = .center
                arrow.isHidden = true
            }
        }
        self.trainStartTextField = headerView.viewWithTag(4002) as! UITextField
        self.trainEndTextField.frame = CGRect(x: self.trainStartTextField!.right + 30/WIDTH_6_SCALE, y: self.trainStartTextField!.top, width: self.trainStartTextField!.width, height: self.trainStartTextField!.height)
        headerView.addSubview(self.trainEndTextField)
        
        let shortLineView = UIView.init(frame: CGRect(x: self.trainStartTextField!.right + 5/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 1))
        shortLineView.backgroundColor = .lightGray
        shortLineView.centerY = self.trainStartTextField!.centerY
        headerView.addSubview(shortLineView)
        
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return headerView
    }()
    
    lazy var datePickerView : QFDatePickerView = {
        var datePickerView = QFDatePickerView.init(datePackerWithResponse: {(selectData) in
            if self.selectTime == 1{
                self.trainStartTextField!.text = "\(selectData!)"
            }
            if self.selectTime == 2{
                self.trainEndTextField.text = "\(selectData!)"
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
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
    
    @objc func startBtnClick(btn: UIButton){
        self.selectTime = 1
        self.datePickerView.show()
    }
    
    @objc func endBtnClick(btn: UIButton){
        self.selectTime = 2
        self.datePickerView.show()
    }
    
    //判断两个日期大小
    func isExpired(time:String) -> Bool {
        let dformatters = DateFormatter.init()
        dformatters.dateFormat = "yyyy-MM"
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
    
    
}
