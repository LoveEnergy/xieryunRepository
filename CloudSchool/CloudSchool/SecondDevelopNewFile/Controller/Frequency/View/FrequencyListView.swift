//
//  FrequencyListView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/2.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class FrequencyListView: UIView {
    public var dismissViewBlock:(()->())?
    public var selectVoiceBlock:((Int)->())?
    var listArr: [CourseWareModel] = [CourseWareModel]()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT/2 + 50/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    
    init(frame: CGRect, array: [CourseWareModel]) {
        super.init(frame: frame)
        self.listArr.removeAll()
        self.listArr = array
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.tableView)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FrequencyListView{
    @objc func btnClick(btn: UIButton){
        self.dismissViewBlock?()
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

extension FrequencyListView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        cell.textLabel?.text = self.listArr[indexPath.row].coursewareName
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectVoiceBlock?(indexPath.row)
    }
}
