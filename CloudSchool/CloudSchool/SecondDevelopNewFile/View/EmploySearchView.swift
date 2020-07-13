//
//  EmploySearchView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/23.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmploySearchView: UIView {
    public var employSearchViewDismissBlock:(()->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        let btn = UIButton.init(frame: self.bounds)
        btn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        self.addSubview(btn)
        self.addSubview(self.topWhiteView)
        self.addSubview(self.searchTitleLab)
        self.addSubview(self.leftTableView)
        self.addSubview(self.rightTableView)
        self.addSubview(self.clearBtn)
        self.addSubview(self.btnBGView)
        self.btnBGView.addSubview(self.sureBtn)
        self.addSubview(self.lineView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topWhiteView : UIView = {
        weak var weakSelf = self
        var topWhiteView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 148.5/WIDTH_6_SCALE))
        topWhiteView.backgroundColor = UIColor.white
        topWhiteView.addSubview(weakSelf!.searchBGView)
        topWhiteView.addSubview(weakSelf!.searchBtn)
        topWhiteView.addSubview(weakSelf!.filtrateLab)
        topWhiteView.addSubview(weakSelf!.trangleView)
        weakSelf?.searchBtn.frame = CGRect(x: (weakSelf?.searchBGView.right)!, y: (weakSelf?.searchBGView.top)!, width: SCREEN_WIDTH - (weakSelf?.searchBGView.right)!, height: (weakSelf?.searchBGView.height)!)
        weakSelf?.filtrateLab.frame = CGRect(x: 15/WIDTH_6_SCALE, y: self.searchBGView.bottom + 10/WIDTH_6_SCALE, width: 50/WIDTH_6_SCALE, height: 13/WIDTH_6_SCALE)
        weakSelf?.trangleView.frame = CGRect(x: (weakSelf?.filtrateLab.right)!, y: 0, width: 8.5/WIDTH_6_SCALE, height: 5.5/WIDTH_6_SCALE)
        weakSelf?.trangleView.centerY = (weakSelf?.filtrateLab.centerY)!
        return topWhiteView
    }()
    
    lazy var searchTextField: UITextField = {
        weak var weakSelf = self
        var searchTextField = UITextField.init()
        let searchImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 12.5/WIDTH_6_SCALE, height: 12.5/WIDTH_6_SCALE))
        searchImg.image = UIImage.init(named: "search")
        searchTextField.leftView = searchImg
        searchTextField.leftViewMode = .always;
        searchTextField.font = DEF_FontSize_12
        searchTextField.placeholder = "搜索职位、公司名称"
        searchTextField.isUserInteractionEnabled = true
        return searchTextField
    }()
    
    lazy var searchBGView : UIImageView = {
        weak var weakSelf = self
        var searchBGView = UIImageView.init(frame: CGRect(x: 10.5/WIDTH_6_SCALE, y: 55/WIDTH_6_SCALE, width: SCREEN_WIDTH - 10.5/WIDTH_6_SCALE - 44.5/WIDTH_6_SCALE, height: 50/WIDTH_6_SCALE))
        searchBGView.backgroundColor = UIColor.clear
        searchBGView.image = UIImage.init(named: "employ_search_search")
        searchBGView.isUserInteractionEnabled = true
        searchBGView.addSubview(weakSelf!.searchTextField)
        weakSelf?.searchTextField.frame = CGRect(x: 20/WIDTH_6_SCALE, y: 0, width: searchBGView.width - 25/WIDTH_6_SCALE, height: searchBGView.height)
        return searchBGView
    }()
    
    lazy var searchBtn : UIButton = {
        var searchBtn = UIButton.init()
        searchBtn.setTitle("搜索", for: .normal)
        searchBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        searchBtn.titleLabel?.font = DEF_FontSize_12
        searchBtn.setBackgroundColor(.clear, forState: .normal)
        return searchBtn
    }()
    
    lazy var searchTitleLab : UILabel = {
        var searchTitleLab = UILabel.init(frame: CGRect(x: 0, y: 20/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 35/WIDTH_6_SCALE))
        searchTitleLab.font = DEF_FontSize_18
        searchTitleLab.backgroundColor = .clear
        searchTitleLab.textColor = .black
        searchTitleLab.textAlignment = .center
        searchTitleLab.text = "搜索"
        return searchTitleLab
    }()
    
    lazy var filtrateLab : UILabel = {
        var filtrateLab = UILabel.init()
        filtrateLab.font = DEF_FontSize_12
        filtrateLab.backgroundColor = .clear
        filtrateLab.textColor = UIColor.colorWithHex(hex: "0378FD")
        filtrateLab.textAlignment = .left
        filtrateLab.text = "筛选"
        return filtrateLab
    }()
    
    lazy var trangleView : UIImageView = {
        var trangleView = UIImageView.init()
        trangleView.image = UIImage.init(named: "employ_search_trangle")
        trangleView.backgroundColor = UIColor.colorWithHex(hex: "e8e8e8")
        return trangleView
    }()
    
    lazy var leftTableView : UITableView = {
        weak var weakSelf = self
        var leftTableView = UITableView.init(frame: CGRect(x: 0, y: weakSelf!.topWhiteView.bottom, width: SCREEN_WIDTH / 2 - 30/WIDTH_6_SCALE, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - 100/WIDTH_6_SCALE - (weakSelf?.topWhiteView.height)! - CGFloat(NAVI_HEIGHT)))
        leftTableView.backgroundColor = .white
        leftTableView.delegate = self
        leftTableView.dataSource = self
        leftTableView.separatorStyle = .none
        leftTableView.register(EmploySearchLeftTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(EmploySearchLeftTableViewCell.self))
        leftTableView.rowHeight = 45/WIDTH_6_SCALE
        return leftTableView
    }()
    
    lazy var rightTableView : UITableView = {
        weak var weakSelf = self
        var rightTableView = UITableView.init(frame: CGRect(x: (weakSelf?.leftTableView.right)!, y: (weakSelf?.leftTableView.top)!, width: SCREEN_WIDTH - (weakSelf?.leftTableView.width)!, height: (weakSelf?.leftTableView.height)!))
        rightTableView.backgroundColor = UIColor.colorWithHex(hex: "FAFAFA")
        rightTableView.delegate = self
        rightTableView.dataSource = self
        rightTableView.separatorStyle = .none
        leftTableView.rowHeight = 45/WIDTH_6_SCALE
        rightTableView.register(EmploySearchRightTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(EmploySearchRightTableViewCell.self))
        return rightTableView
    }()
    
    lazy var clearBtn : UIButton = {
        weak var weakSelf = self
        var clearBtn = UIButton.init(frame: CGRect(x: 0, y: (weakSelf?.leftTableView.bottom)!, width: SCREEN_WIDTH/2, height: 50/WIDTH_6_SCALE))
        clearBtn.setTitle("清空", for: .normal)
        clearBtn.setTitleColor(.black, for: .normal)
        clearBtn.titleLabel?.font = DEF_FontSize_14
        clearBtn.setBackgroundColor(.white, forState: .normal)
        return clearBtn
    }()
    
    lazy var sureBtn : UIButton = {
        weak var weakSelf = self
        let btnW = 104/WIDTH_6_SCALE
        var sureBtn = UIButton.init(frame: CGRect(x: (SCREEN_WIDTH/2 - btnW)/2, y: 10/WIDTH_6_SCALE, width: btnW, height: (weakSelf?.clearBtn.height)! - 20/WIDTH_6_SCALE))
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(UIColor.white, for: .normal)
        sureBtn.titleLabel?.font = DEF_FontSize_14
        sureBtn.setBackgroundColor(UIColor.colorWithHex(hex: "0378FD"), forState: .normal)
        sureBtn.layer.cornerRadius = ((weakSelf?.clearBtn.height)! - 20/WIDTH_6_SCALE)/2
        sureBtn.layer.masksToBounds = true
        return sureBtn
    }()
    
    lazy var btnBGView : UIView = {
        weak var weakSelf = self
        var btnBGView = UIView.init(frame: CGRect(x: SCREEN_WIDTH/2, y: (weakSelf?.clearBtn.top)!, width: SCREEN_WIDTH/2, height: (weakSelf?.clearBtn.height)!))
        btnBGView.backgroundColor = UIColor.white
        return btnBGView
    }()
    lazy var lineView : UIView = {
        weak var weakSelf = self
        var lineView = UIView.init(frame: CGRect(x: (weakSelf?.clearBtn.right)! - 0.5, y: (weakSelf?.clearBtn.top)!, width: 1, height: (weakSelf?.clearBtn.height)!))
        lineView.backgroundColor = .black
        return lineView
    }()
}

extension EmploySearchView: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.leftTableView {
            return 5
        }
        if tableView == self.rightTableView {
            return 4
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.leftTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(EmploySearchLeftTableViewCell.self), for: indexPath) as! EmploySearchLeftTableViewCell
            return cell
        }
        if tableView == self.rightTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(EmploySearchRightTableViewCell.self), for: indexPath) as! EmploySearchRightTableViewCell
            return cell
        }
        let cell = UITableViewCell.init()
        return cell
    }
    
    
}

extension EmploySearchView{
    @objc func btnClick(btn:UIButton){
        self.employSearchViewDismissBlock?()
    }
}
