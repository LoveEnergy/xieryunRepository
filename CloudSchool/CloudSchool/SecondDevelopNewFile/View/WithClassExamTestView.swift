//
//  WithClassExamTestView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/16.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class WithClassExamTestView: UIView, UITableViewDelegate, UITableViewDataSource {
    public var startTestBlock:((String, String, Int)->())?
    public var checkTestBlock:((String, String, Int, Int)->())?
    var isAllowShowAnswer: Int?
    var cellArr: [ExamBaseInfoModel] = [ExamBaseInfoModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let bgBtn = UIButton.init(frame: self.bounds)
        bgBtn.setBackgroundColor(UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9), forState: .normal)
        bgBtn.addTarget(self, action: #selector(bgBtnClick), for: .touchUpInside)
        self.addSubview(bgBtn)
        self.addSubview(self.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var tableView : UITableView = {
        var tableViewY = 180/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: tableViewY, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - tableViewY))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WithClassExamTestTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(WithClassExamTestTableViewCell.self))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.rowHeight = 155/WIDTH_6_SCALE
        return tableView
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(WithClassExamTestTableViewCell.self), for: indexPath) as! WithClassExamTestTableViewCell
        cell.model = self.cellArr[indexPath.row]
        cell.startTestBtnClickBlock = {(paperID: String, examID: String) in
            self.startTestBlock?(paperID, examID, indexPath.row)
        }
        cell.checkTestBtnClickBlock = {(paperID: String, examID: String) in
            self.checkTestBlock?(paperID, examID, indexPath.row, self.isAllowShowAnswer!)
        }
        return cell
    }
    
    @objc func bgBtnClick(){
        self.dismissView()
    }
    
    func showView(data: [ExamBaseInfoModel]){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
        if data.count > 0 {
            self.isAllowShowAnswer = data[0].isAllowViewAnswer
            self.cellArr.removeAll()
            self.cellArr = data
            self.tableView.reloadData()
        }
    }
    
    func dismissView(){
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
}
