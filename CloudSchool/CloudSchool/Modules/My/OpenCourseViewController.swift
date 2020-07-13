//
//  OpenCourseViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/12.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OpenCourseViewController: UIViewController {

    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstant: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var codeInputView: BaseInputView!
    @IBOutlet weak var cardNumberInputView: BaseInputView!
    
    @IBOutlet weak var phoneInputView: BaseInputView!
    
    @IBOutlet weak var cdKeyInputView: BaseInputView!
    @IBOutlet weak var getCardTableView: UITableView!
    @IBOutlet weak var submitButton: BaseButton!
    @IBOutlet weak var getButton: BaseButton!
    let disposeBag: DisposeBag = DisposeBag()
    @IBOutlet weak var segment: BaseSegmentControl!
    
    @IBOutlet weak var scrollView: NestedListView!
    
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    
    var currentIndex: Int = 0 {
        didSet {
            self.segment.selectedSegmentIndex = currentIndex
            self.scrollView.scrollRectToVisible(CGRect(x: CGFloat(currentIndex) * self.scrollView.width, y: 0, width: self.scrollView.width, height: self.scrollView.height), animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        topConstant.constant = 0
        configureUI()
        bind()
        segment.rx.controlEvent(UIControl.Event.valueChanged)
            .map { () -> Int in
                return self.segment.selectedSegmentIndex
            }.subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.currentIndex = value
            })
            .disposed(by: disposeBag)
        
    }
    
    
    
    func configureUI() {
        
        view.backgroundColor = UIColor.backgroundColor
        self.cardNumberInputView.textField.backgroundColor = UIColor(hex: "F8F8F8")
        self.cardNumberInputView.textField.cornerRadius = 5
        self.cardNumberInputView.textField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.cardNumberInputView.textField.textAlignment = .center
        
        self.codeInputView.textField.backgroundColor = UIColor(hex: "F8F8F8")
        self.codeInputView.textField.cornerRadius = 5
        self.codeInputView.textField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.codeInputView.textField.textAlignment = .center
        
        self.phoneInputView.textField.backgroundColor = UIColor(hex: "F8F8F8")
        self.phoneInputView.textField.cornerRadius = 5
        self.phoneInputView.textField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.phoneInputView.textField.textAlignment = .center
        
        self.cdKeyInputView.textField.backgroundColor = UIColor(hex: "F8F8F8")
        self.cdKeyInputView.textField.cornerRadius = 5
        self.cdKeyInputView.textField.textInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.cdKeyInputView.textField.textAlignment = .center
        
        scrollView.changedPage = { index in
            self.currentIndex = index
        }
        self.tableView.register(R.nib.courseCardTableViewCell)
        self.tableView.emptyDataSetSource = self
        self.getCardTableView.register(R.nib.courseCardTableViewCell)
        self.getCardTableView.emptyDataSetSource = self
        
        scrollView.nestDelegate = self
        scrollView.totalPage = 1
        trailingConstraint.constant = -ScreenWidth
    }
    
    func bindViewModel(viewModel: OpenCardProtocol) {
        
        configureUI()
        self.title = viewModel.title
        self.topTitleLabel.text = "激活\(viewModel.title)"
        self.listTitleLabel.text = "我的\(viewModel.title)"
        self.cardNumberInputView.placeHolder = viewModel.cardPlaceHolder
        self.codeInputView.placeHolder = viewModel.cardPasswordPlaceHolder
        self.submitButton.setTitle(viewModel.submitButtonTitle, for: .normal)
        (self.submitButton.rx.tap)
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                viewModel.submit(card: self.cardNumberInputView.textField.text ?? "", password: self.codeInputView.textField.text ?? "")
            })
        .disposed(by: disposeBag)
        
        viewModel.data.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: R.nib.courseCardTableViewCell.identifier, cellType: CourseCardTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        if viewModel.title == "学习卡" {
            var tempModel = viewModel as! LearnCardViewModel
            tableView.addRefreshHeader {
                tempModel.loadData()
            }
            tableView.addRefreshFooter {
                tempModel.loadMore()
            }
            tempModel.reloadBlock = {
                self.tableView.endRefresh()
            }
        }
    }
    
    func bindSecondViewModel(sViewModel: OpenCardProtocol) {
        topConstant.constant = 50
        scrollView.totalPage = 2
        trailingConstraint.constant = 0
//        self.title = viewModel.title
//        self.topTitleLabel.text = "激活\(viewModel.title)"
//        self.listTitleLabel.text = "我的\(viewModel.title)"
        self.phoneInputView.placeHolder = sViewModel.cardPlaceHolder
        self.cdKeyInputView.placeHolder = sViewModel.cardPasswordPlaceHolder
        self.getButton.setTitle(sViewModel.submitButtonTitle, for: .normal)
        (self.getButton.rx.tap)
            .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                sViewModel.submit(card: self.phoneInputView.textField.text ?? "", password: self.cdKeyInputView.textField.text ?? "")
            })
            .disposed(by: disposeBag)
        
        sViewModel.data.asObservable()
            .bind(to: getCardTableView.rx.items(cellIdentifier: R.nib.courseCardTableViewCell.identifier, cellType: CourseCardTableViewCell.self)){ _, model, cell in
                cell.configure(model: model)
                if model.status == 0 {
                    cell.statusBtn.isHidden = false
                }else{
                    cell.statusBtn.isHidden = true
                }
                cell.activeCardBlock = {
                    let tempModel = model as! GetCourseCardModel
                    self.submit(card: tempModel.cardNoKey, password: model.code)
                }
            }.disposed(by: disposeBag)
        
    }
    
    func bind() {
        let buttonEnabled = Observable.combineLatest((cardNumberInputView.textField.rx.text).orEmpty, (codeInputView.textField.rx.text).orEmpty) { (number, code) -> Bool in
            return number.count > 0 && code.count > 0
        }.asObservable()
        
        buttonEnabled
            .bind(to: self.submitButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func submit(card: String, password: String) {
        HUD.loading(text: "")
        UserHelper.shared.useCourseCard(cardNo: card, code: password)
            .subscribe(onNext: { (model) in
                HUD.hideLoading()
                model.errorDeal(successBlock: {
                    HUD.showText(text: "开课成功")
                    CurrentControllerHelper.currentViewController().navigationController?.popViewController(animated: true)
                })
            }, onError: { (error) in
                HUD.hideLoading()
                HUD.showError(error: error.localizedDescription)
            }).disposed(by: disposeBag)
    }
}

import DZNEmptyDataSet
extension OpenCourseViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}


extension OpenCourseViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        switch page {
        case 0:
            return tableView
        default:
            return getCardTableView
        }
    }
    
    
}
