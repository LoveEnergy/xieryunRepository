//
//  ExamViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/23.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import QMUIKit

class ExamViewController: QMUICommonViewController {

    @IBOutlet weak var segment: BaseSegmentControl!
    @IBOutlet weak var examingTableView: UITableView!
    @IBOutlet weak var scrollView: NestedListView!
    @IBOutlet weak var examedTableView: UITableView!
    var isAllowShowAnswer: Int?//是否允许查看答案
    var withClassTestModel: [ExamBaseInfoModel]?
    var currentIndex: Int = 0 {
        didSet {
            self.segment.selectedSegmentIndex = currentIndex
            self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(currentIndex) * self.scrollView.width, y: 0, width: self.scrollView.width, height: self.scrollView.height), animated: true)
        }
    }
    
    var viewModel: ExamingViewModel = ExamingViewModel()//班级考试
    var examedViewModel: ExamedViewModel = ExamedViewModel()//课程考试
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        viewModel.data.asObservable()
            .bind(to: examingTableView.rx.items(cellIdentifier: R.nib.examTableViewCell.identifier, cellType: ExamTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
                if model.haveTest == 0{
                    cell.withClassText.isHidden = true
                }else{
                    //有
                    cell.withClassText.isHidden = false
                }
                cell.withClassTestClickBlock = {(data: [ExamBaseInfoModel]) in
                    self.withClassTestModel = data
                    self.withClassExamTestView.showView(data: data)
                }
            }.disposed(by: disposeBag)
        
        examingTableView.rx
            .modelSelected(ExamBaseInfoModel.self)
            .subscribe(onNext: { (model) in
                
            }).disposed(by: disposeBag)
        
        examedViewModel.data.asObservable()
            .bind(to: examedTableView.rx.items(cellIdentifier: R.nib.examTableViewCell.identifier, cellType: ExamTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
                cell.withClassText.isHidden = true
                cell.startButton.setTitle("随堂测试", for: .normal)
            }.disposed(by: disposeBag)
        
        
//        examedTableView.rx.modelSelected(DownloadInfoModel.self).subscribe(onNext: { (model) in
//            if let path = model.path {
//                PlayerHelper.playFile(path: path)
//            }
//            
//        }).disposed(by: disposeBag)
        
        addResponse()
        
        segment.rx.selectedSegmentIndex.asObservable()
            .map { (value) -> Bool in
                return value == 1
        }.bind(to: examingTableView.rx.isHidden)
        .disposed(by: disposeBag)

        segment.rx.selectedSegmentIndex.asObservable()
            .map { (value) -> Bool in
                return value == 0
            }.bind(to: examedTableView.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    func configureUI() {
        title = "我的考试"
        examingTableView.register(R.nib.examTableViewCell)
        examingTableView.tableFooterView = UIView()
        
        examedTableView.register(R.nib.examTableViewCell)
        examedTableView.tableFooterView = UIView()
        scrollView.nestDelegate = self
        scrollView.totalPage = 2
        scrollView.scrollToPage(0)
        scrollView.changedPage = { index in
            self.currentIndex = index
        }
        examedTableView.emptyDataSetSource = self
        examingTableView.emptyDataSetSource = self
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
    
    lazy var withClassExamTestView : WithClassExamTestView = {
        var withClassExamTestView = WithClassExamTestView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        withClassExamTestView.startTestBlock = {(paperID: String, examID: String, indexPathRow: Int) in
            let vc = R.storyboard.exam.examQuestionViewController()!
            vc.pagerID = paperID                
            let vm = QuestionListViewModel(paperID: paperID, examModel: self.withClassTestModel![indexPathRow])
            vc.bindViewModel(viewModel: vm)
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        withClassExamTestView.checkTestBlock = {(paperID: String, examID: String, indexPathRow: Int, isAllowShowAnswer: Int) in
            let vc = R.storyboard.exam.examRecordsViewController()!
            let vm = ExamRecordViewModel(examID: examID)
            vc.bind(viewModel: vm)
            vc.examScoreViewShow = isAllowShowAnswer
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        return withClassExamTestView
    }()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.withClassExamTestView.dismissView()
    }

}

extension ExamViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        switch page {
        case 0:
            return examingTableView
        default:
            return examedTableView
        }
    }
    
    
}

import DZNEmptyDataSet
extension ExamViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}
