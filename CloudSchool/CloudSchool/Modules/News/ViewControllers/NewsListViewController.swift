//
//  NewsListViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/30.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewsListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: NewsListViewModel = NewsListViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModel.data.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.newsTableViewCell.identifier, cellType: NewsTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(PageModel.self).subscribe(onNext: { (type) in
            let vc = R.storyboard.news.newsDetailViewController()!
            vc.title = type.pageName.nsString.substring(to: min(14, type.pageName.count))
            vc.pageID = type.informationID.string
            CurrentControllerHelper.pushViewController(viewController: vc)
        }).disposed(by: disposeBag)
        
        tableView.addRefreshHeader {[weak self] in
            guard let `self` = self else { return }
            self.viewModel.loadData()
        }
        
        self.viewModel.data
        .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.tableView.endRefresh()
            })
        .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        title = viewModel.title
        tableView.register(R.nib.newsTableViewCell)
    }

}
