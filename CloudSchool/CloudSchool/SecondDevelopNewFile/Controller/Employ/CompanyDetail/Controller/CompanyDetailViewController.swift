//
//  CompanyDetailViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/10.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class CompanyDetailViewController: UIViewController {
    var cellNum = 0
    lazy var topBGView : UIImageView = {
        var topBGView = UIImageView.init(frame: CGRect(x: 0/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 106.5/WIDTH_6_SCALE))
        topBGView.image = UIImage.init(named: "employ_companyDetail")
        return topBGView
    }()
    lazy var iconImgView : UIImageView = {
        var iconImgView = UIImageView.init(frame: CGRect(x: 30/WIDTH_6_SCALE, y: 0, width: 47/WIDTH_6_SCALE, height: 43/WIDTH_6_SCALE))
        iconImgView.backgroundColor = UIColor.orange
        return iconImgView
    }()
    lazy var companyTitleLab : UILabel = {
        var companyTitleLab = UILabel.init()
        companyTitleLab.font = DEF_FontSize_16
        companyTitleLab.backgroundColor = .clear
        companyTitleLab.textColor = .black
        companyTitleLab.textAlignment = .left
        companyTitleLab.text = "中国环境监测总站"
        return companyTitleLab
    }()
    lazy var companyContentLab : UILabel = {
        var companyContentLab = UILabel.init()
        companyContentLab.font = DEF_FontSize_12
        companyContentLab.backgroundColor = .clear
        companyContentLab.textColor = UIColor.colorWithHex(hex: "888888")
        companyContentLab.textAlignment = .left
        companyContentLab.text = "不需要融资·北京·10000以上"
        return companyContentLab
    }()
    lazy var companyDetailBtn : UIButton = {
        var companyDetailBtn = UIButton.init()
        companyDetailBtn.setTitle("公司简介", for: .normal)
        companyDetailBtn.setTitleColor(UIColor.black, for: .normal)
        companyDetailBtn.setTitleColor(UIColor.colorWithHex(hex: "2d79f4"), for: .selected)
        companyDetailBtn.titleLabel?.font = DEF_FontSize_14
        companyDetailBtn.setBackgroundColor(.clear, forState: .normal)
        companyDetailBtn.addTarget(self, action: #selector(companyDetailBtnClick), for: .touchUpInside)
        return companyDetailBtn
    }()
    lazy var employingBtn : UIButton = {
        var employingBtn = UIButton.init()
        employingBtn.setTitle("在招职位", for: .normal)
        employingBtn.setTitleColor(UIColor.black, for: .normal)
        employingBtn.setTitleColor(UIColor.colorWithHex(hex: "2d79f4"), for: .selected)
        employingBtn.titleLabel?.font = DEF_FontSize_14
        employingBtn.setBackgroundColor(.clear, forState: .normal)
        employingBtn.addTarget(self, action: #selector(employingBtnClick), for: .touchUpInside)
        return employingBtn
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.tableHeaderView = self.headerView
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployHomeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(EmployHomeTableViewCell.self))
        tableView.rowHeight = 133.5/WIDTH_6_SCALE
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 106.5/WIDTH_6_SCALE + 40/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        headerView.addSubview(self.topBGView)
        self.topBGView.addSubview(self.iconImgView)
        self.topBGView.addSubview(self.companyTitleLab)
        self.topBGView.addSubview(self.companyContentLab)
        self.iconImgView.centerY = self.topBGView.height/2
        self.companyTitleLab.frame = CGRect(x: self.iconImgView.right + 13/WIDTH_6_SCALE, y: self.iconImgView.top + 4.5/WIDTH_6_SCALE, width: self.topBGView.width - 115/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
        self.companyContentLab.frame = CGRect(x: self.companyTitleLab.left, y: self.companyTitleLab.bottom + 10/WIDTH_6_SCALE, width: self.companyTitleLab.width, height: 13/WIDTH_6_SCALE)
        headerView.addSubview(self.companyDetailBtn)
        headerView.addSubview(self.employingBtn)
        headerView.addSubview(self.blueLineView)
        headerView.addSubview(self.grayLineView)
        self.companyDetailBtn.frame = CGRect(x: 13.5/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE + self.topBGView.bottom, width: 80/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
        self.employingBtn.frame = CGRect(x: self.companyDetailBtn.right + 20/WIDTH_6_SCALE, y: self.companyDetailBtn.top, width: self.companyDetailBtn.width, height: self.companyDetailBtn.height)
        self.blueLineView.frame = CGRect(x: 0, y: self.companyDetailBtn.bottom, width: self.companyDetailBtn.width - 8/WIDTH_6_SCALE, height: 1)
        self.blueLineView.centerX = self.companyDetailBtn.centerX
        self.grayLineView.frame = CGRect(x: 15/WIDTH_6_SCALE, y: self.blueLineView.bottom + 2/WIDTH_6_SCALE, width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 1)
        return headerView
    }()
    lazy var blueLineView : UIView = {
        var blueLineView = UIView.init()
        blueLineView.backgroundColor = UIColor.colorWithHex(hex: "2d79f4")
        return blueLineView
    }()
    lazy var grayLineView : UIView = {
        var grayLineView = UIView.init()
        grayLineView.backgroundColor = UIColor.colorWithHex(hex: "f7f7f7")
        return grayLineView
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        footerView.backgroundColor = .white
        footerView.addSubview(self.companyDetailLab)
        footerView.addSubview(self.companyLocationTitleLab)
        footerView.addSubview(self.locationImg)
        footerView.addSubview(self.companyLocationContentLab)
        footerView.addSubview(self.locationDetailImg)
        self.companyDetailLab.frame = CGRect(x: 17/WIDTH_6_SCALE, y: 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 34/WIDTH_6_SCALE, height: self.getLabelHeight(label: self.companyDetailLab, string: self.companyDetailLab.text!, font: 14, textAlignment: .left, width: SCREEN_WIDTH - 34/WIDTH_6_SCALE))
        self.companyLocationTitleLab.frame = CGRect(x: self.companyDetailLab.left, y: self.companyDetailLab.bottom + 20/WIDTH_6_SCALE, width: 100/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.locationImg.frame = CGRect(x: self.companyLocationTitleLab.left, y: self.companyLocationTitleLab.bottom + 20/WIDTH_6_SCALE, width: 20/WIDTH_6_SCALE, height: 18/WIDTH_6_SCALE)
        self.companyLocationContentLab.frame = CGRect(x: self.locationImg.right + 5/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - self.locationImg.right - 20/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE)
        self.companyLocationContentLab.centerY = self.locationImg.centerY
        self.locationDetailImg.frame = CGRect(x: 24/WIDTH_6_SCALE, y: self.companyLocationContentLab.bottom + 15/WIDTH_6_SCALE, width: SCREEN_WIDTH - 48/WIDTH_6_SCALE, height: 100/WIDTH_6_SCALE)
        footerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.locationDetailImg.bottom + 20/WIDTH_6_SCALE)
        return footerView
    }()
    lazy var companyDetailLab : UILabel = {
        var companyDetailLab = UILabel.init()
        companyDetailLab.font = DEF_FontSize_15
        companyDetailLab.backgroundColor = .clear
        companyDetailLab.textColor = UIColor.colorWithHex(hex: "919191")
        companyDetailLab.textAlignment = .left
        companyDetailLab.text = "不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上不需要融资·北京·10000以上"
        companyDetailLab.lineBreakMode = .byWordWrapping
        companyDetailLab.numberOfLines = 0
        return companyDetailLab
    }()
    lazy var locationImg : UIImageView = {
        var locationImg = UIImageView.init()
        locationImg.image = UIImage.init(named: "location")
        return locationImg
    }()
    lazy var companyLocationTitleLab : UILabel = {
        var companyLocationTitleLab = UILabel.init()
        companyLocationTitleLab.font = DEF_FontSize_14
        companyLocationTitleLab.backgroundColor = .clear
        companyLocationTitleLab.textColor = .black
        companyLocationTitleLab.textAlignment = .left
        companyLocationTitleLab.text = "公司地址:"
        return companyLocationTitleLab
    }()
    lazy var companyLocationContentLab : UILabel = {
        var companyLocationContentLab = UILabel.init()
        companyLocationContentLab.font = DEF_FontSize_14
        companyLocationContentLab.backgroundColor = .clear
        companyLocationContentLab.textColor = .black
        companyLocationContentLab.textAlignment = .left
        companyLocationContentLab.text = "北京市   朝阳区    安外大羊坊"
        return companyLocationContentLab
    }()
    lazy var locationDetailImg : UIImageView = {
        var locationDetailImg = UIImageView.init()
//        locationDetailImg.image = UIImage.init(named: "")
        locationDetailImg.backgroundColor = .orange
        return locationDetailImg
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
}

extension CompanyDetailViewController{
    @objc func companyDetailBtnClick(){
        self.companyDetailBtn.isSelected = true
        self.employingBtn.isSelected = false
        UIView.animate(withDuration: 0.3) {
            self.blueLineView.centerX = self.companyDetailBtn.centerX
            self.cellNum = 0
            self.tableView.tableFooterView = self.footerView
            self.tableView.reloadData()
        }
    }
    
    @objc func employingBtnClick(){
        self.companyDetailBtn.isSelected = false
        self.employingBtn.isSelected = true
        UIView.animate(withDuration: 0.3) {
            self.blueLineView.centerX = self.employingBtn.centerX
            self.cellNum = 5
            self.tableView.tableFooterView = UIView.init()
            self.tableView.reloadData()
        }
    }
    
    //label高度
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
}

extension CompanyDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cellNum
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmployHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(EmployHomeTableViewCell.self), for: indexPath) as! EmployHomeTableViewCell
        return cell
    }
}
