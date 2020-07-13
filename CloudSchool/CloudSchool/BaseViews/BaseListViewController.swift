//
//  BaseListViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/14.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper
import Rswift

class BaseListViewController<T: BaseListViewModel>: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200.0
        return tableView
    }()
    
    let disposeBag = DisposeBag()
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        tableView.register(UINib(nibName: viewModel.cellType.className, bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        viewModel.data.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: viewModel.cellIdentifier, cellType: viewModel.cellType)){ _, model, cell in
                cell.configure(model: model)
        }.disposed(by: disposeBag)
        tableView.delegate = self
        
        tableView.addRefreshHeader {
            self.viewModel.loadData()
        }
        
        tableView.addRefreshFooter {
            self.viewModel.loadMore()
        }
        
        viewModel.reloadBlock = {
            self.tableView.endRefresh()
        }
        
    }
    
    func configureUI() {
        title = viewModel.title
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.didClick(indexPath: indexPath)
    }
}


//class BaseListViewModel<T:Mappable>: NSObject {
//
//    var data: Variable<[T]> = Variable([])
//}


protocol BaseListViewModel {
    
    associatedtype Cell: UITableViewCell&CellMappable
    var data: Variable<[Cell.Model]> { get set }
    var cellType: Cell.Type { get set }
    var cellIdentifier: String { get }
    var cellHeight: CGFloat { get }
    var title: String { get }
    var page: Int { get set }
    var pageSize: Int { get set }
    
    var reloadBlock:(()-> Void)? { get set }
    
    func loadMore()
    func loadData()
    
    func didClick(indexPath: IndexPath)
}

extension BaseListModel {
    var cellHeight: CGFloat {
        return 100
    }
}

protocol CellMappable {
    associatedtype Model
    func configure(model: Model)
}
//
//class BaseListTableViewCell: UITableViewCell, TableViewCellMappable {
//    func configure(model: Mappable) {
//
//    }
//}


