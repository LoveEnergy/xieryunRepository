//
//  CourseVideoListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/23.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CourseVideoListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let disposeBag = DisposeBag()
    var model: StudyModel?
    
    var viewModel: CourseWareListViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
    }
    
    func configureViewModel() {
        guard let model = model else { return }
        let viewModel: CourseWareListViewModel = CourseWareListViewModel(courseID: model.coursewareID.string)
        
        self.viewModel = viewModel
        viewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.courseVideoListTableViewCell.identifier, cellType: CourseVideoListTableViewCell.self)) { _, model, cell in
                cell.configure(model: model)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CourseWareModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                self.performSegue(withIdentifier: "videoDetail", sender: nil)
            })
            .disposed(by: disposeBag)
    }
    
    
    func configureUI() {
        tableView.register(R.nib.courseVideoListTableViewCell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "videoDetail" {
            let vc = segue.destination as! CourseVideoDetailViewController
            vc.viewModel = self.viewModel
        }
    }

}
