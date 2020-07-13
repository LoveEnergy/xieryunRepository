//
//  SettingViewController.swift
//  KuTing
//
//  Created by Maynard on 2018/3/20.
//  Copyright © 2018年 Pengxianhe. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SettingViewController: UIViewController {
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: SetViewModel = SetViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        //配置tableView
        
        tableView.register(R.nib.setTableViewCell)
        viewModel.data.bind(to: tableView.rx.items(cellIdentifier: R.nib.setTableViewCell.identifier, cellType: SetTableViewCell.self)) { _, type, cell in
            cell.titleLabel.text = type.settingTitle
            cell.iconImageView.image = type.iconImage
        }.disposed(by: disposeBag)
        
        tableView.rx.modelSelected(SettingType.self).subscribe(onNext: { (type) in
            type.open()
        }).disposed(by: disposeBag)
        
        logoutButton.addTarget(self, action: #selector(logout(_:)), for: .touchUpInside)
    }
    
    func configureUI() {
        title = "设置"
        logoutButton.setBackgroundColor(UIColor.mainRedColor, forState: .normal)
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }

    @objc func logout(_ sender: Any) {
//        LoginHelper.logout {
//            self.navigationController?.popViewController(animated: true)
//        }
        UserHelper.shared.logoutAccount()
        .asObservable()
        .subscribe(onNext: {[weak self] (model) in
            guard let `self` = self else { return }
            if let jsonString = UserDefaults.User.string(forKey: .localUserInfo) {
                let user = UserInfo(JSONString: jsonString)
                UMessage.removeAlias("\(String(describing: user!.userID))", type: "CEI") { (responseObject, error) in
                }
            }
            UserDefaults.standard.removeObject(forKey: UserDefaults.User.namespace(UserDefaults.User.StringDefaultKey.localUserInfo))
            UserDefaults.User.set("", forKey: .token)
            LoginHelper.shared.currentUser.value = nil
            self.navigationController?.popViewController(animated: true)
            }, onError: { (error) in

        })
        .disposed(by: self.disposeBag)
    }
}

