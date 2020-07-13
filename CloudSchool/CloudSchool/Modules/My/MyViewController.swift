//
//  MyViewController.swift
//  CloudSchool
//
//  Created by 彭显鹤 on 2018/10/18.
//  Copyright © 2018 CEI. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyViewController: UIViewController {

    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    

    var viewModel: MyViewModel = MyViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的"
        //配置tableView
        tableView.register(R.nib.myTableViewCell)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        setButton.addTarget(self, action: #selector(showSetVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.hidesBottomBarWhenPushed = false
        LoginHelper.shared.updateUserInfo()
    }
    
    @objc func showSetVC() {
        LoginHelper.checkLoginStatus {
            let vc = R.storyboard.my.settingViewController()!
            self.show(vc, sender: nil)
        }
    }

}

extension MyViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.myTableViewCell, for: indexPath)!
        cell.topLineView.isHidden = true
        cell.bottomLineView.isHidden = true
        for x in 0...viewModel.data.count - 1 {
            for y in 0...viewModel.data[x].count - 1{
                if y == viewModel.data[x].count - 1 {
                    if indexPath.section == x && indexPath.row == y {
                        cell.bottomLineView.isHidden = false
                    }
                }
                if y == 0 {
                    if indexPath.section == x && indexPath.row == 0 {
                        cell.topLineView.isHidden = false
                        if x == 0 {
                            cell.topLineView.isHidden = true
                        }
                    }
                }
            }
        }
        let type = viewModel.data[indexPath.section][indexPath.row]
        cell.iconImageView.image = type.iconImage
        cell.titleLabel.text = type.settingTitle
        switch type {
        case .cart:
            CartHelper.shared.goodsNumber.asObservable().bind(to: cell.number).disposed(by: cell.disposeBag)
            
        default:
            cell.numberView.isHidden = true
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.data[indexPath.section][indexPath.row].open()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
