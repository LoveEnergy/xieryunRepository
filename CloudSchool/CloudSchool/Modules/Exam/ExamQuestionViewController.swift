//
//  ExamQuestionViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ExamQuestionViewController: UIViewController {
    
    @IBOutlet weak var answerTitleLabLeft: NSLayoutConstraint!
    @IBOutlet weak var answerTitleCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var timeTitleLabel: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var questionTitleLab: UILabel!//"你的答案"
    @IBOutlet weak var answerLabel: UILabel!//你的答案内容
    let maxSeconds = 100
    var pagerID: String?
    let disposeBag: DisposeBag = DisposeBag()
    var viewModel: QuestionListViewModel?
    var isAllowViewRight: Int = 0//是否显示答案
    
    @IBOutlet weak var answerContentLab: UILabel!//答案内容
    @IBOutlet weak var answerTitleLab: UILabel!//答案头
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(R.nib.questionTableViewCell)
        self.tableView.register(R.nib.answerTableViewCell)
//        self.tableView.register(SimplyAnswerTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(SimplyAnswerTableViewCell.self))
        self.tableView.register(R.nib.simplyAnswerTableViewCell)

        self.tableView.separatorStyle = .none
        self.nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        self.previousButton.addTarget(self, action: #selector(previousButtonClick), for: .touchUpInside)
        
        self.nextButton.setBackgroundColor(UIColor.disabledBackgroundColor, forState: .disabled)
        self.previousButton.setBackgroundColor(UIColor.disabledBackgroundColor, forState: .disabled)
    }
    
    func getWithClassTestPage(paperID: String, examID: String, viewModel: QuestionListViewModel){
        self.view.backgroundColor = UIColor.backgroundColor
        self.viewModel = viewModel
        
//        self.viewModel = QuestionListViewModel.init(paperID: paperID, examID: examID)
//        self.viewModel!.loadData()
    }
    
    func bindViewModel(viewModel: QuestionListViewModel) {
        self.view.backgroundColor = UIColor.backgroundColor
        self.viewModel = viewModel
        viewModel.isAllViewRight = self.isAllowViewRight
        
        self.tableView.delegate = self.viewModel!
        self.tableView.dataSource = self.viewModel!
        
        self.viewModel!.reloadSignal.asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                guard let _ = self.viewModel?.currentQuestion else {
                    HUD.showError(error: "没有试题")
                    self.navigationController?.popViewController()
                    return
                }
                self.tableView.reloadData()
                self.answerLabel.text = self.viewModel!.yourAnswer
                self.resultLabel.text = self.viewModel!.isRight
                
            })
        .disposed(by: disposeBag)
        
        self.timeTitleLabel.text = viewModel.canAnswer ? "倒计时" : ""
        self.viewModel!.countDownString
        .asObservable()
        .bind(to: self.timeLabel.rx.text)
        .disposed(by: disposeBag)
        
        self.viewModel!.nextEnabled
        .asObservable()
        .bind(to: self.nextButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        self.viewModel!.previousEnabled
        .asObservable()
        .bind(to: self.previousButton.rx.isEnabled)
        .disposed(by: disposeBag)
        
        footerView.isHidden = viewModel.canAnswer
        submitButton.isHidden = !viewModel.canAnswer
        if self.isAllowViewRight == 0 {
            self.answerContentLab.isHidden = true
            self.answerTitleLab.isHidden =  true
        }
        viewModel.autoSubmitBlock = {
            self.viewModel?.submit()
        }
    }
    
    @objc func nextButtonClick() {
        self.viewModel?.next()
    }
    
    @objc func previousButtonClick() {
        self.viewModel?.previous()
    }
    
    
    @IBAction func submitClick(_ sender: Any) {
        self.viewModel?.submit()
    }
    

}
