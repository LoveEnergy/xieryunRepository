//
//  DiscountProductViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/7/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class DiscountProductViewController: UIViewController {
    var allBtn: UIButton?//全部
    var courseBtn: UIButton?//课程
    var classBtn: UIButton?//班级
    var bookBtn: UIButton?//书籍
    var liveBtn: UIButton?//直播
    var appointProductBtn: UIButton?//指定商品
    var promotionID: Int = 0
    var productScope: Int = 0//产品适用范围(0.全部品类 1.课程 2.书籍 3.班级 5.直播 6.指定产品)
    var pageNo: Int = 1
    var array: [DiscountProductDetailModel]?
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.loadData()
    }
    
    func loadData(){
        HUD.loading(text: "")
        UserHelper.shared.allDiscountProduct(promotionID: self.promotionID, productScope: self.productScope, pageNo: self.pageNo, pageSize: 10).subscribe(onNext: { (model) in
            HUD.hideLoading()
            self.tableView.endRefresh()
            if model.code == 200{
                if self.pageNo == 1 {
                    self.array?.removeAll()
                    self.array = model.data!.rows
                }else{
                    self.array = self.array! + model.data!.rows!
                }
                self.tableView.reloadData()
            }else{
                HUD.showText(text: model.message)
            }
        }, onError: { (error) in
            self.tableView.endRefresh()
            HUD.hideLoading()
            HUD.showError(error: error.localizedDescription ?? "未知错误")
        }).disposed(by: disposeBag)
    }
    
    func setUpUI(){
        self.title = "优惠商品"
        self.view.backgroundColor = .white
        self.view.addSubview(self.topView)
        self.topBarView()
        self.view.addSubview(self.tableView)
    }
    
    func topBarView(){
        let itemBtnW = SCREEN_WIDTH/6
        weak var weakSelf = self
        for i in 0...5 {
            let itemBtn = UIButton.init(frame: CGRect(x: itemBtnW * CGFloat(i), y: 10/WIDTH_6_SCALE, width: itemBtnW, height: (weakSelf?.topView.height)! - 20/WIDTH_6_SCALE))
            itemBtn.setTitle("按钮", for: .normal)
            itemBtn.titleLabel?.font = DEF_FontSize_14
            itemBtn.setTitleColor(UIColor.colorWithHex(hex: "4AA1F0"), for: .selected)
            itemBtn.setTitleColor(UIColor.colorWithHex(hex: "828282"), for: .normal)
            itemBtn.tag = 1000 + i
            itemBtn.addTarget(self, action: #selector(itemBtnClick(btn:)), for: .touchUpInside)
            self.topView.addSubview(itemBtn)
        }
        self.allBtn = self.topView.viewWithTag(1000) as! UIButton
        self.courseBtn = self.topView.viewWithTag(1001) as! UIButton
        self.classBtn = self.topView.viewWithTag(1002) as! UIButton
        self.bookBtn = self.topView.viewWithTag(1003) as! UIButton
        self.liveBtn = self.topView.viewWithTag(1004) as! UIButton
        self.appointProductBtn = self.topView.viewWithTag(1005) as! UIButton
        self.allBtn?.setTitle("全部", for: .normal)
        self.courseBtn?.setTitle("课程", for: .normal)
        self.classBtn?.setTitle("班级", for: .normal)
        self.bookBtn?.setTitle("书籍", for: .normal)
        self.liveBtn?.setTitle("直播", for: .normal)
        self.appointProductBtn?.setTitle("指定商品", for: .normal)
        self.allBtn?.isSelected = true
        self.view.addSubview(self.blueLineView)
        self.blueLineView.centerX = self.allBtn?.centerX as! CGFloat
    }
    lazy var topView : UIView = {
        var topView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 44/WIDTH_6_SCALE))
        topView.backgroundColor = .white
        return topView
    }()
    lazy var blueLineView : UIView = {
        var blueLineView = UIView.init(frame: CGRect(x: 0, y: self.allBtn!.bottom, width: 20/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE))
        blueLineView.backgroundColor = UIColor.colorWithHex(hex: "4AA1F0")
        return blueLineView
    }()
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: self.topView.bottom, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - self.topView.height - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableHeaderView = self.headerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DiscountProductTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(DiscountProductTableViewCell.self))
        tableView.rowHeight = 110/WIDTH_6_SCALE
        tableView.separatorStyle = .none
        tableView.addRefreshHeader {
            self.pageNo = 1
            self.loadData()
        }
        tableView.addRefreshFooter {
            self.pageNo += 1
            self.loadData()
        }
        return tableView
    }()
    
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 5/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        return headerView
    }()
    
    @objc func itemBtnClick(btn: UIButton){
        self.pageNo = 1
        self.allBtn?.isSelected = false
        self.courseBtn?.isSelected = false
        self.classBtn?.isSelected = false
        self.bookBtn?.isSelected = false
        self.liveBtn?.isSelected = false
        self.appointProductBtn?.isSelected = false
        if btn.tag == 1000 {
            self.blueLineView.centerX = self.allBtn?.centerX as! CGFloat
            self.allBtn?.isSelected = true
            self.productScope = 0
        }
        if btn.tag == 1001 {
            self.blueLineView.centerX = self.courseBtn?.centerX as! CGFloat
            self.courseBtn?.isSelected = true
            self.productScope = 1
        }
        if btn.tag == 1002 {
            self.blueLineView.centerX = self.classBtn?.centerX as! CGFloat
            self.classBtn?.isSelected = true
            self.productScope = 3
        }
        if btn.tag == 1003 {
            self.blueLineView.centerX = self.bookBtn?.centerX as! CGFloat
            self.bookBtn?.isSelected = true
            self.productScope = 2
        }
        if btn.tag == 1004 {
            self.blueLineView.centerX = self.liveBtn?.centerX as! CGFloat
            self.liveBtn?.isSelected = true
            self.productScope = 5
        }
        if btn.tag == 1005 {
            self.blueLineView.centerX = self.appointProductBtn?.centerX as! CGFloat
            self.appointProductBtn?.isSelected = true
            self.productScope = 6
        }
        self.loadData()
    }
}

extension DiscountProductViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(DiscountProductTableViewCell.self), for: indexPath) as! DiscountProductTableViewCell
        cell.model = self.array![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.home.courseDetailViewController()!
        vc.productID = self.array![indexPath.row].productID.toString()
        vc.productType = self.array![indexPath.row].productType
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
