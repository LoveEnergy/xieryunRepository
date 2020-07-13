//
//  EmployViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/7.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmployViewController: UIViewController {
    lazy var titleLab: UILabel = {
        var titleLab = UILabel.init(frame: CGRect(x: 0, y: CGFloat(NAVI_HEIGHT) + 21.5/WIDTH_6_SCALE, width: SCREEN_WIDTH, height: 23/WIDTH_6_SCALE))
        titleLab.font = UIFont.systemFont(ofSize: 22.5)
        titleLab.backgroundColor = .clear
        titleLab.textColor = .black
        titleLab.textAlignment = .center
        titleLab.text = "请选择您的身份"
        return titleLab
    }()
    lazy var staffBtn: UIButton = {
        var staffBtn = UIButton.init(frame: CGRect(x: 25.5/WIDTH_6_SCALE, y: 52/WIDTH_6_SCALE + self.titleLab.bottom, width: SCREEN_WIDTH - 51/WIDTH_6_SCALE, height: 218/WIDTH_6_SCALE))
        staffBtn.setImage(UIImage.init(named: "staff"), for: .normal)
        staffBtn.addTarget(self, action: #selector(staffBtnClick), for: .touchUpInside)
        return staffBtn
    }()
    lazy var bossBtn : UIButton = {
        var bossBtn = UIButton.init(frame: CGRect(x: self.staffBtn.left, y: self.staffBtn.bottom + 18.5/WIDTH_6_SCALE, width: self.staffBtn.width, height: self.staffBtn.height))
        bossBtn.setImage(UIImage.init(named: "boss"), for: .normal)
        return bossBtn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setUpUI()
    }
    func setUpUI(){
        self.view.addSubview(self.titleLab)
        self.view.addSubview(self.staffBtn)
        self.view.addSubview(self.bossBtn)
    }
    
    @objc func staffBtnClick(){
        let vc = EmployHomeViewController.init()
        CurrentControllerHelper.pushViewController(viewController: vc)
    }
}
