//
//  ActivityDetailView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/1/17.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class ActivityDetailView: UIView {
    var cellArray : [GroupBuyModel] = [GroupBuyModel]()
    public var dismissActivityDetailView:(()->())? //
    lazy var tableView : UITableView = {
        let viewH = 200/WIDTH_6_SCALE
        var tableView = UITableView.init(frame: CGRect(x: 0, y: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - viewH, width: SCREEN_WIDTH, height: viewH))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ActivityDetailTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ActivityDetailTableViewCell.self))
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        // 设置预估行高 --> 先让 tableView 能滚动，在滚动的时候再去计算显示的 cell 的真正的行高，并且调整 tabelView 的滚动范围
        tableView.estimatedRowHeight = 300
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
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: 0, width: 70/WIDTH_6_SCALE, height: headerView.height))
        titleLab.centerX = SCREEN_WIDTH/2
        titleLab.text = "活动详情"
        titleLab.font = DEF_FontSize_14
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        headerView.addSubview(titleLab)
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

extension ActivityDetailView : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ActivityDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ActivityDetailTableViewCell.self)) as! ActivityDetailTableViewCell
        let model = cellArray[indexPath.row]
        cell.titleLab.text = "\(indexPath.row + 1)、\(model.productDescription)"
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellArray.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissView()
    }
}

extension ActivityDetailView{
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
        self.dismissActivityDetailView!()
    }
    @objc func cancelBtnClick(btn:UIButton){
        self.dismissView()
    }
}
