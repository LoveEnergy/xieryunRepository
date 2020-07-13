//
//  ExamTableViewCell.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/23.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ExamTableViewCell: UITableViewCell {
    var data: [ExamBaseInfoModel] = [ExamBaseInfoModel]()
    @IBOutlet weak var recordsButton: BaseButton!//考试记录
    @IBOutlet weak var startButton: BaseButton!//开始考试
    @IBOutlet weak var withClassText: UIButton!
    public var withClassTestClickBlock:(([ExamBaseInfoModel])->())?//随堂测试
    var eclassID: Int = 0
    let disposeBag: DisposeBag = DisposeBag()
    
//    func configure(model: ClassModel) {
//        thumbImageView.loadImage(string: model.thumbnailUrl)
//        nameLabel.text = model.productName
//        //        endTimeLabel.text = model.
//        endTimeLabel.text = model.closeTime;
//        progressTitleLabel.text = "已学\(model.schedule) 门课程"
//    }
//
//    typealias Model = ClassModel
    @IBOutlet weak var progressTitleLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    var model: ExamBaseInfoModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        startButton.addTarget(self, action: #selector(startExam), for: .touchUpInside)
        recordsButton.addTarget(self, action: #selector(recordClick), for: .touchUpInside)
        withClassText.addTarget(self, action: #selector(withClassTextClick), for: .touchUpInside)
    }
    
    func configure(model: ExamBaseInfoModel) {
        self.model = model
        self.nameLabel.text = model.paperTitle
        self.endTimeLabel.text = "结束时间：\(model.closeTime)"
        self.progressTitleLabel.text = "考试次数\(model.surplusCount)次"
        //status：0 考试时间未到  1 考试中   2 考试时间已过
        if model.status != 1 || model.surplusCount == 0{
            self.startButton.backgroundColor = UIColor.ColorHex("d1d1d6")
            self.startButton.setTitleColor(.black, for: .normal)
            self.startButton.borderColor = .black
            self.startButton.isUserInteractionEnabled = false
        }
        self.selectionStyle = .none
        self.eclassID = model.eclassID
        self.scoreLabel.text = "考试分数：\(model.score)"
        if model.score == -1 {
            self.scoreLabel.text = "考试分数：未考试"
        }
    }
    
    @objc func startExam() {
        let vc = R.storyboard.exam.examQuestionViewController()!
        vc.pagerID = self.model?.paperID.string
        if let paperID = self.model?.paperID.string, let model = self.model {
            let vm = QuestionListViewModel(paperID: paperID, examModel: model)
            vc.bindViewModel(viewModel: vm)
        }
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    @objc func withClassTextClick(){
        UserHelper.shared.withClassTestData(objectID: "\(self.eclassID)")
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.data = list.data
                self.withClassTestClickBlock?(self.data)
            }, onError: { (error) in
            })
        .disposed(by: disposeBag)
    }
    
    @objc func recordClick() {
        let vc = R.storyboard.exam.examRecordsViewController()!
        if let _ = self.model?.isAllowViewAnswer {
            vc.examPaperViewShow = self.model?.isAllowViewAnswer
        } else {
          vc.examPaperViewShow = 0
        }
        if let _ = self.model?.isAllowViewRight {
            vc.examScoreViewShow = self.model?.isAllowViewRight
        } else {
          vc.examScoreViewShow = 0
        }
        if let id = self.model?.examID.string {
            let vm = ExamRecordViewModel(examID: id)
            vc.bind(viewModel: vm)
        }
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
}
