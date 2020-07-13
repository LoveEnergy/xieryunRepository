//
//  CourseSectionListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/3.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import QMUIKit
import RxSwift
import RxCocoa

class CourseSectionListViewController: QMUICommonViewController, NestedListViewDelegate {
    
    let disposeBag: DisposeBag = DisposeBag()
    var parentID: String = ""
    var navigationIDArr : [String] = [String()]
    var currentIndex: Int = 0 {
        didSet {
            self.scrollView.scrollToPage(currentIndex)
            if self.sectionView.currentIndex != currentIndex {
                self.sectionView.currentIndex = currentIndex
            }
        }
    }
    
    @IBOutlet weak var sectionView: CourseClassifyView!
    @IBOutlet weak var scrollView: NestedListView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = self as UINavigationControllerDelegate
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSections()
        
        self.scrollView.nestDelegate = self
        sectionView.indexSignal
        .asObservable()
            .subscribe(onNext: {[weak self] (index) in
                guard let `self` = self else { return }
                self.currentIndex = index
            })
        .disposed(by: disposeBag)
        
        scrollView.changedPage = {[weak self] index in
            guard let `self` = self else { return }
            self.currentIndex = index
        }
    }
    
    func loadSections() {
        HUD.loading(text: "")
        RequestHelper.shared.getSubSeriesList(parentID: self.parentID, type: "1")
        .asObservable()
            .subscribe(onNext: {[weak self] (model) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                let tempModel = CourseSeriesModel.init(JSON: ["seriesID":-1, "seriesName":"全部"])
                self.sectionView.data = [tempModel!] + model.data
                self.scrollView.contentSize = CGSize(width: kScreenWidth * 2, height: self.scrollView.pheight)
                self.scrollView.totalPage = model.data.count
                self.scrollView.scrollToPage(0)
            })
        .disposed(by: disposeBag)
    }
    
    func createListView(page: Int) -> UIScrollView {
        var seriesIDString: String = ""
        let seriesID = self.sectionView.data[self.sectionView.currentIndex ?? 0].seriesID
        if seriesID == -1 {
            seriesIDString = ""
        }else{
            seriesIDString = seriesID.string
        }
        let vm = CourseListViewModel(parentID: self.parentID, seriesID: seriesIDString)
        let tableView = BaseListTableView(viewModel: vm)
        vm.reloadBlock = {
            tableView.reloadData()
        }
        return tableView
    }

}
