//
//  OfflineListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/28.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OfflineListViewController: UIViewController {

    @IBOutlet weak var segment: BaseSegmentControl!
    @IBOutlet weak var downloadingTableView: UITableView!
    
    @IBOutlet weak var scrollView: NestedListView!
    @IBOutlet weak var downloadedTableView: UITableView!
    
    var currentIndex: Int = 0 {
        didSet {
            self.segment.selectedSegmentIndex = currentIndex
            self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(currentIndex) * self.scrollView.width, y: 0, width: self.scrollView.width, height: self.scrollView.height), animated: true)
        }
    }
    
    var viewModel: DownloadingViewModel = DownloadingViewModel()
    var downloadedViewModel: DownloadedViewModel = DownloadedViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.data.asObservable()
            .bind(to: downloadingTableView.rx.items(cellIdentifier: R.nib.downloadingTableViewCell.identifier, cellType: DownloadingTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        downloadingTableView.rx
            .modelSelected(DownloadInfoModel.self)
            .subscribe(onNext: { (model) in
                switch model.request.status {
                case .running:
                    DownloadManager.shared.suspendTask(task: model.request)
                default:
                    DownloadManager.shared.startTask(task: model.request)
                }
            
        }).disposed(by: disposeBag)
        
        downloadedViewModel.data.asObservable()
            .bind(to: downloadedTableView.rx.items(cellIdentifier: R.nib.downloadedTableViewCell.identifier, cellType: DownloadedTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        
        downloadedTableView.rx.modelSelected(DownloadInfoModel.self).subscribe(onNext: { (model) in
            if let path = model.path {
                PlayerHelper.playFile(path: path)
            }
            
        }).disposed(by: disposeBag)
        
        addResponse()
        
//        segment.rx.selectedSegmentIndex.asObservable()
//            .map { (value) -> Bool in
//            return value == 1
//        }.bind(to: downloadingTableView.rx.isHidden)
//        .disposed(by: disposeBag)
//        
//        segment.rx.selectedSegmentIndex.asObservable()
//            .map { (value) -> Bool in
//                return value == 0
//            }.bind(to: downloadedTableView.rx.isHidden)
//            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        title = "离线缓存"
    downloadingTableView.register(R.nib.downloadingTableViewCell)
        downloadingTableView.tableFooterView = UIView()
        
        downloadedTableView.register(R.nib.downloadedTableViewCell)
        downloadedTableView.tableFooterView = UIView()
        scrollView.nestDelegate = self
        scrollView.totalPage = 2
        scrollView.scrollToPage(0)
        scrollView.changedPage = { index in
            self.currentIndex = index
        }
        downloadingTableView.emptyDataSetSource = self
        downloadedTableView.emptyDataSetSource = self
    }
    
    func addResponse() {
        segment.rx.controlEvent(UIControl.Event.valueChanged)
            .map { () -> Int in
                return self.segment.selectedSegmentIndex
            }.subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.currentIndex = value
            })
            .disposed(by: disposeBag)
    }

}

extension OfflineListViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        switch page {
        case 0:
            return downloadingTableView
        default:
            return downloadedTableView
        }
    }
    
    
}

import DZNEmptyDataSet
extension OfflineListViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}
