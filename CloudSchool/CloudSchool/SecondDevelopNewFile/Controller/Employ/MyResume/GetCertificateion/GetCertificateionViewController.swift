//
//  GetCertificateionViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GetCertificateionViewController: UIViewController {
    
    var certificateNameTextField: UITextField?
    var getCertificateTimeTextField: UITextField?
    var awardCertificateOrganationTextField: UITextField?
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
    
    var cellArr: [String] = ["证书名称", "获得时间", "颁发单位", "上传证书"]
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
            headerView.addSubview(startLab)
            if num == 0 || num == 1 {
                startLab.isHidden = false
            }
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
            if num == 1 || num == 3 {
                var coverBtn = UIButton.init(frame: CGRect(x: textField.left, y: label.bottom, width: textField.width, height: lineView.top - label.top))
                coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
                coverBtn.tag = 3000 + num
                headerView.addSubview(coverBtn)
                if num == 3 {
                    arrow.isHidden = true
                    coverBtn.frame = CGRect(x: textField.left, y: label.bottom + 15/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 100/WIDTH_6_SCALE)
                    coverBtn.setBackgroundColor(.orange, forState: .normal)
                    lineView.frame = CGRect(x: textField.left, y: coverBtn.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 74/WIDTH_6_SCALE, height: 1)
                }
            }
        }
        self.certificateNameTextField = headerView.viewWithTag(4000) as! UITextField
        self.getCertificateTimeTextField = headerView.viewWithTag(4001) as! UITextField
        self.awardCertificateOrganationTextField = headerView.viewWithTag(4002) as! UITextField
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return headerView
    }()
    
    lazy var datePickerView : QFDatePickerView = {
        var datePickerView = QFDatePickerView.init(yearPickerViewWithResponse: {(year) in
            self.getCertificateTimeTextField!.text? = "\(year!)年"
        })
        return datePickerView!
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
        return tableView
    }()
    
    @objc func coverBtnClick(btn: UIButton){
        if btn.tag == 3001 {
            self.datePickerView.show()
        }
    }
    
    @objc func saveBtnClick(){
        
    }
}
