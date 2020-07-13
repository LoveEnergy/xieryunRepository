

//
//  CouponListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/2.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CouponListViewController: UIViewController {

    @IBOutlet weak var segmentControl: BaseSegmentControl!
    
    @IBOutlet weak var scrollView: NestedListView!
    override var backgroundColor: UIColor { return .white }
    
    var data: Variable<[CourseProtocol]> = Variable([Course(), Course(), Course()])
    let disposeBag: DisposeBag = DisposeBag()
    
    var currentIndex: Int = 0 {
        didSet {
            self.segmentControl.selectedSegmentIndex = currentIndex
            self.scrollView.scrollToPage(currentIndex)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
    }
    
    lazy var instructionBtn : UIButton = {
        var instructionBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 60/WIDTH_6_SCALE, height: 20/WIDTH_6_SCALE))
        instructionBtn.setTitle("使用说明", for: .normal)
        instructionBtn.setTitleColor(UIColor.colorWithHex(hex: "828282"), for: .normal)
        instructionBtn.titleLabel?.font = DEF_FontSize_16
        instructionBtn.setBackgroundColor(.clear, forState: .normal)
        instructionBtn.addTarget(self, action: #selector(instructionBtnClick), for: .touchUpInside)
        return instructionBtn
    }()
    
    func configureUI() {
        title = "优惠券"
        scrollView.nestDelegate = self
        scrollView.totalPage = 3
        scrollView.scrollToPage(0)
        scrollView.changedPage = { index in
            self.currentIndex = index
        }
        segmentControl.setTitle("未使用", forSegmentAt: 0)
        segmentControl.setTitle("已使用", forSegmentAt: 1)
        segmentControl.setTitle("已过期", forSegmentAt: 2)
        
        segmentControl.rx.controlEvent(.valueChanged)
        .asObservable()
            .subscribe(onNext: {[weak self] () in
                guard let `self` = self else { return }
                self.currentIndex = self.segmentControl.selectedSegmentIndex
            })
        .disposed(by: disposeBag)
        
        let rightItem = UIBarButtonItem.init(customView: self.instructionBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func instructionBtnClick(){
        print("跳转")
        let vc = CouponInstructionViewController.init()
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
}

extension CouponListViewController: NestedListViewDelegate {
    func createListView(page: Int) -> UIScrollView {
        let tableView = CouponTableView.init(frame: CGRect.zero, style: .plain)
        switch page {
        case 0:
            tableView.type = .unused
        case 1:
            tableView.type = .used
        case 2:
            tableView.type = .overdue
        default:
            break
        }
        return tableView
    }
    
}
