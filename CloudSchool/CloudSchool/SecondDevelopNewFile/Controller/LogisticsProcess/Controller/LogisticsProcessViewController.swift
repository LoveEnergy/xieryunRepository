//
//  LogisticsProcessViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/2/24.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LogisticsProcessViewController: UIViewController {
    var productType: Int = 0
    var status: Int = 0
    var goodsStatus: Int = 0
    var courierNumber: String = ""//快递单号
    var carrierID: String = ""//承运商ID
    var productImgURL: String = ""//商品图片
    var carrierPhone: String = ""//官方电话
    var carrierServer: String = ""//快递商
    var productAddressModel: AddressModel?
    let disposeBag = DisposeBag()
    var cellArray: [LogisticsDetailModel] = [LogisticsDetailModel]()
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.tableHeaderView = self.headerView
        tableView.rowHeight = 50/WIDTH_6_SCALE
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(LogisticsProcessTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(LogisticsProcessTableViewCell.self))
        tableView.separatorStyle = .none
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 70/WIDTH_6_SCALE + 10/WIDTH_6_SCALE + 43/WIDTH_6_SCALE))
        headerView.backgroundColor = UIColor.colorWithHex(hex: "F0F0F0")
        let topWhiteBGView = UIView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 70/WIDTH_6_SCALE))
        topWhiteBGView.backgroundColor = .white
        headerView.addSubview(topWhiteBGView)
        topWhiteBGView.addSubview(self.iconImg)
        topWhiteBGView.addSubview(self.expressTitleLab)
        topWhiteBGView.addSubview(self.postIDLab)
        self.postIDLab.centerY = self.iconImg.centerY
        topWhiteBGView.addSubview(self.expressPhoneLab)
        let bottomWhiteView = UIView.init(frame: CGRect(x: 0, y: topWhiteBGView.bottom + 10/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 43/WIDTH_6_SCALE + 20/WIDTH_6_SCALE))
        bottomWhiteView.backgroundColor = .white
        headerView.addSubview(bottomWhiteView)
        let getTitleLab = UILabel.init(frame: CGRect(x: 58/WIDTH_6_SCALE, y: 0, width: 24/WIDTH_6_SCALE, height: 24/WIDTH_6_SCALE))
        getTitleLab.centerY = bottomWhiteView.height/2
        getTitleLab.text = "收"
        getTitleLab.font = DEF_FontSize_12
        getTitleLab.textColor = .white
        getTitleLab.textAlignment = .center
        getTitleLab.layer.cornerRadius = getTitleLab.height/2
        getTitleLab.layer.masksToBounds = true
        getTitleLab.backgroundColor = UIColor.colorWithHex(hex: "CDCDCD")
        bottomWhiteView.addSubview(getTitleLab)
        bottomWhiteView.addSubview(self.postAddressLab)
        self.postAddressLab.frame = CGRect(x: getTitleLab.right + 7/WIDTH_6_SCALE, y: 0, width: SCREEN_WIDTH - getTitleLab.right - 14/WIDTH_6_SCALE, height: bottomWhiteView.height - 20/WIDTH_6_SCALE)
        self.postAddressLab.centerY = bottomWhiteView.height/2
        headerView.frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: bottomWhiteView.bottom)
        return headerView
    }()
    lazy var iconImg: UIImageView = {
        var iconImg = UIImageView.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: 50/WIDTH_6_SCALE, height: 50/WIDTH_6_SCALE))
        iconImg.backgroundColor = .lightGray
        iconImg.loadImage(string: self.productImgURL)
        return iconImg
    }()
    lazy var expressTitleLab : UILabel = {
        var expressTitleLab = UILabel.init(frame: CGRect(x: 8.5/WIDTH_6_SCALE + self.iconImg.right, y: self.iconImg.top, width: SCREEN_WIDTH - self.iconImg.right - 17/WIDTH_6_SCALE, height: 15/WIDTH_6_SCALE))
        expressTitleLab.font = DEF_FontSize_13
        expressTitleLab.backgroundColor = .clear
        expressTitleLab.textColor = .black
        expressTitleLab.textAlignment = .left
        expressTitleLab.text = self.carrierServer
        return expressTitleLab
    }()
    lazy var postIDLab : UILabel = {
        var postIDLab = UILabel.init(frame: CGRect(x: self.expressTitleLab.left, y: 0, width: self.expressTitleLab.width, height: self.expressTitleLab.height))
        postIDLab.font = DEF_FontSize_11
        postIDLab.backgroundColor = .clear
        postIDLab.textColor = .black
        postIDLab.textAlignment = .left
        postIDLab.text = "运单号:\(self.courierNumber)"
        return postIDLab
    }()
    lazy var expressPhoneLab : UILabel = {
        var expressPhoneLab = UILabel.init(frame: CGRect(x: self.expressTitleLab.left, y: self.postIDLab.top - self.expressTitleLab.bottom + self.postIDLab.bottom, width: self.expressTitleLab.width, height: self.expressTitleLab.height))
        expressPhoneLab.font = DEF_FontSize_10
        expressPhoneLab.backgroundColor = .clear
        expressPhoneLab.textColor = .black
        expressPhoneLab.textAlignment = .left
        expressPhoneLab.text = "官方电话:\(carrierPhone)"
        return expressPhoneLab
    }()
    lazy var postAddressLab : UILabel = {
        var postAddressLab = UILabel.init()
        postAddressLab.font = DEF_FontSize_10
        postAddressLab.backgroundColor = .clear
        postAddressLab.textColor = .black
        postAddressLab.textAlignment = .left
        postAddressLab.text = "【收货地址】\(self.productAddressModel?.address)"
        postAddressLab.lineBreakMode = .byWordWrapping
        postAddressLab.numberOfLines = 0
        return postAddressLab
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        footerView.backgroundColor = .white
        return footerView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.loadData()
    }
    
    func loadData(){
        UserHelper.shared.getLogisticsData(status: self.status, productType: self.productType, goodsStatus: self.goodsStatus, carrierID: Int(self.carrierID)!, courierNumber: self.courierNumber).asObservable().subscribe(onNext: {[weak self] (result) in
            guard let `self` = self else { return }
            let baseInfoModel: BaseInfoModel = result
            if baseInfoModel.code == 200{
                let dataModel: LogisticsModel = baseInfoModel.data!
                self.cellArray.removeAll()
                self.cellArray = dataModel.Traces
                self.tableView.reloadData()
            }else{
                HUD.showText(text: baseInfoModel.message!)
            }
        }, onError: { (error) in
            HUD.showText(text: error.localizedDescription)
        }).disposed(by: self.disposeBag)
    }
}

extension LogisticsProcessViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.cellArray.count
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(LogisticsProcessTableViewCell.self), for: indexPath) as! LogisticsProcessTableViewCell
//        cell.model = self.cellArray[indexPath.row]
        return cell
    }
    
    
}
