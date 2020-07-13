//
//  CourseProductListViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import BetterSegmentedControl
import RxSwift

class CourseProductListViewController: UIViewController {

    @IBOutlet weak var segmentControl: BaseSegmentControl!
    @IBOutlet weak var tableView: UITableView!
    
    var data: Variable<[CourseProtocol]> = Variable([])
    var originalData: [CourseProtocol] = []
    let disposeBag: DisposeBag = DisposeBag()
    
    var parentID: String?
    var seriesID: String?
    
    var currentIndex: Int = 0 {
        didSet {
            switch currentIndex {
            case 0:
                data.value = self.originalData
            case 1:
                data.value = data.value.sorted { (obj1, obj2) -> Bool in
                    return obj1.priceValue < obj2.priceValue
                }
            default:
                data.value = data.value.sorted { (obj1, obj2) -> Bool in
                    return obj1.startTime < obj2.startTime
                }
                break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.homeCourseTableViewCell.identifier, cellType: HomeCourseTableViewCell.self)) { _, type, cell in
                cell.configure(model: type)
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(CourseProtocol.self).subscribe(onNext: { (model) in
            let vc = R.storyboard.home.courseDetailViewController()!
            vc.productID = model.productID.toString()
            vc.productType = model.productType
            CurrentControllerHelper.pushViewController(viewController: vc)
        }).disposed(by: disposeBag)
        
        loadData()
        
    }
    
    func configureUI() {
        tableView.delegate = self
        tableView.register(R.nib.homeCourseTableViewCell)
        segmentControl.setTitle("畅销", forSegmentAt: 0)
        segmentControl.setTitle("价格", forSegmentAt: 1)
        segmentControl.setTitle("新课", forSegmentAt: 2)
        
        segmentControl.rx.controlEvent(UIControl.Event.valueChanged)
            .map { () -> Int in
                return self.segmentControl.selectedSegmentIndex
            }.subscribe(onNext: {[weak self] (value) in
                guard let `self` = self else { return }
                self.currentIndex = value
            })
            .disposed(by: disposeBag)
    }
    
    func loadData() {
//        http://47.92.168.211/cei/front/search_series_product_list?type=&classType=&parentID=23&seriesID=&pageNo=1&pageSize=100
        HUD.loading(text: "")
        RequestHelper.shared.getCoursesProductList(id: self.parentID ?? "", type: "", classType: "", seriesID: self.seriesID ?? "", pageNo: "1", pageSize: "100")
            .asObservable()
            .subscribe(onNext: {[weak self] (list) in
                HUD.hideLoading()
                guard let `self` = self else { return }
                self.data.value = list.data?.rows ?? []
                self.originalData = list.data?.rows ?? []
            })
            .disposed(by: disposeBag)
    }

}

extension CourseProductListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
