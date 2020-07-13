//
//  EmployGuideView.swift
//  CloudSchool
//
//  Created by ENERGY on 2020/3/9.
//  Copyright © 2020 CEI. All rights reserved.
//

import UIKit

class EmployGuideView: UIView {
    public var employGuideViewDismissBlock:(()->())?//消失
    lazy var roleLab : UILabel = {
        weak var weakSelf = self
        var btnY: CGFloat
        if Is_Iphone_X{
            btnY = 44/WIDTH_6_SCALE
        }else{
            btnY = 20/WIDTH_6_SCALE
        }
        var roleLab = UILabel(frame: CGRect(x: 53/WIDTH_6_SCALE, y: btnY + 18/WIDTH_6_SCALE, width: 76/WIDTH_6_SCALE, height: 23/WIDTH_6_SCALE))
        roleLab.text = "招聘者"
        roleLab.font = UIFont.systemFont(ofSize: 16)
        roleLab.textColor = UIColor.colorWithHex(hex: "0378FD")
        roleLab.backgroundColor = .white
        roleLab.textAlignment = .center
        roleLab.layer.cornerRadius = 10/WIDTH_6_SCALE
        roleLab.layer.masksToBounds = true
        return roleLab
    }()
    
    lazy var knowBtn : UIButton = {
        var knowBtn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 131/WIDTH_6_SCALE, height: 53.5/WIDTH_6_SCALE))
        knowBtn.centerX = SCREEN_WIDTH/2
        knowBtn.centerY = SCREEN_HEIGHT/2
        knowBtn.addTarget(self, action: #selector(knowBtnClick), for: .touchUpInside)
        knowBtn.setImage(UIImage.init(named: "employ_I_know"), for: .normal)
        return knowBtn
    }()
    lazy var circleView : UIImageView = {
        var circleView = UIImageView.init()
        circleView.backgroundColor = UIColor.clear
        circleView.image = UIImage.init(named: "employ_circle")
        return circleView
    }()
    lazy var switchView : UIImageView = {
        var switchView = UIImageView.init()
        switchView.image = UIImage.init(named: "employ_switch_id")
        return switchView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.9)
        self.addSubview(self.roleLab)
        self.addSubview(self.knowBtn)
        self.circleView.frame = CGRect(x: 0, y: self.roleLab.top, width: 128.5/WIDTH_6_SCALE, height: 104.5/WIDTH_6_SCALE)
        self.circleView.centerX = self.roleLab.centerX
        self.addSubview(self.circleView)
        self.switchView.frame = CGRect(x: 0, y: self.circleView.bottom, width: 219/WIDTH_6_SCALE, height: 87.5/WIDTH_6_SCALE)
        self.switchView.centerX = self.circleView.right
        self.addSubview(self.switchView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showView(){
        //获取delegate
        let delegate  = UIApplication.shared.delegate as! AppDelegate
        //添加视图
        delegate.window?.addSubview(self)
        UIView.animate(withDuration: 0.15) {
            self.alpha = 1
        }
    }
    
    func dismissView(){
        self.employGuideViewDismissBlock?()
    }
    
    @objc func knowBtnClick(){
        self.dismissView()
    }
}
