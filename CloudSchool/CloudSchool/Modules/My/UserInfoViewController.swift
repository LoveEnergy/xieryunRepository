//
//  UserInfoViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/11/11.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit

enum UserInfoType {
    case avator(viewModel: AvatorViewModel)
    case phone(_ phone: String)
    case email(viewModel: UserInfoViewModel)
    case password
    case nickname(viewModel: UserInfoViewModel)
    case gender(viewModel: GenderViewModel)
    case region
    case work
    
    var height: CGFloat {
        switch  self {
        case .avator:
            return 87
        default:
            return 44
        }
    }
    
    var title: String {
        switch self {
        
        case .avator:
            return "头像"
        case .phone:
            return "绑定手机"
        case .email:
            return "邮箱"
        case .password:
            return "修改密码"
        case .nickname:
            return "昵称"
        case .gender:
            return "性别"
        case .region:
            return "地区"
        case .work:
            return "职业"
        }
    }
    
    var detail: String {
        switch self {
            
        case .avator:
            return ""
        case .phone(let phone):
            return phone
        case .email(let viewModel):
            return viewModel.type.value
        case .password:
            return ""
        case .nickname(let viewModel):
            return viewModel.type.value
        case .gender:
            return ""
        case .region:
            return ""
        case .work:
            return ""
        }
    }
    
    func click() {
        switch self {
        case .avator(let viewModel):
            viewModel.clickToChange()
        case .gender(let viewModel):
            viewModel.clickToChange()
        case .phone:
            let vc = R.storyboard.login.bindPhoneViewController()!
            CurrentControllerHelper.pushViewController(viewController: vc)
        case .password:
            let vc = R.storyboard.login.registerViewController()!
            vc.isRegister = false
            CurrentControllerHelper.pushViewController(viewController: vc)
        case .nickname(let viewModel), .email(let viewModel):
            viewModel.clickToChange()
            
        default:
            break
        }
    }
}

import RxSwift

class UserInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var data: [[UserInfoType]] = []
    let disposeBag: DisposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "个人信息"
        tableView.register(R.nib.userAvatorTableViewCell)
        tableView.register(R.nib.baseInfoTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        updateData()
        
        LoginHelper.shared.currentUser.asObservable()
            .subscribe(onNext: {[weak self] (_) in
                guard let `self` = self else { return }
                self.updateData()
            })
        .disposed(by: disposeBag)
    }
    
    func updateData() {
        guard let user = LoginHelper.shared.currentUser.value else {
            HUD.showText(text: "没有用户信息")
            return
        }
//        UserInfoViewModel(type: .nickName(value: user.nickName))
//        UserInfoViewModel(type: .email(value: user.email))
        data = [[.avator(viewModel: AvatorViewModel())], [.phone(user.phone), .password], [.nickname(viewModel: UserInfoViewModel(type: .nickName(value: user.nickName))), .gender(viewModel: GenderViewModel())]]
        self.tableView.reloadData()
    }
}

extension UserInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = data[indexPath.section][indexPath.row]
        
        switch type {
        case .avator(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.userAvatorTableViewCell, for: indexPath)!
            cell.titleLabel.text = type.title
            viewModel.avator.asObservable().bind(to: cell.avatorImageView.rx.image)
            .disposed(by: cell.disposeBag)
            return cell
            
            
        case .gender(let viewModel):
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.baseInfoTableViewCell, for: indexPath)!
            cell.titleLabel.text = type.title
            viewModel.gender.asObservable()
                .map { (gender) -> String in
                    return gender.rawValue
            }.bind(to: cell.detailInfoLabel.rx.text)
            .disposed(by: cell.disposeBag)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.baseInfoTableViewCell, for: indexPath)!
            cell.titleLabel.text = type.title
            cell.detailInfoLabel.text = type.detail
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = data[indexPath.section][indexPath.row]
        return type.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = data[indexPath.section][indexPath.row]
        type.click()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
