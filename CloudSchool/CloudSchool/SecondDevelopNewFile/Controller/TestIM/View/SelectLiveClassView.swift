//
//  SelectLiveClassView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/5/14.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class SelectLiveClassView: UIView {
    public var cancelBtnBlock:(()->())?//取消
    public var selectLiveClassBlock:((SelectLiveClassDataModel)->())?//选择要开始的直播课程
    var classArray: [SelectLiveClassDataModel] = [SelectLiveClassDataModel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        let btn = UIButton.init(frame: self.bounds)
        self.addSubview(btn)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.bgView)
        self.bgView.addSubview(self.tableView)
        self.bgView.addSubview(self.footerView)
        self.bgView.centerY = self.centerY - 30/WIDTH_6_SCALE
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgView : UIView = {
        var bgView = UIView.init(frame: CGRect(x: 30/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - 60/WIDTH_6_SCALE, height: SCREEN_HEIGHT - 250/WIDTH_6_SCALE))
        bgView.layer.cornerRadius = 4
        bgView.layer.masksToBounds = true
        bgView.backgroundColor = .white
        return bgView
    }()
    
    lazy var tableView : UITableView = {
        weak var weakSelf = self
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: (weakSelf?.bgView.width)!, height: (weakSelf?.bgView.height)! - 50/WIDTH_6_SCALE))
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectLiveClassTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SelectLiveClassTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var footerView : UIView = {
        weak var weakSelf = self
        var footerView = UIView.init(frame: CGRect(x: 0, y: self.tableView.bottom, width: self.tableView.width, height: 50/WIDTH_6_SCALE))
        footerView.backgroundColor = .white
        var cancelBtn = UIButton.init(frame: footerView.bounds)
        cancelBtn.setBackgroundColor(UIColor.colorWithHex(hex: "1FA2F8"), forState: .normal)
        cancelBtn.setTitle("退出", for: .normal)
        cancelBtn.setTitleColor(.white, for: .normal)
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        footerView.addSubview(cancelBtn)
        return footerView
    }()
}

extension SelectLiveClassView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(SelectLiveClassTableViewCell.self), for: indexPath) as! SelectLiveClassTableViewCell
        cell.model = self.classArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.classArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60/WIDTH_6_SCALE
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectLiveClassBlock?(self.classArray[indexPath.row])
    }
}

extension SelectLiveClassView{
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
        UIView.animate(withDuration: 0.15, animations: {
            self.alpha = 0
        }) { (Bool) in
            self.removeFromSuperview()
        }
    }
    
    @objc func cancelBtnClick(){
        self.cancelBtnBlock?()
    }
    
    /// 圆角设置/部分圆角
    ///
    /// - Parameters:
    ///   - view: 需要设置的控件
    ///   - corner: 哪些圆角
    ///   - radii: 圆角半径
    /// - Returns: layer图层
    func configRectCorner(view: UIView, corner: UIRectCorner, radii: CGSize) {
        let maskPath = UIBezierPath.init(roundedRect: view.bounds, byRoundingCorners: corner, cornerRadii: radii)
        let maskLayer = CAShapeLayer.init()
        maskLayer.frame = view.bounds
        maskLayer.path = maskPath.cgPath
        view.layer.mask = maskLayer
    }
}
