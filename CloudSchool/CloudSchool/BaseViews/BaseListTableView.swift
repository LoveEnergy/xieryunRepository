//
//  BaseListTableView.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/12/9.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseListTableView<T: BaseListViewModel>: UITableView, UITableViewDelegate {
    
    let disposeBag = DisposeBag()
    var viewModel: T
    
    init(viewModel: T) {
        self.viewModel = viewModel
        super.init(frame: .zero, style: .plain)
        baseConfigure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func baseConfigure() {
        self.register(UINib(nibName: viewModel.cellType.className, bundle: nil), forCellReuseIdentifier: viewModel.cellIdentifier)
        viewModel.data.asObservable()
            .bind(to: self.rx.items(cellIdentifier: viewModel.cellIdentifier, cellType: viewModel.cellType)){ _, model, cell in
                cell.configure(model: model)
                if T.self == MyLiveViewModel.self{
                    let cell = cell as! LiveTableViewCell
                    cell.goForfrequencyClickBlock = {
                        let model = model as! ClassModel
                        let vc = PlayLiveViewController.init()
                        vc.objectID = model.objectID
                        vc.productID = model.productID
                        vc.teacherID = model.teacherID
                        CurrentControllerHelper.pushViewController(viewController: vc)
                    }
                    cell.goForFillSchoolRollBlock = {
                        let model = model as! ClassModel
                        let vc = R.storyboard.study.addSchoolRollViewController()!
                        vc.isLiveClassSchoolRoll = true
                        let vm = AddSchoolRollViewModel(liveClassID: "\(model.objectID)")
                        vm.showLoadBlock = {
                            HUD.loading(text: "")
                        }
                        vm.hideLoadBlock = {
                            HUD.hideLoading()
                        }
                        vm.fillCompleteBlock = {
                            let vc = PlayLiveViewController.init()
                            vc.objectID = model.objectID
                            vc.productID = model.productID
                            vc.teacherID = model.teacherID
                            CurrentControllerHelper.pushViewController(viewController: vc)
                        }
                        vc.bindViewModel(viewModel: vm)
                        CurrentControllerHelper.pushViewController(viewController: vc)
                    }
                    cell.goForChangeInfoBlock = {
                        let model = model as! ClassModel
                        let vc = R.storyboard.study.addSchoolRollViewController()!
                        vc.isLiveClassSchoolRoll = true
                        let vm = ModifySchollRollViewModel(liveCourseID: "\(model.objectID)")
                        vc.bindViewModel(viewModel: vm)
                        CurrentControllerHelper.pushViewController(viewController: vc)
                    }
                    let liveModel = model as! ClassModel
                    cell.playBackBlock = {
                        let detailVC = R.storyboard.study.courseVideoDetailViewController()!
                        detailVC.downloadBtnHiddenStatus = true
                        let viewModel: CourseWareListViewModel = CourseWareListViewModel(liveCourseID: liveModel.objectID)
                        detailVC.viewModel = viewModel
                        CurrentControllerHelper.pushViewController(viewController: detailVC)
                    }
                    UserHelper.shared.getLivePlayBackFunc(liveCourseID: liveModel.objectID).asObservable()
                    .subscribe(onNext: {[weak self] (list) in
                        guard let `self` = self else { return }
                        if list.code == 200{
                            if list.data!.count > 0 {
                                cell.playBackBtn.isHidden = false
                            }else{
                                cell.playBackBtn.isHidden = true
                            }
                        }
                        }, onError: { (error) in
                            
                    }).disposed(by: self.disposeBag)
                }
            }.disposed(by: disposeBag)
        self.delegate = self
        configureUI()
    }
    
    func configureUI() {
        self.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return viewModel.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if T.self != MyLiveViewModel.self{
            viewModel.didClick(indexPath: indexPath)
        }
    }

}


