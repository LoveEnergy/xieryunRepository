//
//  ExamListView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/21.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ExamListView: UIView {
    var cellArray : [ExamResultInfoModel] = [ExamResultInfoModel]()
    public var dismissExamListView:(()->())? //图层消失
    lazy var tableView : UITableView = {
        var tableViewY = 180/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: tableViewY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - tableViewY))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExamListTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ExamListTableViewCell.self))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 51/WIDTH_6_SCALE
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: self.tableView.top - 50/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        let cancelBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 80/WIDTH_6_SCALE, y: 0, width: 60/WIDTH_6_SCALE, height: headerView.height))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.titleLabel?.font = DEF_FontSize_14
        cancelBtn.setBackgroundColor(.white, forState: .normal)
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        headerView.addSubview(cancelBtn)
        let lineView = UIView.init(frame: CGRect(x: 0, y: cancelBtn.bottom - 1, width: SCREEN_WIDTH, height: 1))
        lineView.backgroundColor = UIColor.colorWithHex(hex: "bcc0c1")
        headerView.addSubview(lineView)
        let titleLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: 80/WIDTH_6_SCALE, height: cancelBtn.height))
        titleLab.centerX = SCREEN_WIDTH/2
        titleLab.text = "考试成绩"
        titleLab.font = DEF_FontSize_14
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        headerView.addSubview(titleLab)
        return headerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.tableView)
        self.addSubview(self.headerView)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ExamListView{
    @objc func cancelBtnClick(){
        self.dismissView()
    }
    
    func dismissView(){
        self.dismissExamListView!()
    }
    
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
}

extension ExamListView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ExamListTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ExamListTableViewCell.self)) as! ExamListTableViewCell
        let model = cellArray[indexPath.row]
        let cellCount = cellArray.count - indexPath.row
        cell.titleLab.text = "第\(cellCount)次考试"
        cell.timeLab.text = model.createTime
        cell.scoreLab.text = "成绩:\(model.score)"
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
}
