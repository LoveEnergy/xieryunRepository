//
//  JobIntentionViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/14.
//  Copyright © 2020 CEI. All rights reserved.
//  求职意向

import UIKit
import RxSwift
import RxCocoa

class JobIntentionViewController: UIViewController {
    let disposeBag: DisposeBag = DisposeBag()
    var selectTag: Int = 0
    var cellArr: [String] = ["行业类别", "职位类别", "期望薪资", "到岗时间"]
    var industryModelData: [IndustryPositionDetailModel] = [IndustryPositionDetailModel]()
    var jobModelData: [JobPositionDetailModel] = [JobPositionDetailModel]()
    var industryTextField: UITextField?//行业类别
    var jobTextField: UITextField?//职位类别
    var arrivalTextField: UITextField?//到岗时间
    var salaryTextField: UITextField?//期待薪资
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
            headerView.addSubview(arrow)
//            if num == 0 || num == 1 {
            var coverBtn = UIButton.init(frame: CGRect(x: textField.left, y: label.bottom, width: textField.width, height: lineView.top - label.top))
            coverBtn.addTarget(self, action: #selector(coverBtnClick(btn:)), for: .touchUpInside)
            coverBtn.tag = 3000 + num
            headerView.addSubview(coverBtn)
//            }
        }
        self.industryTextField = (headerView.viewWithTag(4000) as! UITextField)//行业类别
        self.jobTextField = (headerView.viewWithTag(4001) as! UITextField)//职位类别
        self.arrivalTextField = (headerView.viewWithTag(4002) as! UITextField)//
        self.salaryTextField = (headerView.viewWithTag(4003) as! UITextField)//
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
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
        singleSelectView.selectIndustryPositionBlock = {(industryModel: IndustryPositionDetailModel) in
            self.industryTextField!.text = industryModel.industryName
            self.singleSelectView.dismissView()
        }
        singleSelectView.selectJobPositionBlock = {(jobModel: JobPositionDetailModel) in
            self.jobTextField!.text = jobModel.jobName
            self.singleSelectView.dismissView()
        }
        singleSelectView.selectStringBlock = { (selectString) in
            if self.selectTag == 3002{
                self.arrivalTextField!.text = selectString
            }
            if self.selectTag == 3003{
                self.salaryTextField!.text = selectString
            }
            self.singleSelectView.dismissView()
        }
        return singleSelectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.loadData()
        let saveBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 25/WIDTH_6_SCALE, height: 25/WIDTH_6_SCALE))
        saveBtn.setTitle("保存", for: .normal)
        saveBtn.setTitleColor(.black, for: .normal)
        saveBtn.titleLabel!.font = DEF_FontSize_14
        saveBtn.addTarget(self, action: #selector(saveBtnClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: saveBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func coverBtnClick(btn: UIButton){
        self.selectTag = btn.tag
        if btn.tag == 3000 {
            self.singleSelectView.showView(industryPositionArray: self.industryModelData)
        }
        if btn.tag == 3001{
            self.singleSelectView.showView(jobPositionArray: self.jobModelData)
        }
        if btn.tag == 3002{
            self.singleSelectView.showView(array: ["1k元以下", "1k - 2k", "2k - 4k", "4k - 6k", "6k - 8k", "8k - 10k", "10k - 15k", "15k - 25k", "25k - 35k", "35k - 50k", "50k上"])
        }
        if btn.tag == 3003{
            self.singleSelectView.showView(array: ["随时到岗", "月内到岗", "考虑机会", "暂不考虑"])
        }
    }
    
    func loadData(){
        HUD.loading(text: "")
        EmployHelper.shared.allIndustryPosition(parentID: 0)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                guard let data = model.data else { return }
                self.industryModelData = data
            }, onError: { (error) in
                HUD.hideLoading()
            })
        .disposed(by: disposeBag)
        HUD.loading(text: "")
        EmployHelper.shared.allJobPosition(parentID: 0)
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                guard let data = model.data else { return }
                self.jobModelData = data
            }, onError: { (error) in
                HUD.hideLoading()
            })
        .disposed(by: disposeBag)
    }
    
    @objc func saveBtnClick(){
        let industryTempString = self.industryTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let jobTempString = self.jobTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let arrivalTempString = self.arrivalTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        let salaryTempString = self.salaryTextField?.text!.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
        if industryTempString!.isEmpty || jobTempString!.isEmpty || arrivalTempString!.isEmpty || salaryTempString!.isEmpty{
            HUD.showText(text: "请完整填写个人信息")
        }else{
            //接口
        }
    }
}
