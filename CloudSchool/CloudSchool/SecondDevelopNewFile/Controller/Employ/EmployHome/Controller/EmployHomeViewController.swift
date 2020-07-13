//
//  EmployHomeViewController.swift
//  CloudSchool
//

//  Created by ENERGY on 2020/3/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import RxSwift
import RxCocoa
class EmployHomeViewController: UIViewController, UINavigationControllerDelegate  {
    var itemArr = ["五险一金", "全勤奖", "补充医疗保险", "补充医疗保险"]
    lazy var topView : UIView = {
        weak var weakSelf = self
        var btnY: CGFloat
        if Is_Iphone_X{
            btnY = 44/WIDTH_6_SCALE
        }else{
            btnY = 20/WIDTH_6_SCALE
        }
        var topView = UIView.init(frame: CGRect(x: 0, y: btnY, width: SCREEN_WIDTH, height: 44/WIDTH_6_SCALE))
        topView.backgroundColor = .clear
        topView.addSubview(weakSelf!.backBtn)
        topView.addSubview(weakSelf!.roleBtn)
        topView.addSubview(weakSelf!.hotBtn)
        topView.addSubview(weakSelf!.freshBtn)
        topView.addSubview(weakSelf!.searchBGView)
        weakSelf?.backBtn.centerY = topView.height/2
        weakSelf?.roleBtn.centerY = topView.height/2
        weakSelf?.hotBtn.centerY = topView.height/2
        weakSelf?.freshBtn.centerY = topView.height/2
        weakSelf?.searchBGView.centerY = topView.height/2
        topView.isUserInteractionEnabled = true
        return topView
    }()
    
