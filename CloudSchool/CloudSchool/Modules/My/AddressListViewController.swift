//
//  AddressListViewController.swift
//  CloudSchool
//
//  Created by Maynard on 2018/11/13.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddressListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addButton: BaseButton!
    var viewModel: AddressListViewModel = AddressListViewModel()
    let disposeBag = DisposeBag()
    
    var selectedAddress: Variable<AddressModel?> = Variable(nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        tableView.register(R.nib.addressTableViewCell)
        
        viewModel.data.asObservable().bind(to: tableView.rx.items(cellIdentifier: R.nib.addressTableViewCell.identifier, cellType: AddressTableViewCell.self)) { _, model, cell in
                cell.configure(model: model)
            cell.delegate = self
            }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(AddressModel.self)
            .subscribe(onNext: {[weak self] (model) in
                guard let `self` = self else { return }
                #warning("地址功能优化")
                self.selectedAddress.value = model
            })
        .disposed(by: disposeBag)
        
        addButton.addTarget(self, action: #selector(showAddVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadData()
    }
    
    @objc func showAddVC() {
        let vc = R.storyboard.my.addAddressViewController()!
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
    
    func configureUI() {
        title = viewModel.title
        tableView.backgroundColor = viewModel.backgroudColor
        view.backgroundColor = viewModel.backgroudColor
        tableView.emptyDataSetSource = self
    }

}

extension AddressListViewController: AddressTableViewCellDelegate {
    func editAddress(model: AddressModel) {
        viewModel.editAddress(model: model)
    }
    
    func deleteAddress(model: AddressModel) {
        viewModel.deleteAddress(model: model)
    }
}

import DZNEmptyDataSet
extension AddressListViewController: DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return R.image.common_empty_image()!
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let attributeString = NSAttributedString(string: "没有相关内容", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),
                                                                                            NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "555555")])
        return attributeString
    }
}
