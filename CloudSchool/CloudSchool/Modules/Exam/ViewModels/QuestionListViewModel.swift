//
//  QuestionListViewModel.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2019/2/24.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class QuestionListViewModel: NSObject, UITableViewDelegate, UITableViewDataSource {
    public var autoSubmitBlock:(()->())?//自动交卷
    var judgeNullAnswer: Bool = true
    var examNewID: Int = 0
    var paperID: String
    var maxSeconds = 60
    let disposeBag: DisposeBag = DisposeBag()
    
    var model: QuestionListInfoModel?
    var examModel: ExamBaseInfoModel?
    
    var currentQuestion: QuestionModel?
    var isAllViewRight: Int = 1
    var examRecordID: String = ""
    var examID: String {
        return self.examModel?.examID.string ?? ""
    }
    
    var yourAnswer: String? {
        return currentQuestion?.answer
    }
    
    var isRight: String {
        guard let question = currentQuestion else {
            return "错误"
        }
        return question.isRight ? "正确": "错误"
        
    }
    
    var currentSection: Int = 0
    var currentRow: Int = 0
    //是否可以作答
    var canAnswer: Bool = false
    
    var reloadSignal: PublishSubject<Void> = PublishSubject()
    
    var countDownString: Variable<String> = Variable("")
    var nextEnabled: Variable<Bool> = Variable(true)
    var previousEnabled: Variable<Bool> = Variable(false)
    var simplyAnswerIndex: Int = 0//简答题索引
    var simplyAnswerString: String = ""//简答题答案
    init(paperID: String, examModel: ExamBaseInfoModel) {
        self.paperID = paperID
        self.examNewID = examModel.examID
        super.init()
        self.examModel = examModel
        self.canAnswer = true
        self.loadData()
    }
    
    init(paperID: String, examID: String){
        self.paperID = paperID
        self.examNewID = Int(examID)!
        super.init()
        self.loadData()
        self.canAnswer = false
    }
    
    init(paperID: String, paperNo: String, userPaperID: String) {
        self.paperID = paperID
        super.init()
        self.canAnswer = false
        self.loadResult(paperNo: paperNo, userPaperID: userPaperID)
    }
    
    init(paperID: String, paperNo: String, userPaperID: String, examRecordID: String) {
        self.paperID = paperID
        super.init()
        self.canAnswer = false
        self.loadResult(paperNo: paperNo, userPaperID: userPaperID, examRecordID: examRecordID)
    }
        
    func loadData() {
        UserHelper.shared.getExamQuestion(pagerID: paperID, examID:"\(self.examNewID)")
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                if list.code == 200{
                    self.model = list.data
                    self.currentQuestion = self.model?.questionTypeList.first?.questionList.first
                    self.maxSeconds = self.maxSeconds * self.model!.limitTime
                    self.startTimer()
                    self.reloadSignal.onNext(())
                }else{
                    HUD.showError(error: list.message!)
                }
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
            .disposed(by: disposeBag)
    }
    
    func loadResult(paperNo: String, userPaperID: String) {
        UserHelper.shared.getExamResult(examID: self.examID, paperID: self.paperID, paperNo: paperNo, userPaperID: userPaperID)
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.model = list.data
                self.currentQuestion = self.model?.questionTypeList.first?.questionList.first
                self.reloadSignal.onNext(())
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func loadResult(paperNo: String, userPaperID: String, examRecordID: String) {
        UserHelper.shared.getExamResult(examID: examRecordID, paperID: self.paperID, paperNo: paperNo, userPaperID: userPaperID)
        .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                guard let `self` = self else { return }
                self.model = list.data
                self.currentQuestion = self.model?.questionTypeList.first?.questionList.first
                self.reloadSignal.onNext(())
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func next() {
        guard let model = self.model else {
            return
        }
        if self.currentRow < model.questionTypeList[self.currentSection].questionList.count - 1 {
            if model.questionTypeList[self.currentSection].basicType == 3 {
                guard let model = self.model else {
                    return
                }
                let question = model.questionTypeList[self.currentSection].questionList[self.currentRow]
                let type = model.questionTypeList[self.currentSection]
                let paperID = model.paperID
                let paperNo = model.paperNo
                let questionID = question.questionID
                let questionType = type.basicType
                let chooseModel = question.chooseAnswerModel
                chooseModel.paperID = paperID
                chooseModel.paperNo = paperNo
                chooseModel.questionID = questionID
                chooseModel.type = questionType
                chooseModel.content = [self.simplyAnswerString]
                reloadSignal.onNext(())
            }
            self.currentRow += 1
            self.updateCurrentQuestion()
        } else if self.currentSection < model.questionTypeList.count - 1 {
            if model.questionTypeList[self.currentSection].basicType == 3 {
                guard let model = self.model else {
                    return
                }
                let question = model.questionTypeList[self.currentSection].questionList[self.currentRow]
                let type = model.questionTypeList[self.currentSection]
                let paperID = model.paperID
                let paperNo = model.paperNo
                let questionID = question.questionID
                let questionType = type.basicType
                let chooseModel = question.chooseAnswerModel
                chooseModel.paperID = paperID
                chooseModel.paperNo = paperNo
                chooseModel.questionID = questionID
                chooseModel.type = questionType
                chooseModel.content = [self.simplyAnswerString]
                reloadSignal.onNext(())
            }
            self.currentSection += 1
            self.currentRow = 0
            self.updateCurrentQuestion()
        } else {
            HUD.showError(error: "没有了")
        }
        self.updateEnableValue(model: model)
    }
    
    func previous() {
        guard let model = self.model else {
            return
        }
        
        if self.currentRow > 0  {
            self.currentRow -= 1
            self.updateCurrentQuestion()
        } else if self.currentSection > 0 {
            
            self.currentSection -= 1
            self.currentRow = model.questionTypeList[self.currentSection].questionList.count - 1
            self.updateCurrentQuestion()
        } else {
            HUD.showError(error: "没有了")
        }
        self.updateEnableValue(model: model)
    }
    
    func submit() {
        guard let model = self.model else {
            return
        }
        HUD.loading(text: "")
        var array: [QuestionModel] = []
        for type in model.questionTypeList {
            array.append(contentsOf: type.questionList)
        }
        let chooseArray = array.map { (question) -> ChooseAnswerModel in
            return question.chooseAnswerModel
            }.filter { (choose) -> Bool in
                if choose.content.count == 0{
                    print("选空")
                    return false
                }else{
                    return choose.content.count > 0
                }
            }.map { (value) -> [String:String] in
                return ["paperID":value.paperID.string,
                        "questionID":value.questionID.string,
                        "content":value.content.joined(separator: ","),
                        "type":value.type.string,
                        "paperNo":value.paperNo.string,
                        "examID":self.examID]
        }
        if self.judgeNullAnswer == true {
            //判断是否有漏题
            for (index,value) in array.enumerated() {
                if value.chooseAnswerModel.content.count == 0 {
                    self.currentRow = index
                    for (itemIndex,itemValue) in self.model!.questionTypeList.enumerated() {
                        for typeQuestion in itemValue.questionList{
                            if typeQuestion.questionID == value.questionID {
                                self.currentSection = itemIndex
                                if self.currentRow <= model.questionTypeList[self.currentSection].questionList.count - 1 {
                                    self.updateCurrentQuestion()
                                }else{
                                    self.currentRow = self.currentRow - model.questionTypeList[self.currentSection - 1].questionList.count
                                    self.updateCurrentQuestion()
                                }
                            }
                        }
                    }
                    HUD.hideLoading()
                    HUD.showText(text: "您还有未完成的题目")
                    return
                }
            }
        }
        
        UserHelper.shared.submitExamAnswer(answers: chooseArray)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                HUD.showText(text: "提交成功")
            }, onError: { (error) in
                HUD.showError(error: error.localizedDescription)
            })
        .disposed(by: disposeBag)
    }
    
    func updateEnableValue(model: QuestionListInfoModel) {
        if self.currentRow == 0 && self.currentSection == 0 {
            previousEnabled.value = false
        } else {
            previousEnabled.value = true
        }
        if self.currentRow == model.questionTypeList[self.currentSection].questionList.count - 1 && self.currentSection == model.questionTypeList.count - 1 {
            nextEnabled.value = false
        } else {
            nextEnabled.value = true
        }
    }
    
    func updateCurrentQuestion() {
        self.currentQuestion = self.model?.questionTypeList[self.currentSection].questionList[self.currentRow]
        self.reloadSignal.onNext(())
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let _ = self.currentQuestion else {
            return 0
        }
        if section == 0 {
            return 1
        }
        if self.currentQuestion?.optionList.count == 0 {
            return 1
        }else{
            return self.currentQuestion?.optionList.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.questionTableViewCell, for: indexPath)!
            cell.nameLabel.text = self.currentQuestion?.questionTitle
            cell.scoreLabel.text = (self.currentQuestion?.score.string ?? "") + "'"
            cell.typeButton.setTitle(self.model?.questionTypeList[self.currentSection].questionTypeName ?? "", for: .normal)
            return cell
        }
        if model!.questionTypeList[self.currentSection].basicType == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.simplyAnswerTableViewCell, for: indexPath)!
            cell.contentTextBlock = {(answerString) in
                self.simplyAnswerString = answerString
//                self.simplyAnswerIndex = indexPath.row
                
            }
            if self.currentQuestion?.chooseAnswerModel.content.count == 0 {
                cell.contentTextView.text = nil
                cell.contentTextView.placeholder = "请回答:"
            }else{
                cell.contentTextView.text = self.currentQuestion?.chooseAnswerModel.content[0]
            }
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.answerTableViewCell, for: indexPath)!
            if let model = self.currentQuestion?.optionList[indexPath.row] {
                cell.configure(model: model)
                if let question = self.currentQuestion {
                    cell.chooseButton.isSelected = question.chooseAnswerModel.content.contains(model.serialNumber)
                } else {
                    cell.chooseButton.isSelected = false
                }
            }
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(UITableViewCell.self), for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard canAnswer else {
            return
        }
        if indexPath.section == 0 {
            return
        }
        //当前题分类
        guard let model = self.model, let question = self.currentQuestion else {
            return
        }
        let type = model.questionTypeList[self.currentSection]
        let paperID = model.paperID
        let paperNo = model.paperNo
        let questionID = question.questionID
        let questionType = type.basicType
        let chooseModel = question.chooseAnswerModel
        chooseModel.paperID = paperID
        chooseModel.paperNo = paperNo
        chooseModel.questionID = questionID
        chooseModel.type = questionType
//        chooseMode
        let chooseContent = question.optionList[indexPath.row].serialNumber
        if questionType == 1 {
            chooseModel.content = [chooseContent]
        } else if questionType == 2 {
            if chooseModel.content.contains(chooseContent) {
                chooseModel.content.removeAll(chooseContent)
            } else {
                chooseModel.content.append(chooseContent)
            }
        }else if questionType == 4{
            chooseModel.content = [chooseContent]
        }
        
        print(question.chooseAnswerModel.content)
        reloadSignal.onNext(())
    }
    
    func startTimer() {
        let object = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        object.map { (value) -> String in
            if self.maxSeconds == value{
                self.judgeNullAnswer = false
                self.autoSubmitBlock?()
            }
            return (max(self.maxSeconds - value, 0)).timeHourString()
            }
            .subscribe(onNext: {[weak self] value in
                guard let `self` = self else { return }
                self.countDownString.value = value
            })
            .disposed(by: disposeBag)
        
    }

}
