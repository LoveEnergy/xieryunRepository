//
//  JobFeedbackViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/20.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class JobFeedbackViewController: UIViewController {
    var topViewArray: [String] = ["全部", "被查看", "待沟通", "邀面试", "不合适"]
    var allResumeBtn: UIButton?//全部
    var checkedBtn: UIButton?//被查看
    var untalkedBtn: UIButton?//待沟通
    var invitedBtn: UIButton?//邀面试
    var inappropriateBtn: UIButton?//不合适
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "求之反馈"
        self.setUpTopView()
    }
    
    func setUpTopView(){
        let topView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 46/WIDTH_6_SCALE))
        topView.backgroundColor = .white
        self.view.addSubview(topView)
        for num in 0...self.topViewArray.count - 1 {
            let btnW = SCREEN_WIDTH / 5
            let btn = UIButton.init(frame: CGRect(x: btnW * CGFloat(num), y: 0, width: btnW, height: topView.height))
            btn.backgroundColor = .white
            btn.setTitle(self.topViewArray[num], for: .normal)
            btn.titleLabel!.font = DEF_FontSize_12
            btn.setTitleColor(.black, for: .selected)
            btn.setTitleColor(UIColor.colorWithHex(hex: "999999"), for: .normal)
            btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
            btn.tag = 2000 + num
            topView.addSubview(btn)
        }
        let lineView = UIView.init(frame: CGRect(x: 0, y: topView.height - 0.8, width: SCREEN_WIDTH, height: 0.8))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        topView.addSubview(lineView)
        
        self.allResumeBtn = topView.viewWithTag(2000) as! UIButton
        self.checkedBtn = topView.viewWithTag(2001)  as! UIButton
        self.untalkedBtn = topView.viewWithTag(2002) as! UIButton
        self.invitedBtn = topView.viewWithTag(2003) as! UIButton
        self.inappropriateBtn = topView.viewWithTag(2004) as! UIButton
        self.allResumeBtn?.isSelected = true
        self.allResumeBtn?.titleLabel?.font = DEF_FontSize_18
        
        self.blueLineView.frame = CGRect(x: 0, y: topView.height - 3, width: 15/WIDTH_6_SCALE, height: 2)
        self.blueLineView.centerX = allResumeBtn!.centerX
        topView.addSubview(self.blueLineView)
        self.view.addSubview(topView)
        self.view.addSubview(self.tableView)
    }
    
    lazy var blueLineView : UIView = {
        var blueLineView = UIView.init()
        blueLineView.backgroundColor = UIColor.colorWithHex(hex: "0378fd")
        return blueLineView
    }()
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 46/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 98.5/WIDTH_6_SCALE
        tableView.register(JobFeedbackTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(JobFeedbackTableViewCell.self))
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        return headerView
    }()
    
    @objc func btnClick(btn: UIButton){
        self.blueLineView.centerX = btn.centerX
        if btn.tag == 2000 {
            self.allResumeBtn?.isSelected = true
            self.checkedBtn?.isSelected = false
            self.untalkedBtn?.isSelected = false
            self.invitedBtn?.isSelected = false
            self.inappropriateBtn?.isSelected = false
            self.allResumeBtn?.titleLabel?.font = DEF_FontSize_18
            self.checkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.untalkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.invitedBtn?.titleLabel!.font = DEF_FontSize_12
            self.inappropriateBtn?.titleLabel!.font = DEF_FontSize_12
        }
        if btn.tag == 2001 {
            self.allResumeBtn?.isSelected = false
            self.checkedBtn?.isSelected = true
            self.untalkedBtn?.isSelected = false
            self.invitedBtn?.isSelected = false
            self.inappropriateBtn?.isSelected = false
            self.allResumeBtn?.titleLabel?.font = DEF_FontSize_12
            self.checkedBtn?.titleLabel!.font = DEF_FontSize_18
            self.untalkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.invitedBtn?.titleLabel!.font = DEF_FontSize_12
            self.inappropriateBtn?.titleLabel!.font = DEF_FontSize_12
        }
        if btn.tag == 2002 {
            self.allResumeBtn?.isSelected = false
            self.checkedBtn?.isSelected = false
            self.untalkedBtn?.isSelected = true
            self.invitedBtn?.isSelected = false
            self.inappropriateBtn?.isSelected = false
            self.allResumeBtn?.titleLabel?.font = DEF_FontSize_12
            self.checkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.untalkedBtn?.titleLabel!.font = DEF_FontSize_18
            self.invitedBtn?.titleLabel!.font = DEF_FontSize_12
            self.inappropriateBtn?.titleLabel!.font = DEF_FontSize_12
        }
        if btn.tag == 2003 {
            self.allResumeBtn?.isSelected = false
            self.checkedBtn?.isSelected = false
            self.untalkedBtn?.isSelected = false
            self.invitedBtn?.isSelected = true
            self.inappropriateBtn?.isSelected = false
            self.allResumeBtn?.titleLabel?.font = DEF_FontSize_12
            self.checkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.untalkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.invitedBtn?.titleLabel!.font = DEF_FontSize_18
            self.inappropriateBtn?.titleLabel!.font = DEF_FontSize_12
        }
        if btn.tag == 2004 {
            self.allResumeBtn?.isSelected = false
            self.checkedBtn?.isSelected = false
            self.untalkedBtn?.isSelected = false
            self.invitedBtn?.isSelected = false
            self.inappropriateBtn?.isSelected = true
            self.allResumeBtn?.titleLabel?.font = DEF_FontSize_12
            self.checkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.untalkedBtn?.titleLabel!.font = DEF_FontSize_12
            self.invitedBtn?.titleLabel!.font = DEF_FontSize_12
            self.inappropriateBtn?.titleLabel!.font = DEF_FontSize_18
        }
    }
}

extension JobFeedbackViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(JobFeedbackTableViewCell.self), for: indexPath) as! JobFeedbackTableViewCell
        return cell
    }
}
