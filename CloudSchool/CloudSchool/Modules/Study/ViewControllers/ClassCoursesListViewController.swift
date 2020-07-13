//
//  ClassCoursesListViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2019/1/28.
//  Copyright © 2019 CEI. All rights reserved.
//

import UIKit
import RxSwift

class ClassCoursesListViewController: UIViewController {

    @IBOutlet weak var schoolRollButton: UIButton!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: ClassCourseListViewModel = {
        return ClassCourseListViewModel(studyID: self.studyID)
    }()
    
    var studyID: String = ""
    var eclassID: String = ""
    var model: ClassModel?
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(R.nib.studyTableViewCell)
        tableView.tableFooterView = UIView()
        
        viewModel.data.asObservable()
            .subscribe(onNext: {[weak self] (array) in
                guard let `self` = self else { return }
                self.totalLabel.text = "共\(array.count)门课程"
            })
        .disposed(by: disposeBag)
        
        viewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.studyTableViewCell.identifier, cellType: StudyTableViewCell.self)) { _, model, cell in
            cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(ClassCourseModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                if model.mediaType == 1{
                    let vc = FrequencyViewController.init()
                    vc.teacherNameString = model.teacherName
                    vc.courseID = model.courseID
                    vc.teacherImgString = model.smallPhotoUrl
                    CurrentControllerHelper.pushViewController(viewController: vc)
                }else{
                    let detailVC = R.storyboard.study.courseVideoDetailViewController()!
                    let viewModel: CourseWareListViewModel = CourseWareListViewModel(courseID: model.courseID.string)
                    detailVC.userStudyID = model.userStudyID.string
                    detailVC.viewModel = viewModel
                    CurrentControllerHelper.pushViewController(viewController: detailVC)
                }
            })
            .disposed(by: disposeBag)
        
        schoolRollButton.addTarget(self, action: #selector(schoolRollButtonClick), for: .touchUpInside)
        
        guard let model = self.model else { return }
        if model.isNeedSchoolRoll && model.isHasSchoolRoll {
            self.schoolRollButton.isHidden = false
        } else {
            self.schoolRollButton.isHidden = true
        }
    }
    
    @objc func schoolRollButtonClick() {
        let vc = R.storyboard.study.addSchoolRollViewController()!
        
        let vm = ModifySchollRollViewModel(eclassID: self.eclassID)
        vc.bindViewModel(viewModel: vm)
        CurrentControllerHelper.pushViewController(viewController: vc)
    }

}
