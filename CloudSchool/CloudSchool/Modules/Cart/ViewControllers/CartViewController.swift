//
//  CartViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/16.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit

class CartViewController: QMUICommonViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel: CartListViewModel = CartListViewModel()
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var chooseView: CartBottomView!
    @IBOutlet weak var editBottomView: CartEditBottomView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.refreshSignal.asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                if self.viewModel.data.isEmpty {
                    self.showDefaultEmptyView()
                } else {
                    self.hideDefaultEmptyView()
                }
                self.tableView.reloadData()
            })
        .disposed(by: disposeBag)
        self.rxBind()
    }
    
    func configureUI() {
        tableView.register(R.nib.cartTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 110.0
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.backgroundColor
        title = "购物车"
        editBottomView.isHidden = true
        chooseView.fromControllerName = "cartViewController"
    }
    
    func rxBind() {
        let editSignal = (editButton.rx.tap).map{ return !self.editButton.isSelected }
        editSignal.asObservable().bind(to: self.editButton.rx.isSelected)
        .disposed(by: disposeBag)
        
        editSignal.bind(to: self.editBottomView.rx.isHidden).disposed(by: disposeBag)
        editSignal.map { (value) -> Bool in
            return !value
        }.bind(to: self.chooseView.rx.isHidden)
        .disposed(by: disposeBag)
    }
    
    @objc func reload() {
        
    }

}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.cartTableViewCell, for: indexPath)!
        cell.fromPageName = "CartViewController"
        let model = viewModel.data[indexPath.section].productList[indexPath.row]
        cell.configure(model: model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.data[indexPath.section].productList[indexPath.row]
        let vc = R.storyboard.home.courseDetailViewController()!
        vc.productID = model.productID.toString()
        vc.productType = model.productType
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[section].productList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let model = viewModel.data[section]
        if let _ = model.getActivityString() {
            return 50
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CartActivityHeaderView(frame: .zero)
        let model = viewModel.data[section]
        view.model = model
        return view
    }
}
