//
//  MoreCoursesListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/28.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import RxSwift

class MoreCoursesListViewController: UIViewController {

    
    @IBOutlet weak var segmentControl: BaseSegmentControl!
    @IBOutlet weak var tableView: UITableView!
    
    var data: Variable<[CourseProtocol]> = Variable([Course(), Course(), Course()])
    let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.homeCourseTableViewCell.identifier, cellType: HomeCourseTableViewCell.self)) { _, type, cell in
            
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SettingType.self).subscribe(onNext: { (type) in
            
        }).disposed(by: disposeBag)
        
    }
    
    func configureUI() {
       tableView.delegate = self
        tableView.register(R.nib.homeCourseTableViewCell)
        segmentControl.setTitle("畅销", forSegmentAt: 0)
        segmentControl.setTitle("价格", forSegmentAt: 1)
        segmentControl.setTitle("新课", forSegmentAt: 2)
    }

}

extension MoreCoursesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