    lazy var roleBtn : UIButton = {
        weak var weakSelf = self
        var roleBtn = UIButton(frame: CGRect(x: 20/WIDTH_6_SCALE + self.backBtn.right, y: 0, width: 72/WIDTH_6_SCALE, height: 19/WIDTH_6_SCALE))
        roleBtn.setTitle("招聘者", for: .normal)
        roleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        roleBtn.setImage(UIImage.init(named: "arrowDown"), for: .normal)
        roleBtn.imagePosition(at: .right, space: 5/WIDTH_6_SCALE)
        roleBtn.setTitleColor(UIColor.colorWithHex(hex: "0378FD"), for: .normal)
        roleBtn.addTarget(weakSelf, action: #selector(roleBtnClick(_:)), for: .touchUpInside)
        return roleBtn
    }()
    
    lazy var hotBtn : UIButton = {
        weak var weakSelf = self
        var hotBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 40/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        hotBtn.centerX = SCREEN_WIDTH/2 - 30/WIDTH_6_SCALE
        hotBtn.setTitle("热门", for: .normal)
        hotBtn.setTitleColor(UIColor.colorWithHex(hex: "666666"), for: .normal)
        hotBtn.titleLabel?.font = DEF_FontSize_15
        hotBtn.addTarget(self, action: #selector(functionBtnClick(btn:)), for: .touchUpInside)
        hotBtn.tag = 2000
        return hotBtn
    }()
    
    lazy var freshBtn : UIButton = {
        weak var weakSelf = self
        var freshBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: weakSelf!.hotBtn.width, height: weakSelf!.hotBtn.height))
        freshBtn.centerX = SCREEN_WIDTH/2 + 30/WIDTH_6_SCALE
        freshBtn.setTitle("最新", for: .normal)
        freshBtn.setTitleColor(UIColor.colorWithHex(hex: "666666"), for: .normal)
        freshBtn.titleLabel?.font = DEF_FontSize_15
        freshBtn.addTarget(self, action: #selector(functionBtnClick(btn:)), for: .touchUpInside)
        freshBtn.tag = 2001
        return freshBtn
    }()
    lazy var backBtn : UIButton = {
        weak var weakSelf = self
        var backBtn = UIButton.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: 0, width: 20/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        backBtn.setImage(UIImage.init(named: "clear_back"), for: .normal)
        backBtn.addTarget(self, action: #selector(backBtnClick), for: .touchUpInside)
        return backBtn
    }()
    
    lazy var searchTextField: UITextField = {
        weak var weakSelf = self
        var searchTextField = UITextField.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - weakSelf!.freshBtn.right - 15/WIDTH_6_SCALE - 10/WIDTH_6_SCALE, height: 54/WIDTH_6_SCALE))
        let searchImg = UIImageView.init(frame: CGRect(x: 0, y: 0, width: 12.5/WIDTH_6_SCALE, height: 12.5/WIDTH_6_SCALE))
        searchImg.image = UIImage.init(named: "search")
        searchTextField.leftView = searchImg
        searchTextField.leftViewMode = .always;
        searchTextField.font = DEF_FontSize_12
        searchTextField.placeholder = ""
        searchTextField.isUserInteractionEnabled = true
        searchTextField.delegate = self
        return searchTextField
    }()
    lazy var searchBGView : UIImageView = {
        weak var weakSelf = self
        var searchBGView = UIImageView.init(frame: CGRect(x: weakSelf!.freshBtn.right + 10/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - weakSelf!.freshBtn.right - 15/WIDTH_6_SCALE, height: 54/WIDTH_6_SCALE))
        searchBGView.backgroundColor = UIColor.clear
        searchBGView.image = UIImage.init(named: "searchBG")
        searchBGView.addSubview(self.searchTextField)
        searchBGView.isUserInteractionEnabled = true
        return searchBGView
    }()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: CGFloat(NAVI_HEIGHT), width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(EmployHomeTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(EmployHomeTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.rowHeight = 133.5/WIDTH_6_SCALE
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 260.5/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        headerView.addSubview(self.bannerImgView)
        self.bannerImgView.frame = CGRect(x: 8/WIDTH_6_SCALE, y: 5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 16/WIDTH_6_SCALE, height: 188.5/WIDTH_6_SCALE)
        headerView.addSubview(self.collectionView)
        headerView.addSubview(self.filtrateBtn)
        return headerView
    }()
    lazy var filtrateBtn : UIButton = {
        var filtrateBtn = UIButton.init(frame: CGRect(x: SCREEN_WIDTH - 96/WIDTH_6_SCALE, y: (260.5/WIDTH_6_SCALE - 188.5/WIDTH_6_SCALE)/2 + 188.5/WIDTH_6_SCALE - 15/WIDTH_6_SCALE, width: 96/WIDTH_6_SCALE, height: 28/WIDTH_6_SCALE))
        filtrateBtn.setImage(UIImage.init(named: "employ_filtrate"), for: .normal)
        return filtrateBtn
    }()
    lazy var bannerImgView : UIImageView = {
        var bannerImgView = UIImageView.init()
        bannerImgView.backgroundColor = UIColor.white
        return bannerImgView
    }()
    lazy var collectionView: UICollectionView = {
        var layout = EmployCollectionViewLayout.init(.left, 10/WIDTH_6_SCALE)
        layout.scrollDirection = .vertical//竖列
        layout.minimumLineSpacing = 10//竖行
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        var collectionView = UICollectionView.init(frame: CGRect(x: 10/WIDTH_6_SCALE, y: 198.5/WIDTH_6_SCALE, width: SCREEN_WIDTH - 96/WIDTH_6_SCALE - 20/WIDTH_6_SCALE, height: 260.5/WIDTH_6_SCALE - 188.5/WIDTH_6_SCALE - 20/WIDTH_6_SCALE), collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(EmployHomeTableViewCellCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(EmployHomeTableViewCellCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        footerView.backgroundColor = .white
        return footerView
    }()
    
    lazy var employGuideView : EmployGuideView = {
        var employGuideView = EmployGuideView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        employGuideView.employGuideViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.employGuideView.alpha = 0
            }) { (Bool) in
                self.employGuideView.removeFromSuperview()
            }
        }
        return employGuideView
    }()
    
    lazy var employSearchView : EmploySearchView = {
        var employSearchView = EmploySearchView.init(frame: CGRect(x: 0, y: -SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        employSearchView.employSearchViewDismissBlock = {
            UIView.animate(withDuration: 0.3) {
                self.employSearchView.frame = CGRect(x: 0, y: -SCREEN_HEIGHT, width: SCREEN_WIDTH, height: SCREEN_HEIGHT)
            }
        }
        return employSearchView
    }()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.topView)
        self.view.addSubview(self.tableView)
        self.employGuideView.showView()
        self.view.addSubview(self.employSearchView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self)
    }
}

extension EmployHomeViewController: UITextFieldDelegate{
    @objc func roleBtnClick(_ btn : UIButton){
        
    }
    
    @objc func backBtnClick(_ btn : UIButton){
        self.navigationController?.popViewController()
    }
    
    @objc func functionBtnClick(btn: UIButton){
        if btn.tag == 2000{
            
        }else{
            
        }
    }
    
    func getLabelWidth(text: String, font: UIFont, height: CGFloat)-> CGFloat {
        let statusLabelText: NSString = text as NSString
        let size = CGSize(width: CGFloat(MAXFLOAT), height: height)
        let strSize = statusLabelText.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
        return strSize.width
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        [self.navigationController popViewControllerAnimated:YES];
        UIView.animate(withDuration: 0.3) {
            self.employSearchView.frame = self.view.bounds
        }
        return false
    }
}

extension EmployHomeViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EmployHomeTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(EmployHomeTableViewCell.self), for: indexPath) as! EmployHomeTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PositionDetailViewController.init()
        vc.title = "职位详情"
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}

extension EmployHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.itemArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item: EmployHomeTableViewCellCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(EmployHomeTableViewCellCollectionViewCell.self), for: indexPath) as! EmployHomeTableViewCellCollectionViewCell
        item.model = self.itemArr[indexPath.row]
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.getLabelWidth(text: self.itemArr[indexPath.row], font: DEF_FontSize_12, height: 15/WIDTH_6_SCALE) + 10/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE)
    }
}
