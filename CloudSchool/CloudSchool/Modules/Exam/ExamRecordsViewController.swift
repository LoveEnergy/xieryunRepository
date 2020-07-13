//
//  ExamRecordsViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/3/8.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExamRecordsViewController: UIViewController {
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var checkPaperView: UIView!
    @IBOutlet weak var checkScoreView: UIView!
    
    var examPaperViewShow: Int?
    var examScoreViewShow: Int?
    
    var viewModel: ExamRecordViewModel?
    var currentIndex: Int = 0
    let disposeBag: DisposeBag = DisposeBag()
    var examScoreArray : [ExamResultInfoModel] = [ExamResultInfoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        baseConfigure()
        if self.examPaperViewShow == 0{
            self.checkScoreView.frame = self.checkPaperView.frame
            self.checkPaperView.isHidden = true
        }
        
    }
    
//    lazy var examListView : ExamListView = {
//        var examListView = ExamListView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
//        examListView.cellArray = self.examScoreArray
//        examListView.dismissExamListView = {
//            UIView.animate(withDuration: 0.15, animations: {
//                self.examListView.alpha = 0
//            }) { (Bool) in
//                self.examListView.removeFromSuperview()
//            }
//        }
//        return examListView
//    }()
    
    func baseConfigure() {
        self.title = "考试记录"
        collectionView.delegate = self
        collectionView.dataSource = self
        layout.itemSize = CGSize(width: SCREEN_WIDTH, height: 215)
        self.view.addSubview(collectionView)
        collectionView.register(R.nib.examRecordCollectionViewCell)
        self.collectionView.isHidden = true
        self.checkPaperView.isHidden = true
        self.checkScoreView.isHidden = true
        self.view.addSubview(self.tableView)
    }
    
    func bind(viewModel: ExamRecordViewModel) {
        self.viewModel = viewModel
        self.view.backgroundColor = UIColor.backgroundColor
        viewModel.data
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list.count > 0{
                    self.examScoreArray = list
                    self.tableView.reloadData()
//                    self.examListView.tableView.reloadData()
//                    self.examListView.showView()
                }
                self.collectionView.reloadData()
            })
        .disposed(by: disposeBag)
    }

    @IBAction func examScoreList(_ sender: Any) {
//        examListView.showView()
    }
    @IBAction func showDetail(_ sender: Any) {
        guard let viewModel = self.viewModel else {
            return
        }
        guard currentIndex < viewModel.data.value.count else {
            return
        }
        let model = viewModel.data.value[currentIndex]
        let vm = QuestionListViewModel(paperID: model.paperID.string, paperNo: model.paperNo.string, userPaperID: model.userPaperID.string)
        let vc = R.storyboard.exam.examQuestionViewController()!
        vc.isAllowViewRight = self.examScoreViewShow!
        vc.bindViewModel(viewModel: vm)
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT)))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExamRecordsTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ExamRecordsTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.rowHeight = 76/375 * SCREEN_WIDTH
        return tableView
    }()
}

extension ExamRecordsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.examScoreArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(ExamRecordsTableViewCell.self), for: indexPath) as! ExamRecordsTableViewCell
        cell.model = self.examScoreArray[indexPath.row]
        cell.titleLab.text = "第\(indexPath.row + 1)次"
        cell.checkRecordBlock = {
            guard let viewModel = self.viewModel else {
                return
            }
            guard self.currentIndex < viewModel.data.value.count else {
                return
            }
            let model = viewModel.data.value[indexPath.row]
            let vm = QuestionListViewModel(paperID: model.paperID.string, paperNo: model.paperNo.string, userPaperID: model.userPaperID.string, examRecordID: model.examID.string)
            let vc = R.storyboard.exam.examQuestionViewController()!
            vc.isAllowViewRight = self.examScoreViewShow!
            vc.bindViewModel(viewModel: vm)
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel?.data.value.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.nib.examRecordCollectionViewCell, for: indexPath)!
        if let array = self.viewModel?.data.value {
            let model = array[indexPath.row]
            cell.configure(model: model)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.width)
        self.currentIndex = page
    }
}
