//
//  ManageProfitViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/4/9.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ManageProfitViewController: UIViewController {

    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var totalValueLabel: UILabel!
    let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var todayTitleLabel: UILabel!
    @IBOutlet weak var todayValueLabel: UILabel!
    
    @IBOutlet weak var yesterdayValueLabel: UILabel!
    
    @IBOutlet weak var yesterdayTitleLabel: UILabel!
    
    var data: [MonthProfitModel] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
        // Do any additional setup after loading the view.
    }
    
    func configureUI() {
        self.title = "管理收益"
        self.totalTitleLabel.text = "累计收益 (元)"
        self.todayTitleLabel.text = "今日收益 (元)"
        self.yesterdayTitleLabel.text = "昨日收益 (元)"
        
        self.tableView.register(R.nib.profitTableViewCell)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
    }
    
    func loadData() {
        UserHelper.shared.getMonthProfitList(pageNo: 1, pageSize: 100)
        .asObservable()
            .subscribe(onNext: {[weak self] (result) in
                guard let `self` = self else { return }
                self.data = result.data
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }

}

extension ManageProfitViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.profitTableViewCell, for: indexPath)!
        cell.configure(model: data[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
}

import DZNEmptyDataSet
extension ManageProfitViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}
