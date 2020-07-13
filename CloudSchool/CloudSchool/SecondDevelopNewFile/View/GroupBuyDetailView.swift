//
//  GroupBuyDetailView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class GroupBuyDetailView: UIView {
    var cellArray : [GroupBuyModel] = [GroupBuyModel]()
    public var dismissGroupBuyDetailView:(()->())? //图层消失
    public var groupBuyIDBlock:((Int)->())?//团购ID
    lazy var tableView : UITableView = {
        let viewH = 200/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - viewH, width: SCREEN_WIDTH, height: viewH))
        tableView.rowHeight = 40/WIDTH_6_SCALE
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(GroupBuyTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(GroupBuyTableViewCell.self))
        return tableView
    }()
    lazy var headerView : UIView = {
        let viewH = 40/WIDTH_6_SCALE
        let btnW = 50/WIDTH_6_SCALE
        var headerView = UIView.init(frame : CGRect(x: 0, y: self.tableView.top - viewH, width: SCREEN_WIDTH, height: viewH))
        headerView.backgroundColor = .white
        var cancelBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - viewH - 15/WIDTH_6_SCALE, y: 0, width: btnW, height: viewH))
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(.black, for: .normal)
        cancelBtn.setBackgroundColor(.white, forState: .normal)
        cancelBtn.titleLabel?.font = DEF_FontSize_16
        cancelBtn.adjustsImageWhenHighlighted = false
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(btn:)), for: .touchUpInside)
        headerView.addSubview(cancelBtn)
        return headerView
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        footerView.backgroundColor = .white
        return footerView
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

extension GroupBuyDetailView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : GroupBuyTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(GroupBuyTableViewCell.self)) as! GroupBuyTableViewCell
        let model = cellArray[indexPath.row]
        cell.titleLab.text = model.groupBuyName
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = cellArray[indexPath.row]
        self.groupBuyIDBlock!(model.groupBuyID)
    }
}

extension GroupBuyDetailView{
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    func dismissView(){
        self.dismissGroupBuyDetailView!()
    }
    @objc func cancelBtnClick(btn:UIButton){
        self.dismissView()
    }
}
