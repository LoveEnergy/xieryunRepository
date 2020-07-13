//
//  RemoteListClassViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/30.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Rswift

class RemoteListClassViewController: UIViewController, UINavigationControllerDelegate {
    var model: [RemoteClassDetailModel] = [RemoteClassDetailModel]()
    let disposeBag = DisposeBag()
    var page: Int = 1
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
        self.loadData()
    }
    
    func setUpUI(){
        self.title = "远程班级"
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
    }
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RemoteListClassTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(RemoteListClassTableViewCell.self))
        tableView.rowHeight = 110/WIDTH_6_SCALE
        tableView.addRefreshHeader {
            self.loadData()
        }
        tableView.addRefreshFooter {
            self.loadMore()
        }
        return tableView
    }()
    
    func loadData() {
        self.page = 1
        RequestHelper.shared.remoteClassData(pageNo: 1, pageSize: 10)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            self.model = list.data!.rows
            self.tableView.reloadData()
            self.tableView.endRefresh()
        })
        .disposed(by: disposeBag)
    }
    
    func loadMore(){
        self.page += 1
        RequestHelper.shared.remoteClassData(pageNo: self.page, pageSize: 10)
        .asObservable()
        .subscribe(onNext: {[weak self] (list) in
            guard let `self` = self else { return }
            self.model += list.data!.rows
            self.tableView.reloadData()
            self.tableView.endRefresh()
        })
        .disposed(by: disposeBag)
    }
}

extension RemoteListClassViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(RemoteListClassTableViewCell.self), for: indexPath) as! RemoteListClassTableViewCell
        cell.model = self.model[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = R.storyboard.home.courseDetailViewController()!
        vc.productID = self.model[indexPath.row].productID.toString()
        vc.productType = 3
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
