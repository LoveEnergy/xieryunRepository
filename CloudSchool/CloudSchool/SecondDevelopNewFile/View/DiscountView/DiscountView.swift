//
//  DiscountView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/13.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class DiscountView: UIView {
    public var dismissDiscountViewBlock:(()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addSubview(self.bgBtn)
        self.addSubview(self.tableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var bgBtn: UIButton = {
        var bgBtn = UIButton.init(frame: self.bounds)
        bgBtn.setBackgroundColor(UIColor.clear, forState: .normal)
        bgBtn.addTarget(self, action: #selector(bgBtnClick), for: .touchUpInside)
        return bgBtn
    }()
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscountViewTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(DiscountViewTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.colorWithHex(hex: "F4F5F6")
        tableView.rowHeight = 25/WIDTH_6_SCALE
        tableView.layer.cornerRadius = 4
        tableView.layer.masksToBounds = true
        tableView.layer.borderColor = UIColor.gray.cgColor
        tableView.layer.borderWidth = 0.8
        return tableView
    }()
}

extension DiscountView{
    func dismissView(){
        self.dismissDiscountViewBlock?()
    }
    
    func showView(frame: CGRect){
        self.tableView.frame = CGRect(x: 100, y: frame.maxY, width: 100, height: 200)
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    @objc func bgBtnClick(){
        self.dismissView()
    }
}

extension DiscountView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DiscountViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(DiscountViewTableViewCell.self)) as! DiscountViewTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissView()
    }
}
