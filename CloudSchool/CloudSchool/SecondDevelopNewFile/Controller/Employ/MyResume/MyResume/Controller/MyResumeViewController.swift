//
//  MyResumeViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/10.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class MyResumeViewController: UIViewController {
//    var cellArr: [[String: String]] = [[String: String]]()
    var addIndex: Int = 0
    var cellArr = [
        ["sectionTitle":"个人信息", "addBlock":"添加个人信息"],
        ["sectionTitle":"求职意向", "addBlock":"添加求职意向"],
        ["sectionTitle":"教育经历", "addBlock":"添加教育经历"],
        ["sectionTitle":"工作经历", "addBlock":"添加工作经历"],
        ["sectionTitle":"项目经历", "addBlock":"添加工作经历"],
        ["sectionTitle":"培训经历", "addBlock":"添加培训经历"],
        ["sectionTitle":"语言能力", "addBlock":"添加语言能力"],
        ["sectionTitle":"所获证书", "addBlock":"添加所获证书"],
        ["sectionTitle":"技能特长", "addBlock":"添加技能特长"],
        ["sectionTitle":"自我评价", "addBlock":"添加自我评价"],
        ["sectionTitle":"获得的科研水平、工作业绩及奖惩", "addBlock":"添加获得成就"],
        ["sectionTitle":"家庭成员", "addBlock":"添加家庭成员"]]
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        return headerView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.title = "我的简历"
    }
}

extension MyResumeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.cellArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell: MyResumeBlockTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MyResumeBlockTableViewCell.self), for: indexPath) as! MyResumeBlockTableViewCell
//        cell.model = self.cellArr[indexPath.section]["addBlock"]
//        cell.fillInInfoBlock = {
//            if indexPath.row == 0{
//                let vc = PersonalInfoViewController.init()
//                vc.title = "个人信息"
//                CurrentControllerHelper.pushViewController(viewController: vc)
//            }
//        }
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 40/WIDTH_6_SCALE))
        let img = UIImageView.init(frame: CGRect(x: 26.5/WIDTH_6_SCALE, y: 0, width: 12.5/WIDTH_6_SCALE, height: 12.5/WIDTH_6_SCALE))
        img.centerY = bgView.centerY
        img.backgroundColor = .orange
        bgView.addSubview(img)
        let label = UILabel.init(frame: CGRect(x: img.right + 6/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 6/WIDTH_6_SCALE - img.right, height: 20/WIDTH_6_SCALE))
        label.centerY = img.centerY
        label.text = self.cellArr[section]["sectionTitle"]
        label.font = DEF_FontSize_15
        label.textColor = .black
        label.textAlignment = .left
        bgView.addSubview(label)
        return bgView
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let bgView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 67/WIDTH_6_SCALE))
        bgView.backgroundColor = .clear
        let addBtn = UIButton.init(frame: CGRect(x: 42/WIDTH_6_SCALE, y: 17/WIDTH_6_SCALE, width: SCREEN_WIDTH - 84/WIDTH_6_SCALE, height: 32/WIDTH_6_SCALE))
        addBtn.setTitle(self.cellArr[section]["addBlock"], for: .normal)
        addBtn.setTitleColor(UIColor.colorWithHex(hex: "FF6434"), for: .normal)
        addBtn.titleLabel?.font = DEF_FontSize_18
        addBtn.setBackgroundImage(UIImage.init(named: "employ_block_info"), for: .normal)
        addBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        addBtn.tag = 3000 + section
        bgView.addSubview(addBtn)
        let lineView = UIView.init(frame: CGRect(x: 29.5/WIDTH_6_SCALE, y: addBtn.bottom + 16/WIDTH_6_SCALE, width: SCREEN_WIDTH - 59/WIDTH_6_SCALE, height: 1))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "F1F1F1")
        bgView.addSubview(lineView)
        return bgView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40/WIDTH_6_SCALE
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 67/WIDTH_6_SCALE
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 1/WIDTH_6_SCALE
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let headerViewHeight: CGFloat = 66/WIDTH_6_SCALE
        if scrollView.contentOffset.y < headerViewHeight{
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else if scrollView.contentOffset.y >= -headerViewHeight && scrollView.contentOffset.y >= headerViewHeight{
            scrollView.contentInset = UIEdgeInsets(top: -headerViewHeight, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func btnClick(btn: UIButton){
        if  btn.tag == 3000{
            let vc = PersonalInfoViewController.init()
            vc.title = "个人信息"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3001 {
            let vc = JobIntentionViewController.init()
            vc.title = "求职意向"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3002{
            let vc = EducationViewController.init()
            vc.title = "教育经历"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3003{
            let vc = WorkExperienceViewController.init()
            vc.title = "工作经历"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3004 {
            let vc = ProjectExperienceViewController.init()
            vc.title = "项目经历"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3005{
            let vc = TrainingExperienceViewController.init()
            vc.title = "培训经历"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3006{
            let vc = LanguageAbilityViewController.init()
            vc.title = "语言能力"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3007{
            let vc = GetCertificateionViewController.init()
            vc.title = "所获证书"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3008{
            let vc = SpecialtyViewController.init()
            vc.title = "技能特长"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3009{
            let vc = SelfEvaluationViewController.init()
            vc.title = "自我评价"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3010{
            let vc = PrizeViewController.init()
            vc.title = "获得科研水平、工作业绩及奖惩"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        if btn.tag == 3011{
            let vc = FamilyViewController.init()
            vc.title = "家庭成员"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
    }
}
