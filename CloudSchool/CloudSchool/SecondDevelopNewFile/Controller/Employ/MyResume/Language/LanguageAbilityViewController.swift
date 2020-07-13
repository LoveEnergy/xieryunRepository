//
//  LanguageAbilityViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class LanguageAbilityViewController: UIViewController {
    var selectViewTag = 0
    var laungageTypeTextField: UITextField?//语言种类
    var listenAbilityTextField: UITextField?//听说能力
    var readAbilityTextField: UITextField?//读写能力
    
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
    
    var cellArr: [String] = ["语言种类", "听说能力", "读写能力"]
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
        }
        self.laungageTypeTextField = headerView.viewWithTag(4000) as! UITextField
        self.listenAbilityTextField = headerView.viewWithTag(4001) as! UITextField
        self.readAbilityTextField = headerView.viewWithTag(4002) as! UITextField
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
        return headerView
    }()
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.tableHeaderView = self.headerView
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
            if self.selectViewTag == 3000{
                self.laungageTypeTextField?.text = selectString
            }
            if self.selectViewTag == 3001{
                self.listenAbilityTextField?.text = selectString
            }
            if self.selectViewTag == 3002{
                self.readAbilityTextField?.text = selectString
            }
        }
        return singleSelectView
    }()
    
    @objc func coverBtnClick(btn: UIButton){
        self.selectViewTag = btn.tag
        if btn.tag == 3000 {
            self.singleSelectView.showView(array: ["英语", "日语", "韩语", "俄语", "其他"])
        }
        if btn.tag == 3001{
            self.singleSelectView.showView(array: ["一般", "良好", "熟悉", "精通"])
        }
        if btn.tag == 3002{
            self.singleSelectView.showView(array: ["一般", "良好", "熟悉", "精通"])
        }
    }
    
    @objc func saveBtnClick(){
        
    }
}
