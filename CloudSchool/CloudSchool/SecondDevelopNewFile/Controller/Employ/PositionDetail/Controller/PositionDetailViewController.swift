//
//  PositionDetailViewController.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class PositionDetailViewController: UIViewController {
    lazy var tableView : UITableView = {
        var tableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - CGFloat(BOTTOM_HEIGHT) - 59/WIDTH_6_SCALE - CGFloat(NAVI_HEIGHT)))
        tableView.backgroundColor = .white
        tableView.tableFooterView = self.footerView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PositionDetailTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(PositionDetailTableViewCell.self))
        tableView.rowHeight = 207.5/WIDTH_6_SCALE
        return tableView
    }()
    lazy var headerView : UIView = {
        var headerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 10/WIDTH_6_SCALE))
        headerView.backgroundColor = .white
        return headerView
    }()
    lazy var footerView : UIView = {
        var footerView = UIView.init(frame : CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 50/WIDTH_6_SCALE))
        footerView.backgroundColor = .white
        footerView.addSubview(self.grayLineView)
        self.grayLineView.frame = CGRect(x: 13.5/WIDTH_6_SCALE, y: 10/WIDTH_6_SCALE, width: SCREEN_WIDTH - 27/WIDTH_6_SCALE, height: 2/WIDTH_6_SCALE)
        footerView.addSubview(self.companyIntroductTitleLab)
        footerView.addSubview(self.companyIntroductContentLab)
        self.companyIntroductContentLab.frame = CGRect(x: 24/WIDTH_6_SCALE, y: 20.5/WIDTH_6_SCALE + self.companyIntroductTitleLab.bottom, width: SCREEN_WIDTH - 48/WIDTH_6_SCALE, height: self.getLabelHeight(label: self.companyIntroductContentLab, string: self.companyIntroductContentLab.text!, font: 13, textAlignment: .left, width: SCREEN_WIDTH - 48/WIDTH_6_SCALE))
        footerView.addSubview(self.positionRequireTitleLab)
        footerView.addSubview(self.positionRequireContentLab)
        self.positionRequireTitleLab.frame = CGRect(x: self.companyIntroductTitleLab.left, y: self.companyIntroductContentLab.bottom + 23.5/WIDTH_6_SCALE, width: self.companyIntroductTitleLab.width, height: self.companyIntroductTitleLab.height)
        self.positionRequireContentLab.frame = CGRect(x: self.companyIntroductContentLab.left, y: 20.5/WIDTH_6_SCALE + self.positionRequireTitleLab.bottom, width: self.companyIntroductContentLab.width, height: self.getLabelHeight(label: self.positionRequireContentLab, string: self.positionRequireContentLab.text!, font: 13, textAlignment: .left, width: SCREEN_WIDTH - 48/WIDTH_6_SCALE))
        return footerView
    }()
    lazy var grayLineView : UIView = {
        var grayLineView = UIView.init()
        grayLineView.backgroundColor = UIColor.colorWithHex(hex: "F5F5F5")
        return grayLineView
    }()
    lazy var companyIntroductTitleLab : UILabel = {
        var companyIntroductTitleLab = UILabel.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE + self.grayLineView.bottom, width: 67/WIDTH_6_SCALE, height: 16.5/WIDTH_6_SCALE))
        companyIntroductTitleLab.font = DEF_FontSize_13
        companyIntroductTitleLab.backgroundColor = .clear
        companyIntroductTitleLab.textColor = .black
        companyIntroductTitleLab.textAlignment = .center
        companyIntroductTitleLab.text = "职位介绍:"
        return companyIntroductTitleLab
    }()
    lazy var companyIntroductContentLab : UILabel = {
        var companyIntroductContentLab = UILabel.init()
        companyIntroductContentLab.font = DEF_FontSize_13
        companyIntroductContentLab.backgroundColor = .clear
        companyIntroductContentLab.textColor = UIColor.colorWithHex(hex: "848383")
        companyIntroductContentLab.textAlignment = .left
        companyIntroductContentLab.text = "aaaaaabbbbbbccccccddddddeeeeeeffffffgggggghhhhhhiiiiiijjjjjjkkkkkkllllllmmmmmmnnnnnnooooooppppppqqqqqqrrrrrrsssssstttttt"
        companyIntroductContentLab.lineBreakMode = .byWordWrapping
        companyIntroductContentLab.numberOfLines = 0
        return companyIntroductContentLab
    }()
    lazy var positionRequireTitleLab : UILabel = {
        var positionRequireTitleLab = UILabel.init(frame: CGRect(x: 20/WIDTH_6_SCALE, y: 20/WIDTH_6_SCALE, width: 67/WIDTH_6_SCALE, height: 16.5/WIDTH_6_SCALE))
        positionRequireTitleLab.font = DEF_FontSize_13
        positionRequireTitleLab.backgroundColor = .clear
        positionRequireTitleLab.textColor = .black
        positionRequireTitleLab.textAlignment = .center
        positionRequireTitleLab.text = "职位要求:"
        return positionRequireTitleLab
    }()
    lazy var positionRequireContentLab : UILabel = {
        var positionRequireContentLab = UILabel.init()
        positionRequireContentLab.font = DEF_FontSize_13
        positionRequireContentLab.backgroundColor = .clear
        positionRequireContentLab.textColor = UIColor.colorWithHex(hex: "848383")
        positionRequireContentLab.textAlignment = .left
        positionRequireContentLab.text = "aaaaaabbbbbbccccccddddddeeeeeeffffffgggggghhhhhhiiiiiijjjjjjkkkkkkllllllmmmmmmnnnnnnooooooppppppqqqqqqrrrrrrsssssstttttt"
        positionRequireContentLab.lineBreakMode = .byWordWrapping
        positionRequireContentLab.numberOfLines = 0
        return positionRequireContentLab
    }()
    lazy var sendResumeBtn : UIButton = {
        var sendResumeBtn = UIButton.init(frame: CGRect(x: 15/WIDTH_6_SCALE, y: CGFloat(SCREEN_HEIGHT) - CGFloat(BOTTOM_HEIGHT) - 59/WIDTH_6_SCALE - CGFloat(NAVI_HEIGHT), width: SCREEN_WIDTH - 30/WIDTH_6_SCALE, height: 59/WIDTH_6_SCALE))
        sendResumeBtn.setImage(UIImage.init(named: "sendResumeBtnBG"), for: .normal)
        sendResumeBtn.addTarget(self, action: #selector(sendResumeBtnClick), for: .touchUpInside)
        return sendResumeBtn
    }()
    lazy var sendResumeView : SendResumeView = {
        var sendResumeView = SendResumeView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        sendResumeView.sendResumeViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.sendResumeView.alpha = 0
            }) { (Bool) in
                self.sendResumeView.removeFromSuperview()
            }
        }
        sendResumeView.isUserInteractionEnabled = true
        return sendResumeView
    }()
    
    lazy var noResumeView : NoResumeAlertView = {
        var noResumeView = NoResumeAlertView.init(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT))
        noResumeView.sendResumeViewDismissBlock = {
            UIView.animate(withDuration: 0.15, animations: {
                self.noResumeView.alpha = 0
            }) { (Bool) in
                self.noResumeView.removeFromSuperview()
            }
        }
        noResumeView.isUserInteractionEnabled = true
        return noResumeView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.view.addSubview(self.tableView)
        self.view.addSubview(self.sendResumeBtn)
    }
}

extension PositionDetailViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: PositionDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(PositionDetailTableViewCell.self), for: indexPath) as! PositionDetailTableViewCell
        cell.contentView.backgroundColor = .clear
        cell.companyDetailBlock = {
            let vc = CompanyDetailViewController.init()
            vc.title = "公司详情"
            CurrentControllerHelper.pushViewController(viewController: vc)
        }
        return cell
    }
}

extension PositionDetailViewController{
    //label高度
    func getLabelHeight(label:UILabel, string:String, font:CGFloat, textAlignment:NSTextAlignment, width:CGFloat)->CGFloat{
        label.text = string
        label.font = UIFont.systemFont(ofSize: font)
        label.textAlignment = textAlignment
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.numberOfLines = 0
        let size = label.sizeThatFits(CGSize(width: width, height: CGFloat(MAXFLOAT)))
        return size.height
    }
    @objc func sendResumeBtnClick(){
//        self.sendResumeView.showView()
        self.noResumeView.showView()
    }
}
